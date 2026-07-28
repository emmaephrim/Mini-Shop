// removed unused import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/product.dart';

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

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) return;
    _form.currentState?.save();
    print(_editedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
                maxLines: 3,
                decoration: InputDecoration(labelText: "Description"),
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
