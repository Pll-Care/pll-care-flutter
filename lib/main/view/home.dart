import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 80.w,
          leading: Image.asset(
            'assets/images/logo2.png',
            width: 80.w,
            height: 50.h,
            fit: BoxFit.fitWidth,
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Log In',
              ),
            ),
          ],
        ),
        body: Column(),
      ),
    );
  }
}
