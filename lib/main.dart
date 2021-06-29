import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:magic_heat/providers/appUser.dart';
import 'package:magic_heat/routeManager.dart';
import 'package:magic_heat/screens/authentication/signupScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import './screens/home/homeScreen.dart';
import './services/authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  try {
    await Firebase.initializeApp();

    runApp(MyApp(false));
  } catch (e) {
    runApp(MyApp(true));
  }
}

class MyApp extends StatelessWidget {
  final bool hasError;

  MyApp(this.hasError);

  @override
  Widget build(BuildContext context) {
    return Initialize();
  }
}

class Initialize extends StatefulWidget {
  @override
  _InitializeState createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  /// true when there is a sign in/out operation
  bool checkingUser;

  ThemeData themeData;
  AppUser currentUser;

  @override
  void initState() {
    super.initState();

    checkingUser = true;

    themeData = ThemeData(
      primarySwatch: Colors.green,
      accentColor: Colors.grey[50],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme.of(context).copyWith(
        elevation: 0,
      ),
      buttonTheme: ButtonTheme.of(context).copyWith(
        buttonColor: Colors.amber,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    initialize();
  }

  void initialize() async {
    try {
      // check the user's authentication status and change ui based on that
      Authentication.onAuthStateChanged.listen((user) async {
        if (mounted)
          setState(() {
            checkingUser = true;
          });

        if (user == null) {
          currentUser = AppUser(
            id: '0',
            name: null,
            photoUrl: null,
            email: null,
            password: null,
            creationDate: null,
          );
        } else {
          currentUser = AppUser(
            id: user.uid,
            name: user.displayName,
            photoUrl: user.photoURL,
            email: user.email,
            password: null,
            creationDate: user.metadata.creationTime,
          );
        }

        if (mounted)
          setState(() {
            checkingUser = false;
          });
      });
    } catch (e) {
      print('Error $e in "Firebase.initializeApp()".');

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (checkingUser)
      return MaterialApp(
        key: UniqueKey(),
        title: 'Magic Heat',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: Scaffold(
          body: Center(
            child: Text('Switching User State'),
          ),
        ),
      );

    return ChangeNotifierProvider<AppUser>(
      create: (context) => currentUser,
      child: MaterialApp(
        key: UniqueKey(),
        title: 'Magic Heat',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        initialRoute: currentUser.id == '0'
            ? SignupScreen.routePath
            : HomeScreen.routePath,
        onGenerateInitialRoutes: (route) {
          if (route == SignupScreen.routePath)
            return [
              MaterialPageRoute(builder: (context) => SignupScreen()),
            ];

          return [
            MaterialPageRoute(builder: (context) => HomeScreen()),
          ];
        },
        onGenerateRoute: (RouteSettings settings) {
          return RouteManager.generateRoute(settings, context);
        },
      ),
    );
  }
}
