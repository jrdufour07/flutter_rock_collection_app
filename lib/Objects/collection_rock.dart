class CollectionRock{
  ///IDENTIFICATION
  int? id;
  String? species;
  String? speciesId;
  String? collectionId;
  String? primaryPhoto;
  List<String> photos = [];

  ///MINING AND ACQUIRING
  int? payedAmount;
  String? yearPurchased;
  String? purchasedFrom;
  String? locationPurchased;
  String? mine;
  String? localeCountry;
  String? localeState;
  String? notes;

  ///CHEMISTRY
  String? primaryMineral;
  List<String>? secondaryMinerals;
  String? chemFormula;

  static const speciesDisplay = "Species";
  static const collectionNumberDisplay = "Collection No.";
  static const speciesNumberDisplay = "Species No.";

       static const String tableName = "collection_rocks";
  static const String createRocksTable = "CREATE TABLE $tableName("
      "id INTEGER PRIMARY KEY, species STRING, species_id STRING, collection_id STRING, primary_photo STRING, "
      "payed_amount INTEGER, year_purchased STRING, purchased_from STRING, location_purchased STRING, mine STRING, "
      "locale STRING, locale_state STRING, notes STRING, primary_mineral STRING, chemical_formula STRING)";

  CollectionRock(this.species){
    photos = [];
  }

  CollectionRock.basic(this.species, this.speciesId, this.primaryPhoto){
    photos = [];
  }

  void generateCollectionId({int numPrefixChars = 3}){
    if(species != null && species!.length > numPrefixChars){
      String prefix = species!.substring(0, numPrefixChars);
      if(speciesId != null && speciesId!.isNotEmpty){
        collectionId = "$prefix-${speciesId!}".toUpperCase();
      }
    }

  }

  CollectionRock.fromJson(Map<String, dynamic> json)
      : id                = json['id'],
        species           = json['species'],
        speciesId         = json['species_id'].toString(),
        collectionId      = json['collection_id'].toString(),
        primaryPhoto      = json['primary_photo'],

        payedAmount       = json['payed_amount'],
        yearPurchased     = json['year_purchased'],
        purchasedFrom     = json['purchased_from'],
        locationPurchased = json['location_purchased'],
        mine              = json['mine'],
        localeCountry     = json['locale'],
        localeState       = json['locale_state'],
        notes             = json['notes'],
        primaryMineral    = json['primary_mineral'],
        chemFormula       = json['chemical_formula'];

        Map<String, dynamic> toJson() => {
          "id"                : id,
          "species"           : species,
          "species_id"        : speciesId,
          "collection_id"     : collectionId,
          "primary_photo"     : primaryPhoto,
          "payed_amount"      : payedAmount,
          "year_purchased"    : yearPurchased,
          "purchased_from"    : purchasedFrom,
          "location_purchased": locationPurchased,
          "mine"              : mine,
          "locale"            : localeCountry,
          "locale_state"      : localeState,
          "notes"             : notes,
          "primary_mineral"   : primaryMineral,
          "chemical_formula"      : chemFormula
        };
}