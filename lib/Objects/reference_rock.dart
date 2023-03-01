class ReferenceRock{
  int? id;
  String? title;
  String? externalId;

  ReferenceRock(this.id, this.title, this.externalId);

  static const String tableName = "reference_rocks";
  static const String createRockTable = "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, title STRING UNIQUE, _id STRING)";

  ReferenceRock.fromJson(Map<String, dynamic> json)
    : id         = json['id'],
      title      = json['title'],
      externalId = json['_id'];

  Map<String, dynamic> toJson() => {
    "id"    : id,
    "title" : title,
    "_id"   : externalId
  };
}