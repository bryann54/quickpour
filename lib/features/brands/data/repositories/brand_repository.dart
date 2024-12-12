import 'package:chupachap/features/brands/data/models/brands_model.dart';

class BrandRepository {
  Future<List<BrandModel>> getBrands() async {
    // Simulated brand data
    return [
      BrandModel(
        id: '1',
        name: 'Jack Daniel\'s',
        country: 'United States',
        description: 'Legendary Tennessee whiskey distillery',
        logoUrl:
            'https://e1.pngegg.com/pngimages/832/332/png-clipart-daplb-jdn-003-jack-daniel-logo-brand-003.png',
      ),
      BrandModel(
        id: '2',
        name: 'Absolut',
        country: 'Sweden',
        description: 'Iconic vodka brand known for creative marketing',
        logoUrl:
            'https://www.absolut.com/wp-content/uploads/20449_absolut_logo_regular_blue_rgb.jpeg',
      ),
      BrandModel(
        id: '3',
        name: 'Hennessy',
        country: 'France',
        description: 'Renowned cognac producer since 1765',
        logoUrl:
            'https://i.pinimg.com/originals/3b/ef/ff/3befff5191c740e1dee789e85c78be2e.png',
      ),
      BrandModel(
        id: '4',
        name: 'Jameson',
        country: 'Ireland',
        description: 'World-famous Irish whiskey',
        logoUrl:
            'https://www.whiskyflavour.com/wp-content/uploads/2017/08/Jameson-Irish-Whiskey-Logo.jpg',
      ),
      BrandModel(
        id: '5',
        name: 'Del Maguey',
        country: 'Mexico',
        description: 'Artisanal single village mezcal',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqvUn7OcKzjGB1L35wzw8g_tRsWYGFBuJ_9w&s',
      ),
      BrandModel(
        id: '6',
        name: 'Baileys',
        country: 'Ireland',
        description: 'Smooth Irish cream liqueur',
        logoUrl: 'https://banner2.cleanpng.com/20180622/jfc/aazh64z49.webp',
      ),
      BrandModel(
        id: '7',
        name: 'Patron',
        country: 'Mexico',
        description: 'Premium tequila brand',
        logoUrl:
            'https://images.seeklogo.com/logo-png/32/1/patron-tequila-logo-png_seeklogo-323693.png?v=638687090940000000',
      ),
      BrandModel(
        id: '8',
        name: 'Grey Goose',
        country: 'France',
        description: 'Luxury French vodka',
        logoUrl:
            'https://www.pngfind.com/pngs/m/283-2833744_grey-goose-png-download-grey-goose-vodka-logo.png',
      ),
      BrandModel(
        id: '9',
        name: 'St. George Spirits',
        country: 'United States',
        description: 'Innovative craft distillery',
        logoUrl:
            'https://pbs.twimg.com/profile_images/1659238285984817158/UhsynODc_400x400.png',
      ),
      BrandModel(
        id: '10',
        name: 'Glenlivet',
        country: 'Scotland',
        description: 'Historic Speyside single malt scotch whisky',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSCYFfzrsNT_dcDfQOovpxwuzqyik3W4WlTw&s',
      ),
      BrandModel(
        id: '11',
        name: 'Kraken',
        country: 'Trinidad and Tobago',
        description: 'Spiced rum with unique branding',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/commons/6/6e/Kraken_Black_Spiced_Rum_logo.svg',
      ),
      BrandModel(
        id: '12',
        name: 'Blanton\'s',
        country: 'United States',
        description: 'Pioneer of single barrel bourbon',
        logoUrl: 'https://i.ebayimg.com/images/g/qKgAAOSwvy1mFYma/s-l1200.jpg',
      ),
    ];
  }
}
