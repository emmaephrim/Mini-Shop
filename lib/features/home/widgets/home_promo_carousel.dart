import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePromoCarousel extends ConsumerWidget {
  const HomePromoCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promos = ['Slide 1', 'Slide 2', 'Slide 3'];
    return CarouselSlider(
      items: promos.map((promo) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(promo, style: const TextStyle(fontSize: 24.0)),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
      ),
    );
  }
}
