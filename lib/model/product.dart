library product;

class Product {
  final String category;
  final String description;
  final String material;
  final String length;
  final String image;
  final int price;
  int quantity = 1;
  int subtotal;

  Product(String this.category, String this.description, String this.material, String this.length, String this.image, int this.price) {
    subtotal = price;
  }

  Product.fromMap(Map<String, Object> map) : this(map["category"], map["description"], map["material"], map["length"], map["image"], map["price"]);
}