import 'package:ebi/pages/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ebi!',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        splashFactory: InkSparkle.splashFactory,
      ),
      home: HomePage(),
    );
  }
}
