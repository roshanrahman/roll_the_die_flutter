import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  static const _primaryColor = Color(0xff052890);
  final lightTheme = ThemeData.light().copyWith(
      primaryColor: _primaryColor,
      accentColor: _primaryColor,
      backgroundColor: Colors.white,
      textTheme: TextTheme(
          button: TextStyle(
        fontSize: 24.0,
        letterSpacing: 2.4,
        color: Colors.white,
      )));
  final darkTheme = ThemeData.dark().copyWith(
      primaryColor: _primaryColor,
      accentColor: Colors.white,
      textTheme: TextTheme(
          button: TextStyle(
              fontSize: 24.0, letterSpacing: 2.4, color: _primaryColor)));
  int randomFace;
  String dieFaceAssetString;
  AnimationController animationController;
  bool isDark = false;
  ThemeData _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = lightTheme;
    randomFace = Random().nextInt(5) + 1;
    dieFaceAssetString = 'assets/die_face_$randomFace.svg';
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 1,
    )..addListener(() {
        this.setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Roll The Die',
        theme: _currentTheme,
        home: Scaffold(
          appBar: AppBar(
            title: buildHeader(),
            centerTitle: true,
            brightness: Brightness.dark,
            backgroundColor: _currentTheme.backgroundColor,
            elevation: 0,
            iconTheme: _currentTheme.iconTheme,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(isDark ? Icons.brightness_4 : Icons.brightness_7),
                  onPressed: toggleTheme,
                ),
              )
            ],
          ),
          body: Container(
            color: _currentTheme.backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildDieContainer(),
                Padding(
                  padding: const EdgeInsets.only(left: 48.0, right: 48.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: buildRaisedButton(),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildHeader() {
    return Text(
      'ROLL THE DIE',
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          letterSpacing: 1.6,
          color: Colors.grey[300]),
    );
  }

  Widget buildDieContainer() {
    return GestureDetector(
      onTap: changeDieFace,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 24.0,
              offset: Offset(0, 8))
        ]),
        child: RotationTransition(
            turns: animationController,
            child: SvgPicture.asset(dieFaceAssetString)),
      ),
    );
  }

  Widget buildRaisedButton() {
    return RaisedButton(
      color: _currentTheme.accentColor,
      splashColor: Colors.blue,
      elevation: 16.0,
      highlightElevation: 24.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Text("ROLL IT", style: _currentTheme.textTheme.button),
      onPressed: () {
        changeDieFace();
      },
    );
  }

  void changeDieFace() {
    return setState(() {
      animationController.forward(from: 0);
      dieFaceAssetString = 'assets/die_face_${Random().nextInt(6) + 1}.svg';
    });
  }

  void toggleTheme() {
    print(isDark);
    setState(() {
      _currentTheme = (isDark) ? darkTheme : lightTheme;
      isDark = !isDark;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
