import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:portfolio/app_colors.dart';

class HeroScreen extends StatefulWidget {

  final Function(double) scrollToSection;
  final VoidCallback toggleContactForm;

  const HeroScreen({
    Key? key,
    required this.scrollToSection,
    required this.toggleContactForm,
  }) : super(key: key);


  @override
  _HeroScreenState createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _typewriterController;
  late AnimationController _cardController;
  late AnimationController _navigationController;

  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideFromLeftAnimation;
  late Animation<Offset> _slideFromRightAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _scaleAnimation;

  int _typewriterIndex = 0;
  String _currentText = "";
  final List<String> _roles = ['Flutter Developer', 'Mobile App Creator', 'UI/UX Enthusiast'];
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _startNavigationAnimation();
  }

  void _initializeAnimations() {
    _heroController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _typewriterController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _navigationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _slideFromLeftAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideFromRightAnimation = Tween<Offset>(
      begin: Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    _heroController.forward();
    _floatingController.repeat(reverse: true);
    _cardController.forward();
    _startTypewriter();
  }

  void _startNavigationAnimation() {
    Future.delayed(Duration(milliseconds: 2500), () {
      if (mounted) {
        _navigationController.forward();
      }
    });
  }

  void _startTypewriter() {
    _typewriterController.addListener(() {
      final progress = _typewriterController.value;
      final currentRole = _roles[_typewriterIndex % _roles.length];
      final targetLength = (currentRole.length * progress).round();

      setState(() {
        _currentText = currentRole.substring(0, targetLength);
      });
    });

    _typewriterController.forward().then((_) {
      Future.delayed(Duration(milliseconds: 1500), () {
        _typewriterIndex++;
        _typewriterController.reset();
        _startTypewriter();
      });
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _floatingController.dispose();
    _typewriterController.dispose();
    _cardController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  Color get _primaryColor =>  AppColors.primaryLight;
  Color get _textColor =>  AppColors.textLight;
  Color get _subtextColor =>  AppColors.subtextLight;
  Color get _cardColor =>  AppColors.cardLight;
  Color get _backgroundColor =>  AppColors.backgroundLight;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 1024;

    return Container(
      height: screenHeight,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 20,
          vertical: 60,
        ),
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left side - Text content
        Expanded(
          flex: 6,
          child: SlideTransition(
            position: _slideFromLeftAnimation,
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGreeting(),
                  SizedBox(height: 10),
                  _buildMainTitle(),
                  SizedBox(height: 15),
                  _buildAnimatedRole(),
                  SizedBox(height: 30),
                  _buildDescription(),
                  SizedBox(height: 40),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 60),

        // Right side - Profile and floating elements
        Expanded(
          flex: 5,
          child: SlideTransition(
            position: _slideFromRightAnimation,
            child: _buildRightSection(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Theme Toggle for Mobile - Top Right
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildProfileSection(),

          SizedBox(height: 40),
          _buildGreeting(),
          SizedBox(height: 15),
          _buildMainTitle(),
          SizedBox(height: 10),
          _buildAnimatedRole(),
          SizedBox(height: 25),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 3000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Text(
              "Hi, I'm Sabeen",
              style: TextStyle(
                color: _subtextColor,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainTitle() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
                children: [
                  TextSpan(
                    text: "a ",
                    style: TextStyle(color: _textColor),
                  ),
                  TextSpan(
                    text: "flutter\n",
                    style: TextStyle(color: _textColor),
                  ),
                  TextSpan(
                    text: "developer",
                    style: TextStyle(color: _primaryColor),
                  ),
                  TextSpan(
                    text: "©",
                    style: TextStyle(
                      color: _subtextColor,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedRole() {
    return Container(
      height: 35,
      child: Row(
        children: [
          Text(
            "I'm a ",
            style: TextStyle(
              color: _subtextColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _primaryColor.withOpacity(0.3)),
            ),
            child: Text(
              _currentText + "|",
              style: TextStyle(
                color: _primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Courier',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Text(
                "I have 2 years of experience working on useful and mindful products together with startups and known brands.",
                style: TextStyle(
                  color: _subtextColor,
                  fontSize: 18,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 2000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                _buildPrimaryButton(),
                SizedBox(width: 20),
                _buildSecondaryButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrimaryButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.toggleContactForm,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: _textColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _textColor.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            "Contact Me",
            style: TextStyle(
              color: _backgroundColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.scrollToSection(3500),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: _subtextColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            "View Work",
            style: TextStyle(
              color: _subtextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightSection() {
    return Stack(
      children: [
        // Main profile image with navigation
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileSection(),
              SizedBox(height: 30),

            ],
          ),
        ),

        // Floating cards
        AnimatedBuilder(
          animation: _floatingAnimation,
          builder: (context, child) {
            return Positioned(
              top: 100 + _floatingAnimation.value,
              right: 50,
              child: _buildFloatingCard(
                "Sheikhupura, Pakistan",
                Icons.location_on,
                Colors.blue,
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _floatingAnimation,
          builder: (context, child) {
            return Positioned(
              bottom: 120 - _floatingAnimation.value,
              left: 20,
              child: _buildFloatingCard(
                "Later",
                Icons.monetization_on,
                Colors.green,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: Container(
            width: 280,
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/a.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildFloatingCard(String text, IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 2500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}