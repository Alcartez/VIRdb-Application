import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

import './Home_page.dart';
import './main.dart';

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Setting Page',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purple,
        accentColor: Colors.purple,
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0.0, 0.0),
          child: Container(),
        ),

// #####################################
//            Column Layout
// #####################################

// #####################################
//            Floating menu
// #####################################

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              title: "Home",
              iconColor: Colors.white,
              bubbleColor: Colors.purple,
              icon: Icons.home,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                appBloc.updateTitle('Home');
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstRoute()),
                );
              },
            ),
            Bubble(
              title: "Settings",
              iconColor: Colors.white,
              bubbleColor: Colors.purple,
              icon: Icons.settings,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                appBloc.updateTitle('Settings');
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
            ),
            Bubble(
              title: "Profile",
              iconColor: Colors.white,
              bubbleColor: Colors.purple,
              icon: Icons.person,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                appBloc.updateTitle('Profile');
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(name, picture)),
                );
              },
            ),
          ],
          animation: _animation,
          onPress: _animationController.isCompleted
              ? _animationController.reverse
              : _animationController.forward,
          iconColor: Colors.purple,
          icon: AnimatedIcons.add_event,
        ));
  }
}
