import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/farmer/data/repositories/farmer_repository.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts() async {
    final categoryRepository = CategoryRepository();
    final farmerRepository = FarmerRepository();

    final categories = await categoryRepository.getCategories();
    final farmers = await farmerRepository.getFarmers();

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

    return [
      ProductModel(
        id: '1',
        farmer: farmers.firstWhere((f) => f.id == '1'),
        productName: 'Tusker Lager',
        imageUrls: [
          'https://greenspoon.co.ke/wp-content/uploads/2023/02/Greenspoon-Kenya-Tusker-Lager.jpg',
          'https://noblegreen-production.s3-eu-west-2.amazonaws.com/spree/images/8734/large/TU00ZZBK-1.jpg?1680876176'
        ],
        price: 200.00,
        description: 'A smooth and refreshing lager brewed in Kenya.',
        category: beer,
      ),
      ProductModel(
        id: '2',
        farmer: farmers.firstWhere((f) => f.id == '2'),
        productName: 'Frontera Cabernet Sauvignon',
        imageUrls: [
          'https://winenliquor.com/wp-content/uploads/Frontera-Cabernet-Sauvignon-Wine-N-Liquor.jpg',
        ],
        price: 1200.00,
        description: 'Full-bodied red wine with hints of cherry and oak.',
        category: wine,
      ),
      ProductModel(
        id: '3',
        farmer: farmers.firstWhere((f) => f.id == '3'),
        productName: 'Jameson Irish Whiskey',
        imageUrls: [
          'https://www.drinksupermarket.com/media/catalog/product/cache/ad8b6ba7fad7f4211ece39072947e9e8/j/a/jameson-original-irish-whiskey-70cl_3.jpg',
        ],
        price: 3600.00,
        description: 'Triple-distilled Irish whiskey with a smooth finish.',
        category: whiskey,
      ),
      ProductModel(
        id: '4',
        farmer: farmers.firstWhere((f) => f.id == '4'),
        productName: 'Smirnoff Vodka',
        imageUrls: [
          'https://soys.co.ke/PImages/AAAAJ-0.png',
        ],
        price: 1100.00,
        description: 'Premium vodka perfect for cocktails.',
        category: vodka,
      ),
      ProductModel(
        id: '5',
        farmer: farmers.firstWhere((f) => f.id == '5'),
        productName: 'Captain Morgan Dark Rum',
        imageUrls: [
          'https://mydrinx.shop/cdn/shop/products/2da39ac2c53de95f0c315f51a99377e36f679cd916e6b0cabb856bff867ea2e2.jpg?v=1710799969',
        ],
        price: 1500.00,
        description: 'Rich and smooth dark rum with caramel notes.',
        category: rum,
      ),
      ProductModel(
        id: '6',
        farmer: farmers.firstWhere((f) => f.id == '6'),
        productName: 'Beefeater Gin',
        imageUrls: [
          'https://res.cloudinary.com/dyc0ieeyu/image/upload/c_fit,f_auto/v1/products/beefeater-clear-gin.jpg',
        ],
        price: 2200.00,
        description: 'A classic dry gin with a distinct botanical flavor.',
        category: gin,
      ),
      ProductModel(
        id: '7',
        farmer: farmers.firstWhere((f) => f.id == '7'),
        productName: 'Hunter’s Gold Cider',
        imageUrls: [
          'https://www.havenwines.co.ke/wp-content/uploads/2021/08/Hunters-Gold-330Ml-Cider-Bottle.jpg',
        ],
        price: 250.00,
        description: 'Refreshing apple cider with a crisp finish.',
        category: cider,
      ),
      ProductModel(
        id: '8',
        farmer: farmers.firstWhere((f) => f.id == '8'),
        productName: 'Hennessy VS Cognac',
        imageUrls: [
          'https://www.wildpoppies.co.nz/cdn/shop/files/hennessy-vs-cognac-singles-moet-wild-poppies-brown-for-him-orange-908841_2048x.jpg?v=1725332394',
        ],
        price: 7000.00,
        description: 'Premium cognac with a smooth and rich flavor.',
        category: brandy,
      ),
      ProductModel(
        id: '9',
        farmer: farmers.firstWhere((f) => f.id == '9'),
        productName: 'Moët & Chandon Brut',
        imageUrls: [
          'https://vineonline.vtexassets.com/arquivos/ids/162178/540036-1.jpg?v=638177090072100000',
        ],
        price: 9500.00,
        description: 'Elegant champagne with fine bubbles and fruity notes.',
        category: champagne,
      ),
      ProductModel(
        id: '10',
        farmer: farmers.firstWhere((f) => f.id == '10'),
        productName: 'Jose Cuervo Tequila',
        imageUrls: [
          'https://www.liquorshack.co.ke/wp-content/uploads/2022/03/Jose-Cuervo-Especial-Reposado-1-Litre.jpg',
        ],
        price: 3500.00,
        description: 'A classic tequila with a smooth agave flavor.',
        category: tequila,
      ),
      ProductModel(
        id: '11',
        farmer: farmers.firstWhere((f) => f.id == '11'),
        productName: 'White Cap Lager',
        imageUrls: [
          'https://greenspoon.co.ke/wp-content/uploads/2023/02/Greenspoon-Kenya-White-cap.jpg',
        ],
        price: 180.00,
        description: 'Light and crisp lager brewed in Kenya.',
        category: beer,
      ),
      ProductModel(
        id: '12',
        farmer: farmers.firstWhere((f) => f.id == '12'),
        productName: 'Château Rouge Red Wine',
        imageUrls: [
          'https://lh4.googleusercontent.com/proxy/QMWyH8rQVWIuUgqQFpBBbVMI70FFLzs5JK4c4ZGNP8rbgISbASN05DPpLHZd_Y2_-jw921E-e_mqz5k5L2NO4KkxJv9qVNOZJdZmwppm2MJQ_3cfb-uvXHzo-tH97Q',
        ],
        price: 2000.00,
        description: 'A bold and robust red wine from France.',
        category: wine,
      ),
    ];
  }
}
