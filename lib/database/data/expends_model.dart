class ExpendsModel {
  static const String columnId = 'id';
  static const String columnIdCategory = 'id_category';
  static const String columnDate = 'date';
  static const String columnDescription = 'description';
  static const String columnExpends = 'expends';
  static const String columnCategoryName = 'name';

  int id;
  int idCategory;
  String date;
  String timestamp;
  String description;
  double expends;
  String categoryName;
  String place;
  String color;
  String icon;

  ExpendsModel({
    this.id,
    this.idCategory,
    this.date,
    this.timestamp,
    this.description,
    this.expends,
    this.categoryName,
    this.place,
    this.color,
    this.icon,
  });

  factory ExpendsModel.fromJson(Map<String, dynamic> json) => new ExpendsModel(
        id: json["id"],
        idCategory: json["id_category"],
        date: json["date"],
        timestamp: json["timestamp"],
        description: json["description"],
        expends: json["expends"].toDouble(),
        categoryName: json["name"],
        place: json["place"],
        color: json["color"],
        icon: json["icon"],
      );

  /// this is to avoid assets path error for existing users,
  /// As earlier icons was not in assets folder
  String getIcon() {
    if (!icon.contains('assets')) {
      return 'assets/$icon';
    }
    return icon;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_category": idCategory,
        "date": date,
        "timestamp": timestamp,
        "description": description,
        "expends": expends,
        "name": categoryName,
        "place": place,
        "color": color,
        "icon": icon,
      };

  factory ExpendsModel.fromMap(Map<String, dynamic> json) => new ExpendsModel(
        id: json["id"],
        idCategory: json["id_category"],
        date: json["date"],
        timestamp: json["timestamp"],
        description: json["description"],
        expends: json["expends"].toDouble(),
        categoryName: json["name"],
        place: json["place"],
        color: json["color"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "id_category": idCategory,
        "date": date,
        "timestamp": timestamp,
        "description": description,
        "expends": expends,
        "name": categoryName,
        "place": place,
        "color": color,
        "icon": icon,
      };
}
