// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);
// {
//         "id" : 1,
//         "title" : "asdsad",
//         "price" : 12.0,
//         "available" : 0,
//         "photoUri" : "asdadsa"
// }

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.title = '',
    this.price = 0.0,
    this.available = 0,
    this.photoUri = '',
  });

  int id;
  String title;
  double price;
  int available;
  String photoUri;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        price:
            (json["price"] is int) ? json["price"].toDouble() : json["price"],
        available: json["available"],
        photoUri: json["photoUri"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "available": available,
        "photoUri": photoUri,
      };
}
