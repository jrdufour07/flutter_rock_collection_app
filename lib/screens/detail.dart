// A Widget that extracts the necessary arguments from
// the ModalRoute.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rocks/Objects/collection_rock.dart';
import 'package:rocks/reusable_widgets/RandomMap.dart';
import 'package:rocks/reusable_widgets/reusable_widgets.dart';
import '../blocs/collection_bloc/collection_bloc.dart';
import '../blocs/reference_bloc/reference_bloc.dart';
import 'package:countries_world_map/countries_world_map.dart';

class RockDetailScreen extends StatefulWidget {

  static const routeName = '/rockDetail';
  final CollectionRock rock;

  const RockDetailScreen(this.rock, {super.key});

  @override
  State<RockDetailScreen> createState() => _RockDetailScreenState();
}

class _RockDetailScreenState extends State<RockDetailScreen> {
  late TextEditingController _speciesController = TextEditingController();
  late TextEditingController _speciesIdController = TextEditingController();
  late TextEditingController _collectionIdController = TextEditingController();

  late CollectionRock rock;
  bool editMode = false;


  @override
  void initState() {
      rock = widget.rock;
     _speciesController = TextEditingController()
    ..text = rock.species?? "";

      _speciesIdController = TextEditingController()
    ..text = rock.speciesId?? "";

      _collectionIdController = TextEditingController()
    ..text = rock.collectionId?? "";

    super.initState();
  }

  @override
  void dispose() {
    _speciesController.dispose();
    _speciesIdController.dispose();
    _collectionIdController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String species = rock.species == null? "SPECIES" : rock.species!;
   // String collectionId = rock.collectionId == null ? "ID" : rock.collectionId!;

    Widget _ids(){
      final children = [
        Expanded(
          child: ReusableWidgets.underlinedTextField(
              context, CollectionRock.speciesNumberDisplay, _speciesIdController,
              inputType: const TextInputType.numberWithOptions(),
              enabled: editMode,
              callback: (){
                rock.species = _speciesController.text;
                rock.speciesId = _speciesIdController.text;
                rock.generateCollectionId();
                _collectionIdController.text= rock.collectionId?? "";
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

    void saveRock(){
      rock.species = _speciesController.text.trim();
      rock.speciesId = _speciesIdController.text.trim();
      rock.generateCollectionId();
      BlocProvider.of<CollectionBloc>(context)
          .add(SaveCollectionRock(rock: rock));
    }

    Widget editButton(){
      return IconButton(
        icon: Icon(editMode ? Icons.save : Icons.edit),
        onPressed: (){
          if(editMode){
            saveRock();
          }
          setState(() {
            editMode = !editMode;
          });
        },
      );
    }

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
              enabled: editMode
            );
          }
          return ReusableWidgets.underlinedTextField(
              context, hint, _speciesController);
        },
      );
    }
    Widget locationPicker(){
      return Row(
        children: [
          Expanded(child:
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container()
                    ),
                    Expanded(
                        child: SizedBox(
                          height: 400,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: MapGenerator(rock.localeCountry),
                              ),
                              LocationPicker(rock, enabled: editMode, onCountrySelected: (){
                                setState(() {});
                              },),


                            ],
                          ),
                        ))
                  ],
                ),
              ))),
        ],
      );
    }

    const double listSpacing = 10.0;
    List<Widget> content = [
      ImageDisplay(rock: rock),
      speciesAutocomplete(),
      _ids(),
      locationPicker()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(species),
        actions: [editButton()],
      ),
      body: ListView(
        children:content.map((e) => Padding(
          padding: const EdgeInsets.all(listSpacing),
          child: e,
        )).toList()
      )
    );
  }
}

