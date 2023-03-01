import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rocks/utils.dart';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../Objects/collection_rock.dart';

class ReusableWidgets {
  static const double rad = 21;
  static Widget underlinedTextField(BuildContext context, String placeholder, TextEditingController controller,
      {FocusNode? fNode, TextInputType? inputType, enabled = true, Function? callback}) {
    return
        PhysicalModel(
          color: Theme.of(context).secondaryHeaderColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(rad), bottomLeft: Radius.circular(rad)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(rad), bottomLeft: Radius.circular(rad)),
              border: Border.fromBorderSide(
                  BorderSide(
                      width: 1.5,
                      color: Theme.of(context).primaryColor),)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                readOnly: !enabled,
                keyboardType: inputType,
                controller: controller,
                focusNode: fNode,
                onEditingComplete: callback?.call(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: placeholder,
                ),
              ),
            ),
          ),
    );
  }

  static Widget underlinedTextFieldWithAutocomplete(
      BuildContext context, String placeholder, List<String> options, TextEditingController controller,
      {int minChars = 1, FocusNode? fNode, Function? callback, enabled = true}) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          //putting this here to get the focus node working without overriding Autocomplete's fnode
          Focus(
            focusNode: fNode,
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                FocusScope.of(context).nextFocus();
              }
            },
            child: Container(),
          ),
          PhysicalModel(
              color: Theme.of(context).secondaryHeaderColor,
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(rad), bottomLeft: Radius.circular(rad)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(rad), bottomLeft: Radius.circular(rad)),
                    border: Border.fromBorderSide(
                      BorderSide(
                          width: 1.5,
                          color: Theme.of(context).primaryColor),)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Autocomplete<String>(
                    ///TEXT FIELD
                    fieldViewBuilder: (context, textEditController, f, fn) {
                      textEditController.text = controller.text;
                      return TextFormField(
                        enabled: enabled,
                        controller: textEditController,
                        focusNode: f,
                        onEditingComplete: (){
                          fn.call();
                          callback?.call();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: placeholder,
                        ),
                      );
                    },

                    ///WHAT TO DISPLAY
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.length < minChars) {
                        return const Iterable<String>.empty();
                      }
                      List<String> returnValues = options.where((String option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      }).toList();

                      returnValues.sort((a, b) {
                        if (a.toLowerCase().startsWith(textEditingValue.text.toLowerCase())) return -1;
                        if (b.toLowerCase().startsWith(textEditingValue.text.toLowerCase())) return 1;
                        return a.compareTo(b);
                      });

                      return returnValues;
                    },

                    /// AUTOCOMPLETE LIST BUILDER
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: 52.0 * options.length,
                                maxWidth: constraints.maxWidth),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return InkWell(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: Builder(builder: (BuildContext context) {
                                    final bool highlight =
                                        AutocompleteHighlightedOption.of(context) ==
                                            index;
                                    if (highlight) {
                                      SchedulerBinding.instance!
                                          .addPostFrameCallback((Duration timeStamp) {
                                        Scrollable.ensureVisible(context,
                                            alignment: 0.5);
                                      });
                                    }
                                    return Container(
                                      color: highlight
                                          ? Theme.of(context).focusColor
                                          : null,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(option),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },

                    onSelected: (String selection) {
                      controller.text = selection;
                    },
                  ),
                ),
              )
          ),
        ],
      );
    });
  }
}

class ImageDisplay extends StatefulWidget {
  ImageDisplay({Key? key, required this.rock, this.callback}) : super(key: key);
  final CollectionRock rock;
  Function? callback;

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  double displayHeight = 0.35;
  double padding = 10;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double photoContainerHeight = screenHeight * displayHeight;

    Widget addImageButton = SizedBox(
        height: 100,
        width: 100,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white),
            onPressed: () async {
              XFile? imageFile = await Utils().getImageFromSource(context);
              if (imageFile != null) {
                widget.callback?.call();
                setState(() {
                  widget.rock.primaryPhoto ??= imageFile.path;
                  widget.rock.photos.add(imageFile.path);
                });
              }
            },
            child: Icon(
              Icons.camera_alt_outlined,
              size: widget.rock.primaryPhoto == null ? 60 : 30,
              color: Theme.of(context).primaryColor,
            )));

    Widget smallPhotoTile(String imagePath) {
      return Expanded(
          child: Container(
        height: photoContainerHeight / 3,
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: FileImage(File(imagePath)))),
      ));
    }

    List<Widget> rightRow = [
      widget.rock.photos.length > 1
          ? smallPhotoTile(widget.rock.photos[1])
          : Container(),
      widget.rock.photos.length > 2
          ? smallPhotoTile(widget.rock.photos[2])
          : Container(),
      Expanded(child: addImageButton)
    ];

    Widget mainImage() {
      return Container(
          width: screenWidth * 0.7,
          color: Colors.pink,
          child: widget.rock.primaryPhoto == null
              ? Container(
                  color: Colors.pink,
                )
              : Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(widget.rock.primaryPhoto!)))),
                ));
    }

    return widget.rock.primaryPhoto == null
        ? Column(
            children: [
              Center(
                child: addImageButton,
              ),
            ],
          )
        : Card(
            elevation: 5,
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Container(
              height: photoContainerHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  mainImage(),
                  Expanded(
                    child: Column(children: rightRow),
                  )
                ],
              ),
            ),
          );
  }
}

class LocationPicker extends StatelessWidget{
  CollectionRock rock;

  bool enabled;
  String? country;
  String? state;
  String? city;
  Function? onCountrySelected;
  Function? onStateSelected;


  CscCountry? getCountryFromString(String country){
    return CscCountry.values.firstWhereOrNull((c) => c.toString().contains(country));
  }
  LocationPicker(this.rock, {super.key, this.enabled = true, this.onCountrySelected, this.onStateSelected});

  @override
  Widget build(BuildContext context) {

    return CSCPicker(
      ///Enable disable state dropdown [OPTIONAL PARAMETER]
      hideStatesWhenNone: true,
      hideCitiesWhenNone: true,
      flagState: CountryFlag.DISABLE,
      currentCountry: rock.localeCountry,
      layout: Layout.vertical,

      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
      dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border:
          Border.all(color: Colors.grey.shade300, width: 1)),

      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
      disabledDropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.grey.shade300,
          border:
          Border.all(color: Colors.grey.shade300, width: 1)),

      ///placeholders for dropdown search field
      countrySearchPlaceholder: "Country",
      stateSearchPlaceholder: "State",
      citySearchPlaceholder: "City",
      ///labels for dropdown
      countryDropdownLabel: "Country",
      stateDropdownLabel: "State",
      cityDropdownLabel: "City",

      ///Disable country dropdown (Note: use it with default country)
      disableCountry: !enabled,

      ///selected item style [OPTIONAL PARAMETER]
      selectedItemStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),

      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
      dropdownHeadingStyle: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold),

      ///DropdownDialog Item style [OPTIONAL PARAMETER]
      dropdownItemStyle: TextStyle(
        fontSize: 14,
      ),

      ///Dialog box radius [OPTIONAL PARAMETER]
      dropdownDialogRadius: 10.0,

      ///Search bar radius [OPTIONAL PARAMETER]
      searchBarRadius: 10.0,

      ///triggers once country selected in dropdown
      onCountryChanged: (value) {
        rock.localeCountry = value;
        onCountrySelected?.call();
      },

      ///triggers once state selected in dropdown
      onStateChanged: (value) {
        rock.localeState = value;
      },

      ///triggers once city selected in dropdown
      onCityChanged: (value) {
      },
    );
  }

}