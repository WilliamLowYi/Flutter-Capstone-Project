class Food {
  late String id, apiId, description, image, name, type, price;

  Food({
    this.id = '',
    this.apiId = '',
    this.description = '',
    this.image = '',
    this.name = '',
    this.type = '',
    this.price = ''
  });

  Food.fromJson(Map<dynamic, dynamic> json, this.id) {
    apiId = json['api_id'];
    description = json['description'];
    image = json['image'];
    name = json['name'];
    type = json['type'];
    price = json['price'];
  }

  @override
  String toString(){
    return {
      'name': name,
      'type': type,
      'price': price,
      'image': image,
      'api_id': apiId,
      'description': description
    }.toString();
  }
}