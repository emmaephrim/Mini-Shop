import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_shop_app/features/profile/controllers/user_profile_controller.dart';
import 'package:mini_shop_app/features/profile/controllers/user_provider.dart';
import 'package:mini_shop_app/features/profile/widgets/profile_list_tile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Compress the image so you don't burn through Firebase Storage limits
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (pickedFile == null) return;
    setState(() {
      _isUploading = true;
      _selectedImage = File(pickedFile.path);
    });
    try {
      await ref
          .read(userProfileControllerProvider.notifier)
          .uploadAndSaveAvatar(_selectedImage!);
    } catch (error) {
      if (!context.mounted) return;
      setState(() {
        _selectedImage = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
    } finally {
      if (context.mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).value;
    final previousAvatarUrl = userProfile?.avatarUrl;

    return Scaffold(
      appBar: AppBar(title: const Text("My profile"), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(24.0),
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!) as ImageProvider
                      : previousAvatarUrl != null
                      ? NetworkImage(previousAvatarUrl)
                      : const NetworkImage('https://via.placeholder.com/150'),
                  child: _isUploading
                      ? CircularProgressIndicator()
                      : _selectedImage == null && previousAvatarUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'John Doe',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'buyer@example.com',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          const Divider(),
          ProfileListTile(
            icon: Icons.person_outline,
            title: 'Edit Personal Details',
            onTap: () {},
          ),
          ProfileListTile(
            icon: Icons.location_on_outlined,
            title: 'Shipping Address',
            onTap: () {},
          ),
          ProfileListTile(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            onTap: () {},
          ),
          ProfileListTile(
            icon: Icons.logout,
            title: 'Log Out',
            isDestructive: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
