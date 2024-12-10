

import 'package:chupachap/features/merchant/data/models/merchants_model.dart';

class MerchantsRepository {
  Future<List<Merchants>> getMerchantss() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      Merchants(
        id: '1',
        name: 'Whiskey Corner',
        location: 'Nairobi, Kenya',
        products: ['Whiskey', 'Vodka', 'Gin'],
        experience: 15,
        imageUrl: 'https://example.com/whiskey_corner.jpg',
        rating: 4.9,
        isVerified: true,
      ),
      Merchants(
        id: '2',
        name: 'The Gin Vault',
        location: 'Mombasa, Kenya',
        products: ['Gin', 'Tonic Water', 'Cocktail Mixers'],
        experience: 12,
        imageUrl: 'https://example.com/gin_vault.jpg',
        rating: 4.7,
        isVerified: true,
      ),
      Merchants(
        id: '3',
        name: 'Bourbon Haven',
        location: 'Kisumu, Kenya',
        products: ['Bourbon', 'Craft Beer', 'Wine'],
        experience: 10,
        imageUrl: 'https://example.com/bourbon_haven.jpg',
        rating: 4.6,
        isVerified: true,
      ),
      Merchants(
        id: '4',
        name: 'Wine & Spirits Emporium',
        location: 'Nakuru, Kenya',
        products: ['Wine', 'Brandy', 'Champagne'],
        experience: 8,
        imageUrl: 'https://example.com/wine_spirits.jpg',
        rating: 4.5,
        isVerified: false,
      ),
      Merchants(
        id: '5',
        name: 'The Liquor Store',
        location: 'Eldoret, Kenya',
        products: ['Rum', 'Tequila', 'Mezcal'],
        experience: 9,
        imageUrl: 'https://example.com/liquor_store.jpg',
        rating: 4.4,
        isVerified: true,
      ),
      Merchants(
        id: '6',
        name: 'Crafted Spirits Co.',
        location: 'Nyeri, Kenya',
        products: ['Craft Vodka', 'Flavored Whiskey', 'Premium Gin'],
        experience: 11,
        imageUrl: 'https://example.com/crafted_spirits.jpg',
        rating: 4.8,
        isVerified: true,
      ),
      Merchants(
        id: '7',
        name: 'Elite Liquor Lounge',
        location: 'Thika, Kenya',
        products: ['Single Malt Whiskey', 'Aged Brandy', 'Exotic Liqueurs'],
        experience: 14,
        imageUrl: 'https://example.com/elite_liquor.jpg',
        rating: 4.9,
        isVerified: true,
      ),
      Merchants(
        id: '8',
        name: 'Heritage Liquors',
        location: 'Kericho, Kenya',
        products: ['Craft Beers', 'Fine Wines', 'Signature Cocktails'],
        experience: 10,
        imageUrl: 'https://example.com/heritage_liquors.jpg',
        rating: 4.6,
        isVerified: true,
      ),
      Merchants(
        id: '9',
        name: 'The Tequila Cove',
        location: 'Malindi, Kenya',
        products: ['Tequila', 'Mezcal', 'Cocktail Syrups'],
        experience: 7,
        imageUrl: 'https://example.com/tequila_cove.jpg',
        rating: 4.5,
        isVerified: false,
      ),
      Merchants(
        id: '10',
        name: 'Vintage Spirits',
        location: 'Naivasha, Kenya',
        products: ['Vintage Whiskey', 'Old World Wines', 'Rare Cognac'],
        experience: 18,
        imageUrl: 'https://example.com/vintage_spirits.jpg',
        rating: 4.9,
        isVerified: true,
      ),
    ];
  }
}
