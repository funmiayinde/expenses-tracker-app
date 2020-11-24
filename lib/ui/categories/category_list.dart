import 'package:expends/database/data/categories.dart';
import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/categories/add_category.dart';
import 'package:expends/ui/categories/bloc/category_bloc.dart';
import 'package:expends/ui/widgets/custom_appbar.dart';
import 'package:expends/ui/widgets/placeholder.dart';
import 'package:expends/ui/widgets/show_progress.dart';
import 'package:expends/utils/app_singleton.dart';
import 'package:expends/utils/font_constants.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final _bloc = CategoryBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      appBar: AppBar(
        title: CustomAppbarTitle(title: 'Categories'),
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _bloc.getCategories(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _awaitReturnValueFromAddCategory(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _showCategories(List<Categories> categoryList) {
    if (categoryList.length == 0) {
      return PlaceHolder(
        message: 'You don\'t have any category yet,\nPlease add some.',
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.separated(
              separatorBuilder: (_, position) {
                return SizedBox(height: 10.0);
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var categories = categoryList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCategory(categoryId: categories.id),
                      ),
                    );
                  },
                  child: Container(
                    color: ThemeProvider().getColor(Themes.cardBGColor),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 7, bottom: 7),
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            color: Color(
                              int.parse(categories.color),
                            ),
                          ),
                          height: 50,
                          width: 50,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage(categories.getIcon()),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text(
                              categories.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color:
                                    ThemeProvider().getColor(Themes.textColor),
                                fontSize: 20,
                                fontFamily: fontFamilyBold,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          color: Color(
                            int.parse(categories.color),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: categoryList.length,
            ),
            SizedBox(height: 100.0),
          ],
        ),
      );
    }
  }

  void _awaitReturnValueFromAddCategory(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddCategory(
                  categoryId: 0,
                )));

    if (result != null) {
      // after the SecondScreen result comes back update the Text widget with it
      AppSingleton.instance.showMessage(result);
    }
  }
}

abstract class CategorySelectionListener {
  void onCategorySelected(Categories category);
}
