import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class SkillsScreen extends StatefulWidget {
  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _titleController;
  late List<Animation<double>> _serviceAnimations;
  late Animation<double> _titleFadeAnimation;
  late Animation<Offset> _titleSlideAnimation;

  final List<Map<String, dynamic>> services = [
    {
      'title': 'Flutter Development',
      'number': '01',
      'description': 'I build fast and responsive cross-platform mobile apps using Flutter. From clean UI to backend integrations like Firebase and REST APIs, I ensure your app is modern, scalable, and ready for production.',
      'icon': Icons.phone_android,
      'color': Colors.blue,
    },
    {
      'title': 'App Architecture',
      'number': '02',
      'description': 'With hands-on experience in MVC, MVVM, and Provider, I structure apps for long-term growth. My focus is on clean architecture, maintainable code, and optimized performance.',
      'icon': Icons.architecture,
      'color': Colors.purple,
    },
    {
      'title': 'UI/UX Design',
      'number': '03',
      'description': 'I design sleek, intuitive interfaces with proper state handling and responsive layouts. Whether it’s dark mode, smooth animations, or custom widgets—I make sure the app feels premium.',
      'icon': Icons.design_services,
      'color': Colors.pink,
    },
    {
      'title': 'Custom Solutions',
      'number': '04',
      'description': 'From e-commerce and smart home apps to student portals and trackers, I develop tailored apps that solve real-world problems using the latest in Flutter and Firebase technology.',
      'icon': Icons.build_circle,
      'color': Colors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _staggerController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutCubic,
    ));

    _titleSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.elasticOut,
    ));

    _serviceAnimations = List.generate(services.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(
          0.2 + (index * 0.15),
          0.7 + (index * 0.15),
          curve: Curves.elasticOut,
        ),
      ));
    });
  }

  void _startAnimations() {
    _titleController.forward().then((_) {
      _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor =  AppColors.textLight;
    final subtextColor =  AppColors.subtextLight;
    final cardColor =  AppColors.cardLight;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: isDesktop ? 40 : 20,
      ),
      child: Column(
        children: [
          SizedBox(height: isDesktop ? 40 : 20),
          _buildTitle(textColor),
          SizedBox(height: isDesktop ? 60 : 40),
          _buildServicesGrid(textColor, subtextColor, cardColor, isDesktop),
        ],
      ),
    );
  }
  Widget _buildTitle(Color textColor) {
    return AnimatedBuilder(
      animation: _titleController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _titleFadeAnimation,
          child: SlideTransition(
            position: _titleSlideAnimation,
            child: Column(
              children: [
                // Section tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.teal.withOpacity(0.3)),
                  ),
                  child: Text(
                    "Services",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Main title
                Text(
                  "How Can I\nAssist You?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesGrid(Color textColor, Color subtextColor, Color cardColor, bool isDesktop) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, child) {
        if (isDesktop) {
          return _buildDesktopGrid(textColor, subtextColor, cardColor);
        } else {
          return _buildMobileGrid(textColor, subtextColor, cardColor);
        }
      },
    );
  }

  Widget _buildDesktopGrid(Color textColor, Color subtextColor, Color cardColor) {
    return Container(
      constraints: BoxConstraints(maxWidth: 1200),
      child: Column(
        children: [
          // First row
          Row(
            children: [
              Expanded(
                child: _buildServiceCard(0, textColor, subtextColor, cardColor),
              ),
              SizedBox(width: 40),
              Expanded(
                child: _buildServiceCard(1, textColor, subtextColor, cardColor),
              ),
            ],
          ),
          SizedBox(height: 40),
          // Second row
          Row(
            children: [
              Expanded(
                child: _buildServiceCard(2, textColor, subtextColor, cardColor),
              ),
              SizedBox(width: 40),
              Expanded(
                child: _buildServiceCard(3, textColor, subtextColor, cardColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileGrid(Color textColor, Color subtextColor, Color cardColor) {
    return Column(
      children: services.asMap().entries.map((entry) {
        int index = entry.key;
        return Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: _buildServiceCard(index, textColor, subtextColor, cardColor),
        );
      }).toList(),
    );
  }

  Widget _buildServiceCard(int index, Color textColor, Color subtextColor, Color cardColor) {
    final service = services[index];

    return Transform.scale(
      scale: _serviceAnimations[index].value,
      child: Opacity(
        opacity: _serviceAnimations[index].value,
        child: Container(
          height: 280,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: service['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      service['icon'],
                      color: service['color'],
                      size: 24,
                    ),
                  ),
                  Text(
                    service['number'],
                    style: TextStyle(
                      color: subtextColor.withOpacity(0.5),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Title
              Text(
                service['title'],
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16),

              // Description
              Expanded(
                child: Text(
                  service['description'],
                  style: TextStyle(
                    color: subtextColor,
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}