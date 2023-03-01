import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rocks/blocs/collection_bloc/collection_bloc.dart';
import 'package:rocks/blocs/reference_bloc/reference_bloc.dart';
import 'package:rocks/screens/collection.dart';
import 'package:rocks/screens/detail.dart';

import 'Objects/collection_rock.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeData theme = ThemeData(primarySwatch: Colors.purple,);
  final ReferenceBloc referenceBloc = ReferenceBloc();
  final CollectionBloc collectionBloc = CollectionBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    referenceBloc.add(SaveReferenceData());
    collectionBloc.add(LoadCollection());

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: referenceBloc),
          BlocProvider.value(value: collectionBloc)
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: theme,
            initialRoute: 'home',
            onGenerateRoute: (settings){
              if (settings.name == RockDetailScreen.routeName) {
                final args = settings.arguments as CollectionRock;
                return MaterialPageRoute(builder: (context){
                  return RockDetailScreen(args);
                });
              }

               },
            home: const CollectionPage()
        ),
    );
  }
}

