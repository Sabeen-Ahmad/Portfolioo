import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import 'app_colors.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  late AnimationController _headerController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _hoverController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _headerAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  List<AnimationController> _cardControllers = [];
  List<Animation<double>> _cardAnimations = [];
  List<Animation<Offset>> _cardSlideAnimations = [];
  List<Animation<double>> _cardScaleAnimations = [];

  final List<Map<String, dynamic>> workProjects = [
    {
      'title': 'Sizzle AI - AI-Powered Quiz Generator',
      'description': 'An intelligent quiz generator that leverages AI to create personalized multiple-choice questions (MCQs) on any topic. It uses NGROK as a bridge to the locally hosted model server and integrates Open Trivia DB API for diverse question sourcing. Designed with a smooth UI and real-time question rendering for an enhanced learning experience.',
      'technologies': ['Flutter', 'Dart', 'Python', 'NGROK', 'REST API', 'State Management', 'MCQ Model Integration'],
      'githubLink': 'https://github.com/Sabeen-Ahmad134/quiz_app',
      'liveLink': 'https://www.linkedin.com/feed/update/urn:li:activity:7354373983636484096/',
      'image': 'assets/quiz.png',
    },
    {
      'title': 'Music Player App',
      'description': 'A sleek and responsive Flutter-based music player with playlist support, shuffle, play/pause, previous/next controls, and real-time seekbar. Built with clean architecture and smooth audio transitions for a user-friendly experience.',
      'technologies': ['Flutter', 'Dart', 'audioplayers', 'State Management', 'Custom UI'],
      'githubLink': 'https://github.com/Sabeen-Ahmad134/music_player_app',
      'liveLink': 'https://www.linkedin.com/posts/sabeen-ahmad-0103012a3_flutter-musicapp-audioplayers-activity-7304506277588566016-N06S?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEkxmswBkZZBtlW7ZtbNp0iNWfSy-LC7z_0',
      'image': 'assets/music.png',
    }
  ];

  final List<Map<String, dynamic>> hobbyProjects = [
    {
      'title': 'Sneakers E-Commerce App',
      'description': 'A stylish and responsive mobile app dedicated to sneaker lovers, offering smooth navigation, sleek product displays, cart, wishlist, and secure checkout functionality.',
      'technologies': ['Flutter', 'Firebase', 'REST API', 'Provider'],
      'githubLink': 'https://github.com/Sabeen-Ahmad134/e-commerce_app',
      'liveLink': 'https://www.linkedin.com/posts/sabeen-ahmad-0103012a3_im-thrilled-to-share-a-glimpse-into-my-flutter-activity-7277807924364611585-UNkt?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEkxmswBkZZBtlW7ZtbNp0iNWfSy-LC7z_0',
      'image': 'assets/e.jpeg',
    },
    {
      'title': 'Personal Body Mass Calculator',
      'description': 'A simple and elegant BMI calculator app that helps users monitor their body weight status based on height and weight inputs, with intuitive UI and instant results.',
      'technologies': ['Flutter', 'Dart', 'Custom UI'],
      'githubLink': 'https://github.com/Sabeen-Ahmad134/finance-tracker',
      'liveLink': 'https://www.linkedin.com/posts/sabeen-ahmad-0103012a3_im-excited-to-share-my-latest-flutter-projecta-activity-7280658455416164353-u0qz?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEkxmswBkZZBtlW7ZtbNp0iNWfSy-LC7z_0',
      'image': 'assets/m.png',
    },
    {
      'title': 'Coffee Ordering App',
      'description': 'A sleek and user-friendly coffee ordering app allowing users to browse coffee types, customize orders, and place pickups or deliveries with ease.',
      'technologies': ['Flutter', 'Firebase', 'Provider', 'Payment Integration'],
      'githubLink': 'https://github.com/Sabeen-Ahmad134/cafe_app',
      'liveLink': 'https://www.linkedin.com/posts/sabeen-ahmad-0103012a3_flutter-coffeelovers-mobileappdevelopment-activity-7277584537470013441-HTb8?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEkxmswBkZZBtlW7ZtbNp0iNWfSy-LC7z_0',
      'image': 'assets/cafe.jpeg',
    },
    {
      'title': 'COVID-19 Tracker App',
      'description': 'A real-time COVID-19 tracking app displaying global and regional case statistics, recoveries, and deaths with interactive charts and a clean UI.',
      'technologies': ['Flutter', 'REST API', 'Charts', 'Provider'],
      'githubLink': 'https://github.com/Sabeen-Ahmad134/covid-tracker-app',
      'liveLink': null,
      'image': 'assets/covid.png',
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Main controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Main animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.elasticOut),
    );

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Card animations
    int totalProjects = workProjects.length + hobbyProjects.length;
    for (int i = 0; i < totalProjects; i++) {
      AnimationController cardController = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      );

      Animation<double> cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: cardController, curve: Curves.easeOut),
      );

      Animation<Offset> cardSlideAnimation = Tween<Offset>(
        begin: Offset(0, 0.8),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: cardController, curve: Curves.elasticOut));

      Animation<double> cardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: cardController, curve: Curves.elasticOut),
      );

      _cardControllers.add(cardController);
      _cardAnimations.add(cardAnimation);
      _cardSlideAnimations.add(cardSlideAnimation);
      _cardScaleAnimations.add(cardScaleAnimation);
    }
  }

  void _startAnimationSequence() async {
    _fadeController.forward();
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);

    await Future.delayed(Duration(milliseconds: 300));
    _headerController.forward();

    await Future.delayed(Duration(milliseconds: 500));
    _slideController.forward();

    // Stagger card animations
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) _cardControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _staggerController.dispose();
    _headerController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _hoverController.dispose();

    for (var controller in _cardControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: '_blank',
        );
      } else {
        _showSnackBar('Could not launch $url');
      }
    } catch (e) {
      _showSnackBar('Error launching URL: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryLight;
    final textColor = AppColors.textLight;
    final subtextColor = AppColors.subtextLight;
    final cardColor = AppColors.cardLight;

    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingAnimation.value * 0.3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildAnimatedHeader(textColor, subtextColor),
                    const SizedBox(height: 80),
                    _buildWorkProjectsSection(primaryColor, textColor, subtextColor, cardColor),
                    const SizedBox(height: 80),
                    _buildHobbyProjectsSection(primaryColor, textColor, subtextColor, cardColor),
                    _buildFloatingParticles(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedHeader(Color textColor, Color subtextColor) {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        return Transform.scale(
          scale: _headerAnimation.value,
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.teal, Colors.blue, Colors.purple],
                ).createShader(bounds),
                child: Text(
                  'My Projects',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.teal.withOpacity(0.3)),
                  ),
                  child: Text(
                    'A showcase of my professional work and personal experiments',
                    style: TextStyle(
                      color: subtextColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkProjectsSection(Color primaryColor, Color textColor, Color subtextColor, Color cardColor) {
    return Column(
      children: [
        _buildAnimatedSectionHeader(
          'Professional Work',
          'Enterprise projects',
          Icons.work,
          primaryColor,
          textColor,
          subtextColor,
        ),
        const SizedBox(height: 40),
        _buildProjectsGrid(
          workProjects,
          primaryColor,
          textColor,
          subtextColor,
          cardColor,
          isWorkProject: true,
          startIndex: 0,
        ),
      ],
    );
  }

  Widget _buildHobbyProjectsSection(Color primaryColor, Color textColor, Color subtextColor, Color cardColor) {
    return Column(
      children: [
        _buildAnimatedSectionHeader(
          'Personal Projects',
          'Side projects and learning experiments',
          Icons.favorite,
          primaryColor,
          textColor,
          subtextColor,
        ),
        const SizedBox(height: 40),
        _buildProjectsGrid(
          hobbyProjects,
          primaryColor,
          textColor,
          subtextColor,
          cardColor,
          isWorkProject: false,
          startIndex: workProjects.length,
        ),
      ],
    );
  }

  Widget _buildAnimatedSectionHeader(
      String title,
      String subtitle,
      IconData icon,
      Color primaryColor,
      Color textColor,
      Color subtextColor,
      ) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _floatingController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _floatingController.value * 2 * math.pi * 0.1,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  primaryColor.withOpacity(0.2),
                                  primaryColor.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: primaryColor,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.7)],
                      ).createShader(bounds),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtextColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectsGrid(
      List<Map<String, dynamic>> projects,
      Color primaryColor,
      Color textColor,
      Color subtextColor,
      Color cardColor, {
        required bool isWorkProject,
        required int startIndex,
      }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 3
            : constraints.maxWidth > 800 ? 2 : 1;
        final childAspectRatio = constraints.maxWidth > 800 ? 0.8 : 1.1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return _buildAnimatedProjectCard(
              projects[index],
              primaryColor,
              textColor,
              subtextColor,
              cardColor,
              isWorkProject: isWorkProject,
              animationIndex: startIndex + index,
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedProjectCard(
      Map<String, dynamic> project,
      Color primaryColor,
      Color textColor,
      Color subtextColor,
      Color cardColor, {
        required bool isWorkProject,
        required int animationIndex,
      }) {
    if (animationIndex >= _cardControllers.length) return SizedBox.shrink();

    return AnimatedBuilder(
      animation: _cardControllers[animationIndex],
      builder: (context, child) {
        return FadeTransition(
          opacity: _cardAnimations[animationIndex],
          child: SlideTransition(
            position: _cardSlideAnimations[animationIndex],
            child: ScaleTransition(
              scale: _cardScaleAnimations[animationIndex],
              child: MouseRegion(
                onEnter: (_) => _hoverController.forward(),
                onExit: (_) => _hoverController.reverse(),
                child: AnimatedBuilder(
                  animation: _hoverController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_hoverController.value * 0.05),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1 + _hoverController.value * 0.1),
                              blurRadius: 20 + (_hoverController.value * 10),
                              offset: Offset(0, 10 + (_hoverController.value * 5)),
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: cardColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAnimatedProjectImage(project, primaryColor, isWorkProject),
                              _buildProjectContent(project, primaryColor, textColor, subtextColor, isWorkProject),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedProjectImage(Map<String, dynamic> project, Color primaryColor, bool isWorkProject) {
    return Stack(
      children: [
        if (project['image'] != null)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Image.asset(
                project['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(primaryColor, isWorkProject),
              ),
            ),
          ),
        Positioned(
          top: 12,
          right: 12,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi) * 2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isWorkProject
                        ? primaryColor.withOpacity(0.9)
                        : Colors.pink.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (isWorkProject ? primaryColor : Colors.pink).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    isWorkProject ? 'PRO' : 'PERSONAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProjectContent(
      Map<String, dynamic> project,
      Color primaryColor,
      Color textColor,
      Color subtextColor,
      bool isWorkProject,
      ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [textColor, textColor.withOpacity(0.7)],
              ).createShader(bounds),
              child: Text(
                project['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                project['description'],
                style: TextStyle(
                  color: subtextColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildAnimatedTechChips(project['technologies'], primaryColor),
            const SizedBox(height: 16),
            _buildActionButtons(project, subtextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTechChips(List technologies, Color primaryColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: technologies.asMap().entries.map((entry) {
        int index = entry.key;
        String tech = entry.value;

        return AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi + index * 0.5) * 1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      primaryColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  tech,
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> project, Color subtextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (project['liveLink'] != null)
          _buildAnimatedActionButton(
            'View Live',
            Icons.launch,
                () => _launchURL(project['liveLink']),
            subtextColor,
          ),
        if (project['liveLink'] != null) const SizedBox(width: 10),
        _buildAnimatedActionButton(
          'Source Code',
          Icons.code,
              () => _launchURL(project['githubLink']),
          subtextColor,
        ),
      ],
    );
  }

  Widget _buildAnimatedActionButton(
      String label,
      IconData icon,
      VoidCallback onPressed,
      Color primaryColor,
      ) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value * 0.02 + 0.98,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  primaryColor.withOpacity(0.05),
                ],
              ),
            ),
            child: TextButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 16, color: primaryColor),
              label: Text(
                label,
                style: TextStyle(color: primaryColor),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: primaryColor.withOpacity(0.3)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder(Color primaryColor, bool isWorkProject) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.2),
            primaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + math.sin(_floatingController.value * 2 * math.pi) * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isWorkProject ? Icons.work : Icons.code,
                    size: 48,
                    color: primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Project Preview',
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Container(
      height: 100,
      child: Stack(
        children: List.generate(15, (index) {
          return AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              double offset = math.sin(_floatingController.value * 2 * math.pi + index) * 30;
              return Positioned(
                left: (index * 50.0) % MediaQuery.of(context).size.width,
                top: 50 + offset,
                child: AnimatedOpacity(
                  opacity: 0.2 + (math.sin(_floatingController.value * 2 * math.pi + index) * 0.1),
                  duration: Duration(milliseconds: 100),
                  child: Container(
                    width: 6 + (index % 4) * 2,
                    height: 6 + (index % 4) * 2,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.teal.withOpacity(0.6),
                          Colors.blue.withOpacity(0.3),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}