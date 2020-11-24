import 'package:expends/database/data/categories.dart';
import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/categories/bloc/category_bloc.dart';
import 'package:expends/ui/widgets/custom_appbar.dart';
import 'package:expends/utils/icons_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AddCategory extends StatefulWidget {
  final int categoryId;

  const AddCategory({
    @required this.categoryId,
  });

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final textController = TextEditingController();
  final _bloc = CategoryBloc();
  final categoryNameController = TextEditingController();
  var selectedIconIndex = 0;
  var selectedColorIndex = 0;

  Categories _category;

  List<String> iconsList = [
    kAirplaneIcon,
    kAvatarIcon,
    kCarIcon,
    kCreditCardIcon,
    kDrinkIcon,
    kFoodIcon,
    kFuelStationIcon,
    kGiftIcon,
    kGroomingIcon,
    kGymIcon,
    kHomeIcon,
    kMiscellaneousIcon,
    kMoneyIcon,
    kStationaryIcon,
    kTShirtIcon,
    kWalletIcon
  ];

  List<Color> colorsList = [
    Colors.green,
    Colors.lightGreen,
    Colors.red,
    Colors.redAccent,
    Colors.blue,
    Colors.lightBlue,
    Colors.purple,
    Colors.deepPurple,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.pinkAccent
  ];

  Color selectedColor = Colors.green;
  String selectedIcon = kAirplaneIcon;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    _category = null;

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => onWidgetBuild());
    }
  }

  void onWidgetBuild() {
    if (widget.categoryId != 0) {
      _bloc.getCategory(widget.categoryId).then((category) {
        _category = category;
        selectedColor = Color(int.parse(_category.color));
        selectedIcon = _category.getIcon();
        categoryNameController.text = _category.name;

        for (var i = 0; i < colorsList.length; i++) {
          if (colorsList[i].value == int.parse(_category.color)) {
            selectedColorIndex = i;
            break;
          }
        }

        selectedIconIndex = iconsList.indexOf(selectedIcon);

        setState(() {});
      }).catchError((error) {
        _category = null;
        print('error in reading expend detail: ' + error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.categoryId == 0 ? "Add Category" : "Edit Category";

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: CustomAppbarTitle(title: title),
        backgroundColor: selectedColor,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              if (categoryNameController.text.trim().isEmpty) {
                final snackBar = SnackBar(
                  content: Text('Please provide non empty category name.'),
                  backgroundColor: Colors.red,
                );

                _scaffoldKey.currentState.showSnackBar(snackBar);
                return;
              }

              addCategory(
                  categoryNameController.text,
                  colorsList[selectedColorIndex].value.toString(),
                  iconsList[selectedIconIndex]);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      body: mainView(),
    );
  }

  Widget mainView() {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          color: selectedColor,
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 35,
                width: 35,
                child: Image(
                  image: AssetImage(selectedIcon),
                  color: Colors.white,
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextField(
                    controller: categoryNameController,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: "Category Name..",
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 25),
                      contentPadding: EdgeInsets.only(left: 5, right: 5),
                      border: InputBorder.none,
                    ),
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
        colorsListWidget(),
        Expanded(child: iconsListWidget()),
      ],
    );
  }

  Widget colorsListWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selectedColor = colorsList[index];
              selectedColorIndex = index;
              setState(() {});
            },
            child: colorWidget(index, colorsList[index]),
          );
        },
        itemCount: colorsList.length,
      ),
    );
  }

  Widget colorWidget(int index, Color color) {
    if (index == selectedColorIndex) {
      return Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              color: colorsList[index],
            ),
            Container(
              height: 40,
              width: 40,
              color: Colors.black12,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(5),
        height: 40,
        width: 40,
        color: colorsList[index],
      );
    }
  }

  Widget iconsListWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(iconsList.length, (index) {
          return GestureDetector(
            onTap: () {
              selectedIcon = iconsList[index];
              selectedIconIndex = index;
              setState(() {});
            },
            child: iconWidget(index, iconsList[index]),
          );
        }),
      ),
    );
  }

  Widget iconWidget(int index, String assetImage) {
    if (index == selectedIconIndex) {
      return Container(
        margin: EdgeInsets.all(20),
        height: 40,
        width: 40,
        child: Image(
          image: AssetImage(assetImage),
          color: selectedColor,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(20),
        height: 40,
        width: 40,
        child: Image(
          image: AssetImage(assetImage),
          color: Colors.grey,
        ),
      );
    }
  }

  void addCategory(
      String categoryName, String categoryColor, String categoryIcon) {
    if (_bloc != null) {
      if (widget.categoryId == 0) {
        _bloc
            .insertCategory(Categories(
                name: categoryName.trim(),
                color: categoryColor.trim(),
                icon: categoryIcon.trim()))
            .then(
          (value) {
            textController.text = "";
            Navigator.pop(context, "Category was created successfully.");
          },
        ).catchError(
          (error) {
            print('error while inserting category: ' + error.toString());
            final snackBar = SnackBar(
              content: Text('Something wrong, please try again.'),
              backgroundColor: Colors.red,
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          },
        );
      } else {
        _bloc
            .updateCategory(Categories(
                id: widget.categoryId,
                name: categoryName.trim(),
                color: categoryColor.trim(),
                icon: categoryIcon.trim()))
            .then(
          (value) {
            textController.text = "";
            Navigator.pop(context, "Category was updated successfully.");
          },
        ).catchError(
          (error) {
            print('error while inserting category: ' + error.toString());
            final snackBar = SnackBar(
              content: Text('Something wrong, please try again.'),
              backgroundColor: Colors.red,
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          },
        );
      }
    }
  }
}
