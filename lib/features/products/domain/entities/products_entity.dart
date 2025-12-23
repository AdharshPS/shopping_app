class ProductsEntity {
  final String? id;
  final String? title;
  final double? price;
  final String? description;
  final String? image;
  final String? category;
  final ProductsEntityRating? rating;
  ProductsEntity({
    this.id,
    this.title,
    this.price,
    this.description,
    this.image,
    this.category,
    this.rating,
  });
}

class ProductsEntityRating {
  final double? rate;
  final int? count;
  const ProductsEntityRating({this.rate, this.count});
}
