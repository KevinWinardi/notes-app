import 'package:flutter/material.dart';
import 'package:notes_app/configs/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: whiteColor,
          backgroundColor: primaryColor,
          title: Text('About'),
          leading: IconButton(
            tooltip: 'Back',
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/notes_app_logo.png', width: 250, height: 250),
              Text(
                'Notes App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text('Version: 1.0'),
            ],
          ),
        ),
      ),
    );
  }
}
