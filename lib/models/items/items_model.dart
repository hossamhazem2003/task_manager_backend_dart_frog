class ItemModel {
  ItemModel({
    required this.userId,
    required this.itemId,
    required this.itemName,
    required this.color,
  });

  final String userId;
  final String? itemId;
  final String? itemName;
  final String? color;

  // Convert a CategoriesModel object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'itemId': itemId,
      'itemName': itemName,
      'backGroundColor': color,
    };
  }
}
