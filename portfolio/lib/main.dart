import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/portfolio_home_page.dart';

void main() {
  runApp(PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sabeen Ahmad Portfolio',
      debugShowCheckedModeBanner: false,
      home: PortfolioHomePage(),
    );
  }
}



