import 'package:flutter/material.dart';
import 'package:whats_for_dinner/models/choose_one_arguments.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

class ChooseOneScreen extends StatefulWidget {
  static const routeName = '/chooseOne';

  @override
  _ChooseOneScreenState createState() => _ChooseOneScreenState();
}

class _ChooseOneScreenState extends State<ChooseOneScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this)
      ..repeat(reverse: true);
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.8,
          curve: Curves.bounceIn,
        ),
      ),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.82,
        1.0,
        curve: Curves.easeIn,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChooseOneArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('What\s for dinner?'),
      ),
      body: Column(
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: RestaurantCard(
                business: args.business,
                cardColor: Theme.of(context).accentColor),
          ),
          SizedBox(height: 10),
          FadeTransition(
              opacity: _fadeAnimation,
              child: RaisedButton(
                onPressed: () {},
                child: Text('Reroll Restaurant'),
              ))
        ],
      ),
    );
  }
}
