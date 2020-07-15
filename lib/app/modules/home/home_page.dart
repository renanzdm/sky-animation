import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController>
    with SingleTickerProviderStateMixin {
  //use 'controller' variable to access controller

  List<MyStar> listOfStars = List<MyStar>();
  MyStar _myStarModel;

  Animation<double> animation;
  AnimationController animationController;

  createStars() {
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.bounceInOut)
          ..addStatusListener((status) {
            if (animation.status == AnimationStatus.completed) {
              animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animationController.forward();
            }
          });
    animationController.forward();

    for (var i = 0; i < 200; i++) {
      _myStarModel = MyStar(
          left: Random().nextInt(1000).toDouble(),
          top: Random().nextInt(1000).toDouble(),
          opacity: Random().nextInt(100).toDouble() / 100);
      if (mounted) {
        setState(() {
          listOfStars.add(_myStarModel);
        });
      }
    }
  }

  @override
  void initState() {
    createStars();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: sizes.height,
        width: sizes.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withBlue(20),
              Colors.black.withBlue(40),
              Colors.black.withBlue(60),
              Colors.black.withBlue(20),
              Colors.black.withBlue(40),
              Colors.black.withBlue(60),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            for (var item in listOfStars)
              MyBackground(animationController, item),
          ],
        ),
      ),
    );
  }
}

class MyBackground extends AnimatedWidget {
  final Animation animation;
  final MyStar star;
  MyBackground(this.animation, this.star) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    var _opacityTween = Tween<double>(begin: star.opacity, end: 1);

    Animation animation = listenable;
    return Positioned(
      left: star.left,
      top: star.top,
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Container(
          height: 4,
          width: 4,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
      ),
    );
  }
}

class MyStar {
  double left, top, opacity;
  MyStar({this.top, this.left, this.opacity});
}
