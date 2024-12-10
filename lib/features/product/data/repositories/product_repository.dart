
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/farmer/data/repositories/farmer_repository.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts() async {
    final categoryRepository = CategoryRepository();
    final farmerRepository = FarmerRepository();

    final categories = await categoryRepository.getCategories();
    final farmers = await farmerRepository.getFarmers();

    // Fetching categories by ID
    final vegetables = categories.firstWhere((cat) => cat.id == 'cat1');
    final grains = categories.firstWhere((cat) => cat.id == 'cat2');
    final dairy = categories.firstWhere((cat) => cat.id == 'cat3');
    final meatAndPoultry = categories.firstWhere((cat) => cat.id == 'cat4');
    final fruits = categories.firstWhere((cat) => cat.id == 'cat5');
    final eggsAndHoney = categories.firstWhere((cat) => cat.id == 'cat6');

    // New categories
    final medicalHerbs = categories.firstWhere((cat) => cat.id == 'cat7');
    final exoticSpices = categories.firstWhere((cat) => cat.id == 'cat8');
    final sustainableSeeds = categories.firstWhere((cat) => cat.id == 'cat9');
    final organicFertilizers =
        categories.firstWhere((cat) => cat.id == 'cat10');
    final aquaponicProduce = categories.firstWhere((cat) => cat.id == 'cat11');
    final rareCultivars = categories.firstWhere((cat) => cat.id == 'cat12');

    return [
      // Original Products
      ProductModel(
        id: '1',
        farmer: farmers.firstWhere((f) => f.id == '1'), // Mwangi Kimani
        productName: 'Organic Tomatoes',
        imageUrls: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSn_RpV_Nq_aND67ekZG9sOso6gv4AQatx2sw&s',
          'https://media.post.rvohealth.io/wp-content/uploads/2020/09/AN313-Tomatoes-732x549-Thumb.jpg',
          'https://media.post.rvohealth.io/wp-content/uploads/2020/09/AN313-Tomatoes-732x549-Thumb.jpg'
        ],
        price: 5.99,
        metrics: 'kg',
        description: 'Fresh organic tomatoes from local farms',
        category: vegetables,
      ),
      ProductModel(
        id: '2',
        farmer: farmers.firstWhere((f) => f.id == '8'), // Kipchoge Keino
        productName: 'Wheat Grain',
        imageUrls: [
          'https://cdn.britannica.com/80/157180-050-7B906E02/Heads-wheat-grains.jpg'
        ],
        price: 12.50,
        metrics: 'kg',
        description: 'High-quality wheat grain for baking',
        category: grains,
      ),
      ProductModel(
        id: '3',
        farmer: farmers.firstWhere((f) => f.id == '12'), // Waweru Kariuki
        productName: 'Fresh Milk',
        imageUrls: [
          'https://kenyaagri.com/wp-content/uploads/2022/04/milk-production-collection.jpg',
        ],
        price: 2.75,
        metrics: 'L',
        description: 'Pure, fresh milk from local dairy farms',
        category: dairy,
      ),
      ProductModel(
        id: '4',
        farmer: farmers.firstWhere((f) => f.id == '6'), // Chebet Kiprop
        productName: 'Organic Chicken',
        imageUrls: [
          'https://cdn.prod.website-files.com/5cad416e401a6c2d392c03db/5dc197268cab24edb57c9b34_115502%20Whole%20Broiler%20Chicken.jpg',
        ],
        price: 15.00,
        metrics: 'kg',
        description: 'Free-range organic chicken',
        category: meatAndPoultry,
      ),
      ProductModel(
        id: '5',
        farmer: farmers.firstWhere((f) => f.id == '7'), // Amina Hassan
        productName: 'Fresh Apples',
        imageUrls: [
          'https://st2.depositphotos.com/1177973/7683/i/950/depositphotos_76830509-stock-photo-red-apples-in-wicker-basket.jpg'
        ],
        price: 4.99,
        metrics: 'kg',
        description: 'Crisp and fresh apples from the orchard',
        category: fruits,
      ),
      ProductModel(
        id: '6',
        farmer: farmers.firstWhere((f) => f.id == '6'), // Chebet Kiprop
        productName: 'Raw Honey',
        imageUrls: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcqmWM2mpkZqP6QgGcX8cEjkCvAefzpOvkiA&s'
        ],
        price: 8.99,
        metrics: '500g',
        description: 'Pure, organic honey harvested from local beehives',
        category: eggsAndHoney,
      ),

      // New Category Products
      ProductModel(
        id: '7',
        farmer: farmers.firstWhere((f) => f.id == '9'), // Zawadi Muthoni
        productName: 'Echinacea Herb Bundle',
        imageUrls: ['https://example.com/echinacea-herbs.jpg'],
        price: 12.99,
        metrics: 'bundle',
        description: 'Immune-boosting medicinal herb bundle, freshly harvested',
        category: medicalHerbs,
      ),
      ProductModel(
        id: '8',
        farmer: farmers.firstWhere((f) => f.id == '8'), // Kipchoge Keino
        productName: 'Ceylon Cinnamon Sticks',
        imageUrls: ['https://example.com/ceylon-cinnamon.jpg'],
        price: 18.50,
        metrics: '250g',
        description: 'Rare, premium Ceylon cinnamon from Sri Lankan highlands',
        category: exoticSpices,
      ),
      ProductModel(
        id: '9',
        farmer: farmers.firstWhere((f) => f.id == '5'), // Muriuki Ndungu
        productName: 'Heirloom Tomato Seed Collection',
        imageUrls: ['https://example.com/heirloom-seeds.jpg'],
        price: 24.99,
        metrics: 'pack',
        description: 'Rare, non-GMO tomato seeds preserving genetic diversity',
        category: sustainableSeeds,
      ),
      ProductModel(
        id: '10',
        farmer: farmers.firstWhere((f) => f.id == '12'), // Waweru Kariuki
        productName: 'Vermicompost Organic Fertilizer',
        imageUrls: ['https://example.com/vermicompost.jpg'],
        price: 15.75,
        metrics: '10kg',
        description:
            'Premium worm-based organic fertilizer for sustainable gardening',
        category: organicFertilizers,
      ),
      ProductModel(
        id: '11',
        farmer: farmers.firstWhere((f) => f.id == '2'), // Wanjiku Njeri
        productName: 'Aquaponic Lettuce Mix',
        imageUrls: ['https://example.com/aquaponic-lettuce.jpg'],
        price: 6.50,
        metrics: 'kg',
        description:
            'Fresh, pesticide-free lettuce grown in sustainable aquaponic systems',
        category: aquaponicProduce,
      ),
      ProductModel(
        id: '12',
        farmer: farmers.firstWhere((f) => f.id == '7'), // Amina Hassan
        productName: 'Blue Java Banana Seedlings',
        imageUrls: ['https://example.com/blue-java-banana.jpg'],
        price: 35.99,
        metrics: 'plant',
        description:
            'Rare Blue Java banana variety known for its ice cream-like flavor',
        category: rareCultivars,
      )
    ];
  }
}
