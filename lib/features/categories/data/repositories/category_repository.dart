import 'package:chupachap/features/categories/data/models/category_model.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 2));

    return [
      CategoryModel(
        id: 'cat1',
        name: 'Beer',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS85xh1k2wB9Ze9TnIU5Js2sT7jP-YKIKAwpA&s',
      ),
      CategoryModel(
        id: 'cat2',
        name: 'Wine',
        imageUrl:
            'https://media.istockphoto.com/id/1132889797/vector/red-wine-glass-icon-illustration.jpg?s=612x612&w=0&k=20&c=jzSAqDg-wLQIm0xk6MVkZ6IZJhNPbdkTPDDMcwzDMhY=',
      ),
      CategoryModel(
        id: 'cat3',
        name: 'Whiskey',
        imageUrl:
            'https://i.pinimg.com/originals/c9/29/42/c92942f5a2a2676904dade306bdfb3cc.jpg',
      ),
      CategoryModel(
        id: 'cat4',
        name: 'Vodka',
        imageUrl:
            'https://img.freepik.com/premium-vector/vodka-bottle-logo-lettering-sign-vodka_579179-3325.jpg',
      ),
      CategoryModel(
        id: 'cat5',
        name: 'Gin',
        imageUrl:
            'https://cdn3.vectorstock.com/i/1000x1000/42/72/gin-vintage-label-design-alcohol-industry-vector-21064272.jpg',
      ),
      CategoryModel(
        id: 'cat6',
        name: 'Rum',
        imageUrl:
            'https://cdn5.vectorstock.com/i/1000x1000/62/24/bottle-and-rum-logo-vector-30236224.jpg',
      ),
      CategoryModel(
        id: 'cat7',
        name: 'Tequila',
        imageUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/009/675/742/small_2x/tequila-logo-designs-free-vector.jpg',
      ),
      CategoryModel(
        id: 'cat8',
        name: 'Champagne',
        imageUrl:
            'https://thumbs.dreamstime.com/z/champagne-bottle-pop-open-cork-sparkles-elegant-black-white-logo-icon-vector-illustration-137124082.jpg',
      ),
      CategoryModel(
        id: 'cat9',
        name: 'Cider',
        imageUrl:
            'https://img.freepik.com/free-vector/cider-logo-design-template_23-2150191160.jpg',
      ),
      CategoryModel(
        id: 'cat10',
        name: 'Cocktails',
        imageUrl:
            'https://img.freepik.com/premium-vector/cocktails-logo-inspiration-drink-glass-bar-restaurant_63578-164.jpg',
      ),
      CategoryModel(
        id: 'cat11',
        name: 'Brandy',
        imageUrl:
            'https://www.shutterstock.com/shutterstock/photos/316567271/display_1500/stock-vector-brandy-logo-vector-cognac-sign-with-wooden-barrel-typographic-label-badge-with-hand-sketched-keg-316567271.jpg',
      ),
      CategoryModel(
        id: 'cat12',
        name: 'Absinthe',
        imageUrl:
            'https://c8.alamy.com/comp/MPRD0A/original-absinthe-vintage-stamp-vector-MPRD0A.jpg',
      ),
       CategoryModel(
        id: 'cat13',
        name: 'Spirit',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxM4_Yp8_jqZmqTxR8fNuPbcCkGMO4ZVTmTg&s',
      ),
      CategoryModel(
        id: 'cat14',
        name: 'Liqueur',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp1ZnStc4mH-6IQRAnWYt6nfVT4XZuqwcrow&s',
      ),
    ];
  }
}
