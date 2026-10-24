import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/features/products/models/product.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final String? productId;
  const EditProductScreen({super.key, this.productId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _isEditMode = false;
  var _isLoading = false;

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    sellerId: '',
  );

  // Initial Values for non-controller fields
  var _initValues = {'title': '', 'description': '', 'price': ''};

  @override
  void initState() {
    super.initState();

    // 2. CLEAN INITIALIZATION
    // We check the widget directly. No need for didChangeDependencies!
    if (widget.productId != null) {
      _isEditMode = true;

      _editedProduct = ref
          .read(productsControllerProvider.notifier)
          .findById(widget.productId!);

      _initValues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
      };

      _imageUrlController.text = _editedProduct.imageUrl;
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) return;
    FocusScope.of(context).unfocus();

    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final notifier = ref.read(productsControllerProvider.notifier);

      if (_isEditMode) {
        await notifier.updateProduct(_editedProduct);
      } else {
        await notifier.addProduct(_editedProduct);
      }

      if (!context.mounted) return;
      context.pop();
    } on DioException catch (e) {
      final message = e.error.toString();
      if (!context.mounted) return;

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("An error occurred"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => context.pop(), // Closes the dialog
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) => _editedProduct = _editedProduct
                          .copyWith(title: newValue),
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
                      onSaved: (newValue) => _editedProduct = _editedProduct
                          .copyWith(description: newValue),
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
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: url.isEmpty
                                  ? Text("Enter a URL")
                                  : FittedBox(
                                      fit: BoxFit.contain,
                                      child: Image.network(
                                        url,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
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
                            onSaved: (newValue) => _editedProduct =
                                _editedProduct.copyWith(imageUrl: newValue),
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
