import 'package:expends/database/data/categories.dart';
import 'package:expends/database/data/categories_provider.dart';

class CategoryBloc {
  var _provider = CategoriesProvider();

  Future<List<Categories>> getCategories() {
    return _provider.getCategories();
  }

  Future<Categories> getCategory(int catId) {
    return _provider.getCategory(catId);
  }

  Future<Categories> insertCategory(Categories category) {
    return _provider.insert(category);
  }

  Future<int> updateCategory(Categories category) {
    return _provider.update(category);
  }
}
