import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePromoCarousel extends ConsumerWidget {
  const HomePromoCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promos = [
      'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0.jpg',
      'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0.png',
      'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a?w=500&auto=format&fit=crop&q=80.jpg',
    ];
    return CarouselSlider(
      items: promos.map((promo) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(promo),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Text(promo, style: const TextStyle(fontSize: 24.0)),
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
