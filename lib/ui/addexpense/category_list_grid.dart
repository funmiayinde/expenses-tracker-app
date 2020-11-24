import 'package:expends/database/data/categories.dart';
import 'package:expends/database/data/categories_provider.dart';
import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/widgets/show_progress.dart';
import 'package:flutter/material.dart';

class CategoryListGrid extends StatefulWidget {
  CategorySelectionListener _clickListener;

  CategoryListGrid(CategorySelectionListener clickListener) {
    this._clickListener = clickListener;
  }

  @override
  _CategoryListGridState createState() => _CategoryListGridState();
}

class _CategoryListGridState extends State<CategoryListGrid> {
  var _categoriesProvider = CategoriesProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _categoriesProvider.getCategories(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: ThemeProvider().getColor(Themes.textColor)),
              ),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return ShowProgress();
              default:
                return _showCategories(snapshot.data);
            }
          }
        },
      ),
    );
  }

  Widget _showCategories(List<Categories> categoryList) {
    if (categoryList.length == 0) {
      return Center(
        child: Text(
          "You don't have any category yet, \n Please add some.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        color: ThemeProvider().getColor(Themes.backgroundColor),
        child: GridView.count(
          crossAxisCount: 4,
          children: List.generate(
            categoryList.length,
            (index) {
              var categories = categoryList[index];
              return GestureDetector(
                onTap: () {
                  widget._clickListener.onCategorySelected(categories);
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: 25,
                      child: Image(
                        image: AssetImage(categories.getIcon()),
                        color: Color(int.parse(categories.color)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        categories.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ThemeProvider().getColor(Themes.textColor),
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}

abstract class CategorySelectionListener {
  void onCategorySelected(Categories category);
}
