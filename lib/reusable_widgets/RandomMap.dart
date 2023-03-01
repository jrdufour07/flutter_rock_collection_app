import 'dart:math';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/continents/africa.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MapGenerator extends StatefulWidget {
  MapGenerator(this.countryName, {Key? key}) : super(key: key);
  String? countryName;

  @override
  _MapGeneratorState createState() => _MapGeneratorState();
}

class _MapGeneratorState extends State<MapGenerator> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapData? data = MapData.getData().firstWhereOrNull(
            (element){return widget.countryName!.contains(element.name!);});
    if(data == null) return Container();

    return  InteractiveViewer(
      maxScale: 75.0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        // Actual widget from the Countries_world_map package.
        child: SimpleMap(
          instructions: data.instructions?? "",
          defaultColor: Theme.of(context).primaryColorDark,
          colors: data.colorMap,

        ),
      ),
    );
  }
}
class MapData{
  String? instructions;
  String? name;
  List<String> colorKeys = [];
  List<Color> colors = [];
  Map<String, Color?>? colorMap;

  MapData(this.name, this.instructions, this.colorKeys, this.colors){
    colorMap = {};
    final _random = Random();
    for (var element in colorKeys) {
      colorMap?.addAll({element: colors[_random.nextInt(colors.length)]});
    }
  }
  static List<MapData> getData(){
    final colors = [Colors.teal, Colors.indigo];
    return [
      MapData("United States",  SMapUnitedStates.instructions, SMapUnitedStatesColors().toMap().keys.toList(), colors),
      MapData("Canada",         SMapCanada.instructions, SMapCanadaColors().toMap().keys.toList(), colors),
      MapData("Mexico",         SMapMexico.instructions, SMapMexicoColors().toMap().keys.toList(), colors),

      MapData("Spain",      SMapSpain.instructions, SMapSpainColors().toMap().keys.toList(), colors),
      MapData("Argentina",  SMapArgentina.instructions, SMapArgentinaColors().toMap().keys.toList(), colors),
      MapData("Brazil",     SMapBrazil.instructions, SMapBrazilColors().toMap().keys.toList(), colors),
      MapData("Colombia ",  SMapColombia.instructions, SMapColombiaColors().toMap().keys.toList(), colors),
      MapData("Peru ",      SMapPeru.instructions, SMapPeruColors().toMap().keys.toList(), colors),

      MapData("China",      SMapChina.instructions, SMapChinaColors().toMap().keys.toList(), colors),
      MapData("Japan",      SMapJapan.instructions, SMapJapanColors().toMap().keys.toList(), colors),
      MapData("Russia",     SMapRussia.instructions, SMapRussiaColors().toMap().keys.toList(), colors),
      MapData("India",      SMapIndia.instructions, SMapIndiaColors().toMap().keys.toList(), colors),


      MapData("Turkey",   SMapTurkey.instructions, SMapTurkeyColors().toMap().keys.toList(), colors),
      MapData("Pakistan", SMapPakistan.instructions, SMapPakistanColors().toMap().keys.toList(), colors),
      MapData("Iran",     SMapIran.instructions, SMapIranColors().toMap().keys.toList(), colors),


      MapData("Morocco",      SMapMorocco.instructions, SMapMoroccoColors().toMap().keys.toList(), colors),
      MapData("Madagascar",   SMapAfrica.instructions, SMapAfricaColors().toMap().keys.toList(), colors),
      MapData("South Africa", SMapSouthAfrica.instructions, SMapSouthAfricaColors().toMap().keys.toList(), colors),
      MapData("Namibia",      SMapNamibia.instructions, SMapNamibiaColors().toMap().keys.toList(), colors),
      MapData("Congo",        SMapCongoDR.instructions, SMapCongoDRColors().toMap().keys.toList(), colors),


      MapData("Norway",         SMapNorway.instructions, SMapNorwayColors().toMap().keys.toList(), colors),
      MapData("France",         SMapFrance.instructions, SMapFranceColors().toMap().keys.toList(), colors),
      MapData("United Kingdom", SMapUnitedKingdom.instructions, SMapUnitedKingdomColors().toMap().keys.toList(), colors),

      MapData("Australia",      SMapAustralia.instructions, SMapAustraliaColors().toMap().keys.toList(), colors),

    ];
  }
}