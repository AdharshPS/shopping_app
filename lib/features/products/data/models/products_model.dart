import 'package:hive/hive.dart';
import 'package:shopping_app/features/products/domain/entities/products_entity.dart';
part 'products_model.g.dart';

@HiveType(typeId: 1)
class ProductsModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final double? price;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? image;
  @HiveField(5)
  final String? category;
  @HiveField(6)
  final ProductsModelRating? rating;
  ProductsModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.image,
    this.category,
    this.rating,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
    'rating': rating?.toJson(),
  };

  ProductsEntity toEntity() => ProductsEntity(
    id: id,
    title: title,
    price: price,
    description: description,
    image: image,
    category: category,
    rating: rating?.toProductsEntityRating(),
  );

  factory ProductsModel.fromEntity(ProductsEntity entity) {
    return ProductsModel(
      id: entity.id,
      title: entity.title,
      price: entity.price,
      description: entity.description,
      image: entity.image,
      category: entity.category,
      rating: ProductsModelRating.fromEntity(entity.rating),
    );
  }

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id']?.toString(),
      title: json['title'],
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'],
      image: json['image'],
      category: json['category'],
      rating: json['rating'] != null
          ? ProductsModelRating.fromJson(json['rating'])
          : null,
    );
  }
}

@HiveType(typeId: 2)
class ProductsModelRating {
  @HiveField(0)
  final double? rate;
  @HiveField(1)
  final int? count;
  const ProductsModelRating({this.rate, this.count});

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};

  factory ProductsModelRating.fromJson(Map<String, dynamic> json) =>
      ProductsModelRating(rate: json['rate']?.toDouble(), count: json['count']);

  factory ProductsModelRating.fromEntity(ProductsEntityRating? rating) =>
      ProductsModelRating(rate: rating?.rate, count: rating?.count);

  ProductsEntityRating toProductsEntityRating() =>
      ProductsEntityRating(rate: rate, count: count);
}
