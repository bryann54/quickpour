
import 'package:chupachap/features/categories/data/models/category_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 2));

    return [
      CategoryModel(
        id: 'cat1',
        name: 'Vegetables',
        imageUrl:
            'https://img.freepik.com/premium-psd/garden-s-finest-highres-vegetables-png_68880-13857.jpg',
      ),
      CategoryModel(
        id: 'cat2',
        name: 'Cereals',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrqkyncXkKOIR1gw0-pt9bPiJ62U_ZV2FEuQ&s',
      ),
      CategoryModel(
        id: 'cat3',
        name: 'Dairy',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXjQ_LMMdMB5fScOsZC0WA54PnyQnFhcTBwA&s',
      ),
      CategoryModel(
        id: 'cat4',
        name: 'Meat & Poultry',
        imageUrl:
            'https://w7.pngwing.com/pngs/152/473/png-transparent-raw-meat-and-fish-seafood-meat-fish-protein-meat-food-beef-recipe-thumbnail.png',
      ),
      CategoryModel(
        id: 'cat5',
        name: 'Fruits',
        imageUrl:
            'https://c0.klipartz.com/pngpicture/181/2/gratis-png-elemento-de-frutas-thumbnail.png',
      ),
      CategoryModel(
        id: 'cat6',
        name: 'Eggs & Honey',
        imageUrl:
            'https://w7.pngwing.com/pngs/1016/792/png-transparent-dabur-organic-food-breakfast-eating-honey-pot-thumbnail.png',
      ),
      // New creative categories
      CategoryModel(
        id: 'cat7',
        name: 'Medicinal Herbs',
        imageUrl: 'https://example.com/medicinal-herbs.jpg',
      ),
      CategoryModel(
        id: 'cat8',
        name: 'Exotic Spices',
        imageUrl: 'https://example.com/exotic-spices.jpg',
      ),
      CategoryModel(
        id: 'cat9',
        name: 'Sustainable Seeds',
        imageUrl: 'https://example.com/sustainable-seeds.jpg',
      ),
      CategoryModel(
        id: 'cat10',
        name: 'Organic Fertilizers',
        imageUrl: 'https://example.com/organic-fertilizers.jpg',
      ),
      CategoryModel(
        id: 'cat11',
        name: 'Aquaponic Produce',
        imageUrl: 'https://example.com/aquaponic-produce.jpg',
      ),
      CategoryModel(
        id: 'cat12',
        name: 'Rare Cultivars',
        imageUrl: 'https://example.com/rare-cultivars.jpg',
      )
    ];
  }
}
