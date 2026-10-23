import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  const HomeSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: () {}, child: const Text("See All")),
      ],
    );
  }
}
