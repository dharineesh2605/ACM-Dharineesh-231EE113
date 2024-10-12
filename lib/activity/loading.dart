import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, "/home");

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset("images/logo1.png", width: 150),
            ),
            SizedBox(height: 20),
            Text("Weather", style: TextStyle(fontSize: 30, color: Colors.white)),
            SizedBox(height: 20),
            Text("Made by dhar", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
