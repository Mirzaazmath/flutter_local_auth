// THIS IMPORT IS USED TO TERMINAL THE APP
import 'dart:io';
// THIS IMPORT IS USED TO USE MATERIAL DESIGN
import 'package:flutter/material.dart';
// THIS IMPORT IS USED TO CLOSE THE ANDROID APP
import 'package:flutter/services.dart';
// THIS IMPORT IS USED TO CHECK THE PLATFORM EXECPTION ERRORS
import 'package:local_auth/error_codes.dart' as auth_error;
// THIS IMPORT IS USED TO USE THE LOCAL AUTH IN FLUTTER
import 'package:local_auth/local_auth.dart';
// MAIN
void main() {
  // RUNAPP
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // HERE WE ARE CREATING THE INSTANCE FOR LOCAL AUTH
  final LocalAuthentication auth = LocalAuthentication();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // CALLING THE checkLocalAuth METHOD TO CHECK THE LOCAL AUTH
    checkLocalAuth();
  }
// FUTURE METHODS TAKES TIME TO RETURN RESULT
  Future<void> checkLocalAuth() async {
    // HERE WE ARE CHECKING IF THE DEVICE HAS THE LOCAL AUTH OR NOT IT RETURNS BOOL
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    // IF THE RETURN VALUE IS TRUE WE ARE GOING TO PERFORM LOCAL AUTH
    if (canAuthenticateWithBiometrics) {
      // ALWAYS USE TRY CATCH TO HANDEL EXCEPTIONS
      try {
        // auth.authenticate RETURN RESULT OF  THE LOCAL AUTH IN BOOL
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to show account balance');

        debugPrint(didAuthenticate.toString());
      // CHECKING THE RESULT OF LOCAL AUTH
        if (didAuthenticate) {

        } else {
          // IF FALSE WE SIMPLY CLOSE THE APP
          // NOTE THIS LINE ONLY WORKS FOR ANDROID
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          // CLOSING THE APP

        }

        // CHECKING THE Exception TO HANDLE
      } on PlatformException catch (e) {
        // PRINTING THE ERROR
        debugPrint(e.toString());
         // BASED ON THE EXCEPTION ERROR WE ARE TRYING TO SOLVE THE ISSUE
        if (e.code == auth_error.notEnrolled) {
          // Add handling of no hardware here.
        } else if (e.code == auth_error.lockedOut ||
            e.code == auth_error.permanentlyLockedOut) {
          // ...
        } else if (e.code == auth_error.notAvailable) {
          // THIS ERROR HAPPENED WHEN I CANCEL FACE UNLOCK FROM IOS
          debugPrint("Exiting the App");
          // THIS LINE TERMINATE THE APP FORCEFULLY
          // NOTE DO NOT USE THIS, INSTEAD COME UP WITH DIFFERENT SOLUTION
          exit(0);
          // ...
        } else {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
