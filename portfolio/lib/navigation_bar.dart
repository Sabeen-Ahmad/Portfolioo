

// Navigation Bar Component
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class ScrollIndicator extends StatefulWidget {
  final bool isDarkMode;

  const ScrollIndicator({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _ScrollIndicatorState createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _scrollController.repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =  AppColors.primaryLight;     // Powder Blue

    final subtextColor =  AppColors.subtextLight;     // Gray

    return Center(
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          return Column(
            children: [
              Text(
                'Scroll Down',
                style: TextStyle(
                  color: subtextColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              Transform.translate(
                offset: Offset(0, 10 * _scrollController.value),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 24,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
