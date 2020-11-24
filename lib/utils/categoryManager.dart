import 'dart:ui';

import 'package:expends/database/data/categories.dart';
import 'package:expends/database/data/categories_provider.dart';
import 'package:expends/utils/icons_constants.dart';
import 'package:flutter/material.dart';

class CategoryManager {
  CategoryManager._privateConstructor();

  static final CategoryManager instance = CategoryManager._privateConstructor();
  var categoriesProvider = CategoriesProvider();

  final String TAG = "CategoryManager: ";

  List<String> iconsList = [
    kFoodIcon,
    kFuelStationIcon,
    kMiscellaneousIcon,
    kTShirtIcon,
    kGymIcon,
    kCarIcon,
    kGiftIcon,
  ];

  List<Color> colorsList = [
    Colors.green,
    Colors.red,
    Colors.redAccent,
    Colors.lightBlue,
    Colors.deepOrange,
    Colors.orange,
    Colors.deepPurple
  ];

  List<String> categoryList = [
    "Food & Drink",
    "Petrol",
    "Tools",
    "Clothing",
    "Gym",
    "Car",
    "Gifts",
  ];

  void insertCategory() {
    categoriesProvider.getCategories().then((List<Categories> categoryList) {
      if (categoryList.length == 0) {
        _insertPredefineCategories();
      } else {
        print(TAG + categoryList.length.toString() + " Category exits");
      }
    }).catchError((error) {
      print(TAG + "Error while reading categories.");
    });
  }

  void _insertPredefineCategories() {
    for (var i = 0; i < categoryList.length; i++) {
      categoriesProvider
          .insert(Categories(
              name: categoryList[i].trim(),
              color: colorsList[i].value.toString().trim(),
              icon: iconsList[i].trim()))
          .then(
        (value) {
          print(TAG + i.toString() + " Category-Inserted");
        },
      ).catchError(
        (error) {
          print(TAG + 'Error while inserting category: ' + error.toString());
        },
      );
    }
  }
}
