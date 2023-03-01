import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rocks/Objects/collection_rock.dart';
import 'package:rocks/blocs/collection_bloc/collection_bloc.dart';
import 'package:rocks/blocs/reference_bloc/reference_bloc.dart';
import 'package:rocks/reusable_widgets/reusable_widgets.dart';

class AddRockScreen extends StatefulWidget {
  AddRockScreen({super.key});

  @override
  State<AddRockScreen> createState() => _AddRockScreenState();
}

class _AddRockScreenState extends State<AddRockScreen> {
  CollectionRock newRock = CollectionRock("");
  late TextEditingController _speciesController;
  late TextEditingController _speciesIdController;
  late TextEditingController _collectionIdController;
  late FocusNode _speciesNode;

  final fieldSpacing = 20.0;

  @override
  void initState() {
    _speciesController = TextEditingController()
      ..text = newRock.species?? ""
      ..addListener(() {
        newRock.species = _speciesController.text;
      });
    _speciesIdController = TextEditingController();
    _collectionIdController = TextEditingController();
    _speciesNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _speciesController.dispose();
    _speciesIdController.dispose();
    _collectionIdController.dispose();
    _speciesNode.dispose();
    super.dispose();
  }

  void saveRock(){
    newRock.species = _speciesController.text.trim();
    newRock.speciesId = _speciesIdController.text.trim();
    newRock.collectionId = _collectionIdController.text.trim();
    BlocProvider.of<CollectionBloc>(context)
        .add(AddCollectionRock(rock: newRock));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget speciesAutocomplete() {
      return BlocBuilder(
        bloc: BlocProvider.of<ReferenceBloc>(context),
        builder: (context, state) {
          String hint = CollectionRock.speciesDisplay;
          if (state is ReferenceDataLoaded) {
            return ReusableWidgets.underlinedTextFieldWithAutocomplete(
              context,
              hint,
              state.referenceRocks
                  .map((e) => e.title != null ? e.title! : "")
                  .toList(),
              _speciesController,
              minChars: 2,
            );
          }
          return ReusableWidgets.underlinedTextField(
              context, hint, _speciesController);
        },
      );
    }

    Widget saveButton() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              saveRock();
            },
            child: const Text("Save")),
      );
    }

    Widget cancelButton() {
      return TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"));
    }

    Widget buttonHolder() {
      return  Row(
        children: [
          Expanded(child: cancelButton()),
          Expanded(child: saveButton())
        ],
      );
    }

    _ids(){
      final children = [
        Expanded(
          child: ReusableWidgets.underlinedTextField(
              context, CollectionRock.speciesNumberDisplay, _speciesIdController,
              inputType: const TextInputType.numberWithOptions(),
              callback: (){
                newRock.species = _speciesController.text;
                newRock.speciesId = _speciesIdController.text;
                newRock.generateCollectionId();
                _collectionIdController.text= newRock.collectionId?? "";
              }
          ),
        ),

        Container(width: 20,),
        Expanded(
          child: ReusableWidgets.underlinedTextField(
            context,
            CollectionRock.collectionNumberDisplay,
            _collectionIdController,
            enabled: false
          ),
        ),
      ];
      return SizedBox(
        child: Row(
          children: children
        ),
      );
    }

    ///MAIN LIST
    List<Widget> items() => [
          Text(
            "New Specimen",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ImageDisplay(
            rock: newRock,
            callback: () {
              _speciesNode.requestFocus();
            },
          ),
          speciesAutocomplete(),
          _ids(),
          Container(height: MediaQuery.of(context).size.height * 0.5,)
        ];

    List<Widget> content() {
      List<Widget> content = [];
      items().forEach((element) {
        content.add(Padding(
          padding: EdgeInsets.all(fieldSpacing / 2),
          child: element,
        ));
      });
      return content;
    }

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        color: Colors.transparent,
        child: Scaffold(
          backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            bottomSheet: buttonHolder(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: content(),),
            )),
      ),
    );
  }
}
