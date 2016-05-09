library product;

class Product {
  final String category;
  final String description;
  final String image;
  final int price;

  Product(String this.category, String this.description, String this.image, int this.price);

  Product.fromMap(Map<String, Object> map) : this(map["category"], map["description"], map["image"], map["price"]);
}