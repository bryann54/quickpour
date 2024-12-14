import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts() async {
    final categoryRepository = CategoryRepository();
    final merchantsRepository = MerchantsRepository();
    final brandRepository = BrandRepository();
    final categories = await categoryRepository.getCategories();
    final merchants = await merchantsRepository.getMerchants();
    final brand = await brandRepository.getBrands();

    // Alcohol categories
    final beer = categories.firstWhere((cat) => cat.id == 'cat1');
    final wine = categories.firstWhere((cat) => cat.id == 'cat2');
    final whiskey = categories.firstWhere((cat) => cat.id == 'cat3');
    final vodka = categories.firstWhere((cat) => cat.id == 'cat4');
    final rum = categories.firstWhere((cat) => cat.id == 'cat5');
    final gin = categories.firstWhere((cat) => cat.id == 'cat6');
    final cider = categories.firstWhere((cat) => cat.id == 'cat7');
    final brandy = categories.firstWhere((cat) => cat.id == 'cat8');
    final champagne = categories.firstWhere((cat) => cat.id == 'cat9');
    final tequila = categories.firstWhere((cat) => cat.id == 'cat10');

    // Creating and returning a list of products
    return [
      ProductModel(
        id: '1',
 brand: brand.firstWhere((m) => m.id == '13'),
        productName: 'Tusker Lager',
        imageUrls: [
          'https://greenspoon.co.ke/wp-content/uploads/2023/02/Greenspoon-Kenya-Tusker-Lager.jpg',
          'https://noblegreen-production.s3-eu-west-2.amazonaws.com/spree/images/8734/large/TU00ZZBK-1.jpg?1680876176'
        ],
        price: 200.00,
        description: 'A smooth and refreshing lager brewed in Kenya.',
        merchants: merchants.firstWhere((m) => m.id == '1'), // Add merchants
        category: beer,
      ),
      ProductModel(
        id: '2',
 brand: brand.firstWhere((m) => m.id == '7'),
        productName: 'Frontera Cabernet Sauvignon',
        imageUrls: [
          'https://winenliquor.com/wp-content/uploads/Frontera-Cabernet-Sauvignon-Wine-N-Liquor.jpg',
        ],
        price: 1200.00,
        description: 'Full-bodied red wine with hints of cherry and oak.',
        merchants: merchants.firstWhere((m) => m.id == '2'), // Add merchants
        category: wine,
      ),
      ProductModel(
        id: '3',
 brand: brand.firstWhere((m) => m.id == '10'),
        productName: 'Jameson Irish Whiskey',
        imageUrls: [
          'https://www.drinksupermarket.com/media/catalog/product/cache/ad8b6ba7fad7f4211ece39072947e9e8/j/a/jameson-original-irish-whiskey-70cl_3.jpg',
        ],
        price: 3600.00,
        description: 'Triple-distilled Irish whiskey with a smooth finish.',
        merchants: merchants.firstWhere((m) => m.id == '3'), // Add merchants
        category: whiskey,
      ),
      ProductModel(
        id: '4',
 brand: brand.firstWhere((m) => m.id == '5'),
        productName: 'Smirnoff Vodka',
        imageUrls: [
          'https://soys.co.ke/PImages/AAAAJ-0.png',
        ],
        price: 1100.00,
        description: 'Premium vodka perfect for cocktails.',
        merchants: merchants.firstWhere((m) => m.id == '4'), // Add merchants
        category: vodka,
      ),
      ProductModel(
        id: '5',
 brand: brand.firstWhere((m) => m.id == '2'),
        productName: 'Captain Morgan Dark Rum',
        imageUrls: [
          'https://mydrinx.shop/cdn/shop/products/2da39ac2c53de95f0c315f51a99377e36f679cd916e6b0cabb856bff867ea2e2.jpg?v=1710799969',
        ],
        price: 1500.00,
        description: 'Rich and smooth dark rum with caramel notes.',
        merchants: merchants.firstWhere((m) => m.id == '5'),
        category: rum,
      ),
      ProductModel(
        id: '6',
 brand: brand.firstWhere((m) => m.id == '10'),
        productName: 'Beefeater Gin',
        imageUrls: [
          'https://res.cloudinary.com/dyc0ieeyu/image/upload/c_fit,f_auto/v1/products/beefeater-clear-gin.jpg',
        ],
        price: 2200.00,
        description: 'A classic dry gin with a distinct botanical flavor.',
        merchants: merchants.firstWhere((m) => m.id == '1'),
        category: gin,
      ),
      ProductModel(
        id: '7',
         brand: brand.firstWhere((m) => m.id == '3'),
        productName: 'Hunter’s Gold Cider',
        imageUrls: [
          'https://www.havenwines.co.ke/wp-content/uploads/2021/08/Hunters-Gold-330Ml-Cider-Bottle.jpg',
        ],
        price: 250.00,
        description: 'Refreshing apple cider with a crisp finish.',
        merchants: merchants.firstWhere((m) => m.id == '7'), 
        category: cider,
      ),
      ProductModel(
        id: '8',
         brand: brand.firstWhere((m) => m.id == '10'),
        productName: 'Hennessy VS Cognac',
        imageUrls: [
          'https://www.wildpoppies.co.nz/cdn/shop/files/hennessy-vs-cognac-singles-moet-wild-poppies-brown-for-him-orange-908841_2048x.jpg?v=1725332394',
        ],
        price: 7000.00,
        description: 'Premium cognac with a smooth and rich flavor.',
        merchants: merchants.firstWhere((m) => m.id == '8'), 
        category: brandy,
      ),
      ProductModel(
        id: '9',
       brand: brand.firstWhere((m) => m.id == '1'),
        productName: 'Moët & Chandon Brut',
        imageUrls: [
          'https://vineonline.vtexassets.com/arquivos/ids/162178/540036-1.jpg?v=638177090072100000',
        ],
        price: 9500.00,
        description: 'Elegant champagne with fine bubbles and fruity notes.',
        merchants: merchants.firstWhere((m) => m.id == '1'), // Add merchants
        category: champagne,
      ),
      ProductModel(
        id: '10',
         brand: brand.firstWhere((m) => m.id == '10'),
        productName: 'Jose Cuervo Tequila',
        imageUrls: [
          'https://www.liquorshack.co.ke/wp-content/uploads/2022/03/Jose-Cuervo-Especial-Reposado-1-Litre.jpg',
        ],
        price: 3500.00,
        description: 'A classic tequila with a smooth agave flavor.',
        merchants: merchants.firstWhere((m) => m.id == '10'), 
        category: tequila,
      ),
       ProductModel(
        id: '11',
        brand: brand.firstWhere((m) => m.id == '15'),
        productName: 'White Cap Lager',
        imageUrls: [
          'https://ke.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/47/7243/1.jpg',
        ],
        price: 180.00,
        description: 'A crisp and refreshing Kenyan lager beer.',
        merchants: merchants.firstWhere((m) => m.id == '1'),
        category:
            categories.firstWhere((cat) => cat.id == 'cat1'), // Beer category
      ),
      ProductModel(
        id: '12',
        brand: brand.firstWhere((m) => m.id == '16'),
        productName: 'Kenya Cane',
        imageUrls: [
          'https://ke.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/83/2549/1.jpg',
        ],
        price: 500.00,
        description: 'Traditional Kenyan sugar cane spirit.',
        merchants: merchants.firstWhere((m) => m.id == '3'),
        category:
            categories.firstWhere((cat) => cat.id == 'cat6'), // Rum category
      ),
      ProductModel(
        id: '13',
        brand: brand.firstWhere((m) => m.id == '17'),
        productName: 'Senator Keg',
        imageUrls: [
          'https://ke.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/64/3247/1.jpg',
        ],
        price: 100.00,
        description: 'Affordable local beer popular in Kenya.',
        merchants: merchants.firstWhere((m) => m.id == '7'),
        category:
            categories.firstWhere((cat) => cat.id == 'cat1'), // Beer category
      ),
      ProductModel(
        id: '14',
        brand: brand.firstWhere((m) => m.id == '18'),
        productName: 'Rare Spirits Apple Liqueur',
        imageUrls: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyLZzDqIoXRlZqU_P5-sZHDL5W3RzD0Lk5Tg&s',
        ],
        price: 600.00,
        description: 'Sweet apple-flavored liqueur from Rare Spirits.',
        merchants: merchants.firstWhere((m) => m.id == '4'),
        category: categories
            .firstWhere((cat) => cat.id == 'cat10'), 
      ),
    ];
  }
}
