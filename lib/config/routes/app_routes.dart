enum AppRoute {
  home('/'),
  auth('/auth'),
  cart('/cart'),
  addProduct('/add-product'),
  editProduct('/edit-product/:id'),
  productDetail('/product/:id'),
  userProducts('/user-products'),
  orders('/orders');

  // This variable holds the string URL for the enum
  final String path;
  // The constructor
  const AppRoute(this.path);
}
