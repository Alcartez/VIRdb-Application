import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

import './setting_page.dart';
import './main.dart';

Widget imageSection;
Widget titleSection;
Widget buttonSection;
Widget textSection;
Widget imageSection1;
Widget titleSection1;
Widget buttonSection1;
Widget textSection1;

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    imageSection = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 10,
            blurRadius: 5,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Image.asset(
          'images/img_1.jpg',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
    );

    imageSection1 = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 10,
            blurRadius: 5,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Image.asset(
          'images/img_2.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
    );

    titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Title1',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Small Title1',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('Icon1'),
        ],
      ),
    );

    titleSection1 = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Title2',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Small Title2',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('Icon2'),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Column _buildButtonColumn(Color color, IconData icon, String label) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'Button 1'),
          _buildButtonColumn(color, Icons.near_me, 'Button 2'),
          _buildButtonColumn(color, Icons.share, 'Button 3'),
        ],
      ),
    );

    buttonSection1 = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'Button 4'),
          _buildButtonColumn(color, Icons.near_me, 'Button 5'),
          _buildButtonColumn(color, Icons.share, 'Button 6'),
        ],
      ),
    );

    textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Text line 1 Text line 1 Text line 1 Text line 1 Text line 1\n'
        'Text line 2 Text line 2 Text line 2 Text line 2 Text line 2\n'
        'Text line 3 Text line 3 Text line 3 Text line 3 Text line 3\n'
        'Text line 4 Text line 4 Text line 4 Text line 4 Text line 4\n'
        'Text line 5 Text line 5 Text line 5 Text line 5 Text line 5\n'
        'Text line 6 Text line 6 Text line 6 Text line 6 Text line 6',
        softWrap: true,
      ),
    );

    textSection1 = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Text line 1 Text line 1 Text line 1 Text line 1 Text line 1\n'
        'Text line 2 Text line 2 Text line 2 Text line 2 Text line 2\n'
        'Text line 3 Text line 3 Text line 3 Text line 3 Text line 3\n'
        'Text line 4 Text line 4 Text line 4 Text line 4 Text line 4\n'
        'Text line 5 Text line 5 Text line 5 Text line 5 Text line 5\n'
        'Text line 6 Text line 6 Text line 6 Text line 6 Text line 6',
        softWrap: true,
      ),
    );

    return new MaterialApp(
      title: 'Home Page',
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
        body: ListView(
          children: [
            imageSection,
            titleSection,
            buttonSection,
            textSection,
            imageSection1,
            titleSection1,
            buttonSection1,
            textSection1,
          ],
        ),
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
