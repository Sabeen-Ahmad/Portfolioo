import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dart:math' as math;

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _skillController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _bounceController;
  late AnimationController _shimmerController;
  late AnimationController _floatingController;
  late AnimationController _typewriterController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _skillAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<int> _typewriterAnimation;

  bool _isSkillsVisible = false;
  String _fullText = "Crafting Digital\nExperiences with Purpose";
  String _displayText = "";

  @override
  void initState() {
    super.initState();

    // Existing animations
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut)
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _skillController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _skillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _skillController, curve: Curves.easeInOut)
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
    );

    _rotateController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut)
    );

    // New animations
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut)
    );

    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut)
    );

    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
        CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut)
    );

    _typewriterController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    _typewriterAnimation = IntTween(begin: 0, end: _fullText.length).animate(
        CurvedAnimation(parent: _typewriterController, curve: Curves.easeOut)
    );

    // Listen to typewriter animation
    _typewriterAnimation.addListener(() {
      setState(() {
        _displayText = _fullText.substring(0, _typewriterAnimation.value);
      });
    });

    // Start animations with delays
    _fadeController.forward();
    _typewriterController.forward();

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        _slideController.forward();
        _bounceController.forward();
      }
    });

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _shimmerController.repeat(reverse: true);
        _floatingController.repeat(reverse: true);
      }
    });

    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSkillsVisible = true;
        });
        _skillController.forward();
      }
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
        _rotateController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _skillController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _bounceController.dispose();
    _shimmerController.dispose();
    _floatingController.dispose();
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.textLight;
    final subtextColor = AppColors.subtextLight;
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : 20,
                vertical: isDesktop ? 120 : 60,
              ),
              child: Column(
                children: [
                  if (isDesktop) _buildDesktopLayout(textColor, subtextColor)
                  else _buildMobileLayout(textColor, subtextColor),

                  SizedBox(height: isDesktop ? 80 : 60),
                  _buildAnimatedMissionCard(),
                  SizedBox(height: isDesktop ? 60 : 40),
                  _buildParticleBackground(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(Color textColor, Color subtextColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: _buildTextContent(textColor, subtextColor)),
        SizedBox(width: 80),
        Expanded(flex: 3, child: _buildAnimatedImageSection()),
      ],
    );
  }

  Widget _buildMobileLayout(Color textColor, Color subtextColor) {
    return Column(
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: _buildGlassmorphismCard(
            child: _buildTextContent(textColor, subtextColor),
          ),
        ),
        SizedBox(height: 40),
        _buildAnimatedImageSection(),
      ],
    );
  }

  Widget _buildGlassmorphismCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white.withOpacity(0.1),
          child: child,
        ),
      ),
    );
  }

  Widget _buildTextContent(Color textColor, Color subtextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animated badge with shimmer effect
        _buildShimmerBadge(),

        SizedBox(height: 24),

        // Typewriter effect title
        _buildTypewriterTitle(textColor),

        SizedBox(height: 32),

        // Animated description card with bounce effect
        _buildBounceCard(textColor, subtextColor),

        SizedBox(height: 40),
        _buildAnimatedSkillsCard(textColor, subtextColor),
      ],
    );
  }

  Widget _buildShimmerBadge() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-0.5, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withOpacity(0.1),
                  Colors.teal.withOpacity(0.3),
                  Colors.teal.withOpacity(0.1),
                ],
                stops: [0.0, 0.5, 1.0],
                transform: GradientRotation(_shimmerAnimation.value * math.pi),
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Text(
              "About Me",
              style: TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypewriterTitle(Color textColor) {
    return AnimatedBuilder(
      animation: _typewriterAnimation,
      builder: (context, child) {
        return Row(
          children: [
            Expanded(
              child: Text(
                _displayText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            if (_typewriterController.isAnimating)
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return AnimatedOpacity(
                    opacity: (_fadeController.value * 2) % 1.0 > 0.5 ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      width: 3,
                      height: 42,
                      color: Colors.teal,
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildBounceCard(Color textColor, Color subtextColor) {
    return ScaleTransition(
      scale: _bounceAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildGlassmorphismCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedOpacity(
                opacity: _fadeController.value,
                duration: Duration(milliseconds: 1000),
                child: Text(
                  "I'm a passionate Flutter developer with 2 years of experience creating beautiful, performant mobile and web applications. I specialize in turning complex problems into simple, elegant solutions.",
                  style: TextStyle(color: subtextColor, fontSize: 18, height: 1.7),
                ),
              ),
              SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _fadeController.value,
                duration: Duration(milliseconds: 1500),
                child: Text(
                  "My expertise spans across Flutter, Dart, Firebase, and modern UI/UX design principles. I believe in creating digital products that not only look beautiful but also provide meaningful experiences for users.",
                  style: TextStyle(color: subtextColor, fontSize: 18, height: 1.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSkillsCard(Color textColor, Color subtextColor) {
    final skills = [
      {'name': 'Flutter Development', 'level': 0.85, 'color': Colors.blue},
      {'name': 'UI/UX Design', 'level': 0.85, 'color': Colors.purple},
      {'name': 'Firebase Integration', 'level': 0.80, 'color': Colors.orange},
      {'name': 'Cross-platform Apps', 'level': 0.72, 'color': Colors.green},
    ];

    return AnimatedOpacity(
      opacity: _isSkillsVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 800),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _skillController, curve: Curves.easeOut)),
        child: _buildGlassmorphismCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Core Expertise",
                style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ...skills.asMap().entries.map((entry) {
                int index = entry.key;
                Map skill = entry.value;
                return AnimatedBuilder(
                  animation: _skillController,
                  builder: (context, child) {
                    double delay = index * 0.2;
                    double animationValue = (_skillController.value - delay).clamp(0.0, 1.0);

                    return _buildAnimatedSkillBar(
                      skill['name'] as String,
                      skill['level'] as double,
                      skill['color'] as Color,
                      animationValue,
                      textColor,
                      subtextColor,
                    );
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSkillBar(String name, double level, Color color, double animationValue, Color textColor, Color subtextColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500)),
              AnimatedOpacity(
                opacity: animationValue,
                duration: Duration(milliseconds: 300),
                child: Text("${(level * 100).round()}%", style: TextStyle(color: subtextColor, fontSize: 14)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: subtextColor.withOpacity(0.2),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: level * animationValue,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
                // Animated shimmer effect
                if (animationValue > 0)
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shimmerController.value * 100, 0),
                        child: Container(
                          width: 20,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedImageSection() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut)),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingAnimation.value * 0.3),
                child: Transform.scale(
                  scale: _pulseAnimation.value * 0.98 + 0.02,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.withOpacity(0.3),
                          Colors.blue.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2 * _pulseAnimation.value),
                          blurRadius: 30,
                          offset: Offset(0, 20),
                        ),
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1 * _pulseAnimation.value),
                          blurRadius: 50,
                          offset: Offset(0, 30),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset('assets/c.jpg', fit: BoxFit.cover),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAnimatedMissionCard() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 900),
            padding: EdgeInsets.all(48),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4FD1C7),
                  Color(0xFF2DD4BF),
                  Color(0xFF0891B2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3 * _pulseAnimation.value),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2 * _pulseAnimation.value),
                  blurRadius: 50,
                  offset: Offset(0, 25),
                ),
              ],
            ),
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: _fadeController.value,
                  duration: Duration(milliseconds: 2000),
                  child: Text(
                    "My mission is to turn real-life problems into smart, scalable Flutter solutions — building apps that reflect creativity, purpose, and clean code. I strive to deliver experiences that are not just functional but truly meaningful for users.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                ),
                SizedBox(height: 40),
                Wrap(
                  spacing: 40,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildAnimatedBrandLogo("Flutter", Icons.flutter_dash, 0),
                    _buildAnimatedBrandLogo("Firebase", Icons.local_fire_department, 1),
                    _buildAnimatedBrandLogo("Android", Icons.android, 2),
                    _buildAnimatedBrandLogo("iOS", Icons.phone_iphone, 3),
                    _buildAnimatedBrandLogo("Web", Icons.web, 4),
                    _buildAnimatedBrandLogo("Design", Icons.design_services, 5),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBrandLogo(String name, IconData icon, int index) {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (context, child) {
        double rotation = (_rotateController.value + (index * 0.1)) % 1.0;

        return AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, math.sin(_floatingController.value * 2 * math.pi + index) * 5),
              child: AnimatedOpacity(
                opacity: _fadeController.value,
                duration: Duration(milliseconds: 1500 + (index * 200)),
                child: Transform.rotate(
                  angle: rotation * 2 * math.pi,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Transform.rotate(
                          angle: -rotation * 2 * math.pi,
                          child: Icon(icon, color: Colors.white, size: 24),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        name,
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildParticleBackground() {
    return Container(
      height: 200,
      child: Stack(
        children: List.generate(20, (index) {
          return AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              double offset = math.sin(_floatingController.value * 2 * math.pi + index) * 50;
              return Positioned(
                left: (index * 30.0) % MediaQuery.of(context).size.width,
                top: 100 + offset,
                child: AnimatedOpacity(
                  opacity: 0.3 + (math.sin(_floatingController.value * 2 * math.pi + index) * 0.2),
                  duration: Duration(milliseconds: 100),
                  child: Container(
                    width: 4 + (index % 3) * 2,
                    height: 4 + (index % 3) * 2,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.5),
                      shape: BoxShape.circle,
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