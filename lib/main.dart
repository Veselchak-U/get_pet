import 'package:cats/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cats & Pets',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (BuildContext context) => HomeCubit()..load(),
        child: HomeScreen(),
      ),
    );
  }
}
