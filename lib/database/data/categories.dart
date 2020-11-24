class Categories {
  static const String tableCategories = 'table_categories';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnColor = 'color';
  static const String columnIcon = 'icon';

  int id;
  String name;
  String color;
  String icon;

  Categories({this.id, this.name, this.color, this.icon});

  /// this is to avoid assets path error for existing users,
  /// As earlier icons was not in assets folder
  String getIcon() {
    if (!icon.contains('assets')) {
      return 'assets/$icon';
    }

    return icon;
  }

  factory Categories.fromJson(Map<String, dynamic> json) => new Categories(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "icon": icon,
      };

  factory Categories.fromMap(Map<String, dynamic> json) => new Categories(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "color": color,
        "icon": icon,
      };
}
