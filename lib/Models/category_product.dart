// To parse this JSON data, do
//
//     final categoryProduct = categoryProductFromJson(jsonString);

import 'dart:convert';

CategoryProduct categoryProductFromJson(String str) => CategoryProduct.fromJson(json.decode(str));

String categoryProductToJson(CategoryProduct data) => json.encode(data.toJson());

class CategoryProduct {
  CategoryProduct({
    this.id,
    this.name,
    this.products,
  });

  int id;
  String name;
  List<Product> products;

  addNewProduct(Product product){
    products.add(product);
  }

  factory CategoryProduct.fromJson(Map<String, dynamic> json) => CategoryProduct(
    id: json["id"],
    name: json["name"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.imageUrl,
  });

  int id;
  String name;
  String description;
  double price;
  int category;
  String imageUrl;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    category: json["category"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "category": category,
    "image_url": imageUrl,
  };
}
