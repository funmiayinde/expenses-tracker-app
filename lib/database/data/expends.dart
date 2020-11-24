class Expends {
  static const String columnId = 'id';
  static const String columnIdCategory = 'id_category';
  static const String columnDate = 'date';
  static const String columnMonth = 'month';
  static const String columnTimestamp = 'timestamp';
  static const String columnDescription = 'description';
  static const String columnExpends = 'expends';
  static const String columnPlace = 'place';

  int id;
  int idCategory;
  String date;
  String month;
  String timestamp;
  String description;
  double expends;
  String place;

  Expends({
    this.id,
    this.idCategory,
    this.date,
    this.month,
    this.timestamp,
    this.description,
    this.expends,
    this.place,
  });

  factory Expends.fromJson(Map<String, dynamic> json) => new Expends(
        id: json["id"],
        idCategory: json["id_category"],
        date: json["date"],
        month: json["month"],
        timestamp: json["timestamp"],
        description: json["description"],
        expends: json["expends"].toDouble(),
        place: json["place"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_category": idCategory,
        "date": date,
        "month": month,
        "timestamp": timestamp,
        "description": description,
        "expends": expends,
        "place": place,
      };

  factory Expends.fromMap(Map<String, dynamic> json) => new Expends(
        id: json["id"],
        idCategory: json["id_category"],
        date: json["date"],
        month: json["month"],
        timestamp: json["timestamp"],
        description: json["description"],
        expends: json["expends"].toDouble(),
        place: json["place"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "id_category": idCategory,
        "date": date,
        "month": month,
        "timestamp": timestamp,
        "description": description,
        "expends": expends,
        "place": place,
      };
}
