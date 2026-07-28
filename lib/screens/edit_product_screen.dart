import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/product.dart';
import 'package:mini_shop_app/providers/product_provider.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isEditMode = false;

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  // Initial Values for non-controller fields
  var _initValues = {'title': '', 'description': '', 'price': ''};

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final rawArguments = ModalRoute.of(context)?.settings.arguments;
      final productId = rawArguments is String ? rawArguments : null;

      if (productId != null && productId.isNotEmpty) {
        final existingProduct = ref
            .read(productsProvider.notifier)
            .findById(productId);

        _isEditMode = true;
        _editedProduct = existingProduct;

        _initValues = {
          'id': _editedProduct.id,
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false; // Prevent this block from running again on rebuilds
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) return;
    _form.currentState?.save();

    final notifier = ref.read(productsProvider.notifier);

    if (_isEditMode) {
      notifier.updateProduct(_editedProduct);
    } else {
      // creates new product and assigns id here.
      notifier.addProduct(
        _editedProduct.copyWith(id: DateTime.now().toString()),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Product' : 'Add Product'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onSaved: (newValue) =>
                    _editedProduct = _editedProduct.copyWith(title: newValue),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please provide a value";
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter a number greater than zero(0)";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  final parsed = double.tryParse(newValue ?? '0') ?? 0.0;
                  _editedProduct = _editedProduct.copyWith(price: parsed);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                maxLines: 3,
                decoration: InputDecoration(labelText: "Description"),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a description";
                  }
                  if (value.length < 10) {
                    return "Should be at least 10 characters long.";
                  }
                  return null;
                },
                onSaved: (newValue) => _editedProduct = _editedProduct.copyWith(
                  description: newValue,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _imageUrlController,
                    builder: (context, value, child) {
                      final url = value.text;
                      return Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: url.isEmpty
                            ? Text("Enter a URL")
                            : FittedBox(
                                fit: BoxFit.contain,
                                child: Image.network(
                                  url,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                      );
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Image URL"),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter an image URL.";
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return "Please enter a valid URL.";
                        }
                        if (!value.endsWith('.jpg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.jpeg')) {
                          return "Please provide a  valid image URL.";
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedProduct = _editedProduct
                          .copyWith(imageUrl: newValue),
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
