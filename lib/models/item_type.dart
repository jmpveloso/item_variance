// To parse this JSON data, do
//
//     final itemType = itemTypeFromJson(jsonString);

import 'dart:convert';

import 'model.dart';

ItemType itemTypeFromJson(String str) => ItemType.fromJson(json.decode(str));

String itemTypeToJson(ItemType data) => json.encode(data.toJson());

class ItemType extends Model {
  ItemType({
    this.id,
    this.typeName,
  });

  int? id;
  String? typeName;

  factory ItemType.fromJson(Map<String, dynamic> json) => ItemType(
        id: json["id"],
        typeName: json["typeName"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "typeName": typeName,
      };
}
