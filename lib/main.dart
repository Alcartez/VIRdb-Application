import 'dart:async';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show exit;

import './Home_page.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
final AppPropertiesBloc appBloc = AppPropertiesBloc();

const AUTH0_DOMAIN = 'dev-0zy7y123.us.auth0.com';
const AUTH0_CLIENT_ID = 'RLNT5LMQFCGLpp8cW4TAzNG5Nfw5QTSm';
const AUTH0_REDIRECT_URI = 'com.auth0.app1://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

class AppPropertiesBloc {
  StreamController<String> _title = StreamController<String>();
  Stream<String> get titleStream => _title.stream;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  dispose() {
    _title.close();
  }
}

// #####################################
//         Handles profile page
// #####################################

class Profile extends StatelessWidget {
  final String name;
  final String picture;

  Profile(this.name, this.picture);

  @override
  Widget build(BuildContext context) {
    Widget imagesection = Container(
      padding: const EdgeInsets.all(15),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 4.0),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(picture ?? ''),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 10,
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );

    Widget textsection = Text('Name: $name',
        style: TextStyle(fontSize: 20, color: Colors.black38));

    Widget buttonsection = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.lightGreen, // background
        onPrimary: Colors.black,
        padding: const EdgeInsets.all(15), // foreground
      ),
      onPressed: () {
        _MyAppState().logoutAction();
        exit(0);
      },
      child: Text('Logout'),
    );

    return ListView(
      children: [
        imagesection,
        textsection,
        buttonsection,
      ],
    );
  }
}

// #####################################
//         Handles Login page
// #####################################

class Login extends StatelessWidget {
  final loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.lightGreen, // background
            onPrimary: Colors.black, // foreground
          ),
          onPressed: () {
            loginAction();
          },
          child: Text('Login'),
        ),
        Text(loginError ?? ''),
      ],
    );
  }
}

// #####################################
//            Run Main App
// #####################################

void main() {
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

String name;
String picture;

// #####################################
//Maintain login logout states and errors
// #####################################

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app1',
      home: Scaffold(
        appBar: AppBar(
          title: StreamBuilder<Object>(
              stream: appBloc.titleStream,
              initialData: "Home",
              builder: (context, snapshot) {
                return Text(snapshot.data);
              }),
        ),
        body: Center(
          child: isBusy
              ? CircularProgressIndicator()
              : isLoggedIn
                  ? FirstRoute()
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access'],
        ),
      );

      final idToken = parseIdToken(result.idToken);
      final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);
      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  @override
  void initState() {
    initAction();
    super.initState();
  }

  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final idToken = parseIdToken(response.idToken);
      final profile = await getUserDetails(response.accessToken);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
  }
}
