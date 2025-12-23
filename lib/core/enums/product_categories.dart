enum ProductCategories {
  all,
  mensClothing,
  womensClothing,
  jewelery,
  electronics,
}

ProductCategories fromApi(String? category) {
  switch (category) {
    case 'men\'s clothing':
      return ProductCategories.mensClothing;
    case 'women\'s clothing':
      return ProductCategories.womensClothing;
    case 'jewelery':
      return ProductCategories.jewelery;
    case 'electronics':
      return ProductCategories.electronics;
    default:
      return ProductCategories.all;
  }
}

extension ProductsCategoryX on ProductCategories {
  String get productCategoryToString {
    switch (this) {
      case ProductCategories.all:
        return 'All';
      case ProductCategories.electronics:
        return 'Electronics';
      case ProductCategories.jewelery:
        return 'Jewelery';
      case ProductCategories.mensClothing:
        return 'Men\'s clothing';
      case ProductCategories.womensClothing:
        return 'Women\'s clothing';
    }
  }
}
