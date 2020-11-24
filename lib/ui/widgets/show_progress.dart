import 'package:flutter/material.dart';

class ShowProgress extends StatefulWidget {
  @override
  _ShowProgressState createState() => _ShowProgressState();
}

class _ShowProgressState extends State<ShowProgress> {
  @override
  Widget build(BuildContext context) {
    return _showProgress();
  }

  Widget _showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
