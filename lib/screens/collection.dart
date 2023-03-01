import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rocks/Objects/collection_rock.dart';
import 'package:rocks/screens/addRock.dart';
import 'package:rocks/screens/detail.dart';

import '../blocs/collection_bloc/collection_bloc.dart';
import '../blocs/reference_bloc/reference_bloc.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final ReferenceBloc _referenceBloc = ReferenceBloc();
  bool list = true;

  @override
  void initState() {
    _referenceBloc.add(SaveReferenceData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget toggle()=>
        Switch(value: list,
            onChanged: (val){
              setState(() {
                list = !list;
              });
            },
          activeColor: Colors.white,
        );

    return Scaffold(
        appBar: AppBar(
          actions: [toggle()],
          title: const Text("Rock Collection"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Center(
            child: Icon(Icons.add),
          ),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.95,
                    minWidth: MediaQuery.of(context).size.width * 0.95,
                    minHeight: MediaQuery.of(context).size.height * 0.9),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                context: context,
                builder: (context) => AddRockScreen());
          },
        ),
        body: BlocBuilder<CollectionBloc, CollectionState>(
          builder: (context, state) {
            if (state is CollectionLoading || state is CollectionInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CollectionLoaded) {

              return ListView(
                  children: state.collectionRocks
                      .map((i) => RockListCard(rock: i))
                      .toList());
            }
            return Container();
          },
        ));
  }
}

class RockListCard extends StatelessWidget {
  CollectionRock rock;
  RockListCard({required this.rock});

  @override
  Widget build(BuildContext context) {
    const double boxSize = 100;
    const double cardRadius = 5;

    String species = rock.species == null || rock.species!.isEmpty ? "SPECIES" : rock.species!;
    final String collectionNum =
        rock.collectionId == null ? "COLLECTION_ID" : rock.collectionId!.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Dismissible(
        key: Key(rock.id!.toString()),
        onDismissed: (dir) {
          BlocProvider.of<CollectionBloc>(context)
              .add(RemoveCollectionRock(rock: rock));
        },
        background: Container(color: Colors.red),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 5,
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(cardRadius))),
            child: Center(
              child: InkWell(
                onTap: () => {
                  Navigator.pushNamed(context, RockDetailScreen.routeName,
                      arguments: rock)
                },
                child: Row(
                  children: [
                    Container(
                        width: boxSize,
                        height: boxSize,
                        decoration: BoxDecoration(
                            image: rock.primaryPhoto == null
                                ? null
                                : DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(rock.primaryPhoto!))))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(species, style: Theme.of(context).textTheme.titleLarge,),
                              Container(height: 5,),
                              Text(collectionNum),
                              Container(height: 30,),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
