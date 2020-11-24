import 'package:expends/database/data/categories.dart';
import 'package:expends/database/data/expends.dart';
import 'package:expends/database/data/expends_model.dart';
import 'package:expends/theme/theme_provider.dart';
import 'package:expends/theme/themes.dart';
import 'package:expends/ui/addexpense/bloc/add_edit_expense_bloc.dart';
import 'package:expends/utils/icons_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../categories/add_category.dart';
import 'category_list_grid.dart';

class EditExpend extends StatefulWidget {
  final int expendId;

  const EditExpend({@required this.expendId});

  @override
  _EditExpendState createState() => _EditExpendState();
}

class _EditExpendState extends State<EditExpend>
    implements CategorySelectionListener {
  Categories _selectedCategory;
  ExpendsModel _expend;
  DateTime _selectedDate = DateTime.now();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final numberController = TextEditingController();
  final descriptionController = TextEditingController();
  final placeController = TextEditingController();

  final _bloc = AddEditExpenseBloc();
  bool _isExpendValueAvailable = false;

  void initState() {
    super.initState();
    _expend = null;

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => onWidgetBuild());
    }
  }

  void onWidgetBuild() {
    _bloc.getExpense(widget.expendId).then((expend) {
      _expend = expend;
      _selectedCategory = Categories(
          id: expend.idCategory,
          color: expend.color,
          icon: expend.getIcon(),
          name: expend.categoryName);

      if (expend.timestamp != null) {
        _selectedDate =
            DateTime.fromMillisecondsSinceEpoch(int.parse(expend.timestamp));
      }

      numberController.text = expend.expends.toString();
      descriptionController.text = expend.description;
      placeController.text = expend.place;

      _isExpendValueAvailable = expend.expends.toString().isNotEmpty;

      setState(() {});
    }).catchError((error) {
      _expend = null;
      print('error in reading expend detail: ' + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider().getColor(Themes.backgroundColor),
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _selectedCategory != null
            ? Color(int.parse(_selectedCategory.color))
            : ThemeProvider().getColor(Themes.backgroundColor),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              deleteExpend();
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: mainView(),
      floatingActionButton: actionButton(),
    );
  }

  void deleteExpend() {
    _bloc.deleteExpense(widget.expendId).then((data) {
      Navigator.pop(context, 'Transaction was deleted!');
    }).catchError((error) {
      print('Error while deleting data :' + error.toString());
      final snackBar = SnackBar(
        content: Text('Something wrong, please try again.'),
        backgroundColor: Colors.red,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget mainView() {
    if (_expend == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: <Widget>[
          Container(
            color: _selectedCategory != null
                ? Color(int.parse(_selectedCategory.color))
                : ThemeProvider().getColor(Themes.backgroundColor),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _selectedCategory = null;
                    _showCategories();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20, bottom: 5),
                    height: 25,
                    width: 25,
                    child: Image(
                      image: AssetImage(_selectedCategory != null
                          ? _selectedCategory.getIcon()
                          : kBorderCircleIcon),
                      color: ThemeProvider().getColor(Themes.iconColor),
                    ),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: numberController,
                    onChanged: (value) {
                      setState(() {
                        _isExpendValueAvailable = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 20),
                        border: InputBorder.none,
                        hintText: '0 NGN',
                        hintStyle: TextStyle(color: Colors.grey)),
                    style: TextStyle(
                      color: ThemeProvider().getColor(Themes.textColor),
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.date_range,
                    color: _selectedCategory != null
                        ? Color(int.parse(_selectedCategory.color))
                        : ThemeProvider().getColor(Themes.iconColor),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      _selectedDate == null
                          ? ""
                          : "${DateFormat.yMMMd().format(_selectedDate.toLocal())}",
                      style: TextStyle(
                        color: ThemeProvider().getColor(Themes.textColor),
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: descriptionController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Write a note..",
                hintStyle: TextStyle(color: Colors.grey),
                icon: Icon(
                  Icons.edit,
                  color: _selectedCategory != null
                      ? Color(int.parse(_selectedCategory.color))
                      : ThemeProvider().getColor(Themes.iconColor),
                ),
                contentPadding: EdgeInsets.only(left: 5, right: 5),
                border: InputBorder.none,
              ),
              style:
                  TextStyle(color: ThemeProvider().getColor(Themes.textColor)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: placeController,
              maxLines: null,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Place..",
                hintStyle: TextStyle(color: Colors.grey),
                icon: Icon(
                  Icons.pin_drop,
                  color: _selectedCategory != null
                      ? Color(int.parse(_selectedCategory.color))
                      : ThemeProvider().getColor(Themes.iconColor),
                ),
                contentPadding: EdgeInsets.only(left: 5, right: 5),
                border: InputBorder.none,
              ),
              style:
                  TextStyle(color: ThemeProvider().getColor(Themes.textColor)),
            ),
          ),
        ],
      );
    }
  }

  Widget actionButton() {
    if (_isExpendValueAvailable) {
      return FloatingActionButton(
        onPressed: () {
          if (_selectedCategory == null) {
            final snackBar = SnackBar(
              content: Text('You must choose a category first!'),
              backgroundColor: Colors.red,
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
            return;
          }

          if (_selectedDate == null) {
            final snackBar = SnackBar(
              content: Text('You must choose a date!'),
              backgroundColor: Colors.red,
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
            return;
          }

          updateExpend();
        },
        child: Icon(Icons.check),
        backgroundColor: _selectedCategory != null
            ? Color(int.parse(_selectedCategory.color))
            : Theme.of(context).accentColor,
      );
    } else {
      return Container();
    }
  }

  void _showCategories() {
    _selectedCategory = null;
    setState(() {});

    showModalBottomSheet(
        context: (context),
        builder: (builder) {
          return Container(
            color: ThemeProvider().getColor(Themes.backgroundColor),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CategoryListGrid(this),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCategory(categoryId: 0)));
                  },
                  child: Container(
                    color: ThemeProvider().getColor(Themes.backgroundColor),
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Category',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[300],
                            fontSize: 18),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void onCategorySelected(Categories category) {
    setState(() {
      _selectedCategory = category;
      Navigator.pop(context);
    });
  }

  void updateExpend() {
    var expends = Expends(
      id: widget.expendId,
      date: _selectedDate == null
          ? ""
          : "${DateFormat.yMMMd().format(_selectedDate.toLocal())}".trim(),
      month: _selectedDate == null
          ? ""
          : "${DateFormat.yMMM().format(_selectedDate.toLocal())}".trim(),
      timestamp:
          _selectedDate.toLocal().millisecondsSinceEpoch.toString().trim(),
      idCategory: _selectedCategory.id,
      description: descriptionController.text.isNotEmpty
          ? descriptionController.text.trim()
          : "",
      expends: double.parse(
        numberController.text.toString().trim(),
      ),
      place: placeController.text.isNotEmpty ? placeController.text.trim() : "",
    );

    _bloc.updateExpense(expends).then((expends) {
      Navigator.pop(context, 'Transaction was updated successfully');
    }).catchError((error) {
      print('error while updating expense ' + error.toString());
      final snackBar = SnackBar(
        content: Text('Something wrong, please try again.'),
        backgroundColor: Colors.red,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }
}
