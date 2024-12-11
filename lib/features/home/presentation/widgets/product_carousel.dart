import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductCarousel extends StatefulWidget {
  const ProductCarousel({super.key});

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _current = 0;

  // Example product data
  final List<Map<String, dynamic>> _products = [
    {
      'image':
          'https://i.pinimg.com/736x/b0/c7/e4/b0c7e4dcbebf432e013ec4892962ba21.jpg',
      'name': 'whole grains',
      'price': 'ksh 99.99 per kilo',
    },
    {
      'image':
          'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/grocery-store-sale-instagram-template-design-e11575ee77a912171d8aa69da8c5e3d1_screen.jpg?ts=1671899185',
      'name': 'Fresh groceries',
      'price': 'ksh 149.99 per basket',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq_pTIstjHNSdITOfFUy2v1DPYDsTbqOsc1A&s',
      'name': 'Free delivery for goods above ',
      'price': 'ksh 11,249',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _products.length,
          itemBuilder: (context, index, realIndex) {
            return _buildCarouselItem(_products[index]);
          },
          options: CarouselOptions(
            height: 250,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _products.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => {},
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentColor.withOpacity(
                    _current == entry.key ? 0.9 : 0.4,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: [
          Image.network(
            product['image'],
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.red,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product['price'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
