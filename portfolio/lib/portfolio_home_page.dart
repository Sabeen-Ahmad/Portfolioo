import 'dart:ui' as html;
import 'package:portfolio/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/project_screen.dart';
import 'package:portfolio/skill_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'about_screen.dart';
import 'contact_modal.dart';
import 'contact_screen.dart';
import 'hero_section.dart';
import 'main.dart';
import 'package:portfolio/navigation_bar.dart';

class PortfolioHomePage extends StatefulWidget {
  @override
  _PortfolioHomePageState createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage>
    with TickerProviderStateMixin {
  ScrollController _pageScrollController = ScrollController();
  bool _showScrollIndicator = true;
  bool _isDarkMode = true;
  bool _showContactForm = false;

  // Animation controllers
  late AnimationController _backgroundAnimationController;
  late AnimationController _themeTransitionController;
  late AnimationController _contactFormController;
  late AnimationController _scrollIndicatorController;
  late AnimationController _navBarController;

  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<double> _themeTransitionAnimation;
  late Animation<double> _contactFormAnimation;
  late Animation<double> _scrollIndicatorAnimation;
  late Animation<Offset> _navBarSlideAnimation;

  // Contact form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
  }

  void _initializeAnimations() {
    // Background animation for subtle movement
    _backgroundAnimationController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.linear,
      ),
    );
    _backgroundAnimationController.repeat();

    // Theme transition animation
    _themeTransitionController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _themeTransitionAnimation = CurvedAnimation(
      parent: _themeTransitionController,
      curve: Curves.easeInOutCubic,
    );

    // Contact form animation
    _contactFormController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _contactFormAnimation = CurvedAnimation(
      parent: _contactFormController,
      curve: Curves.elasticOut,
    );

    // Scroll indicator animation
    _scrollIndicatorController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _scrollIndicatorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scrollIndicatorController,
        curve: Curves.easeInOut,
      ),
    );
    _scrollIndicatorController.repeat(reverse: true);

    // Navigation bar animation
    _navBarController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _navBarSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _navBarController, curve: Curves.elasticOut),
    );

    // Start navigation bar animation
    Future.delayed(Duration(milliseconds: 500), () {
      _navBarController.forward();
    });
  }

  void _setupScrollListener() {
    _pageScrollController.addListener(() {
      final shouldShow = _pageScrollController.offset < 100;
      if (_showScrollIndicator != shouldShow) {
        setState(() {
          _showScrollIndicator = shouldShow;
        });
      }
    });
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _themeTransitionController.dispose();
    _contactFormController.dispose();
    _scrollIndicatorController.dispose();
    _navBarController.dispose();
    _pageScrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Color get _primaryColor => AppColors.primaryDark;

  Color get _backgroundColor => AppColors.backgroundLight;

  Color get _cardColor => AppColors.cardLight;

  Color get _textColor => AppColors.textLight;

  Color get _subtextColor => AppColors.subtextLight;

  void _scrollToSection(double offset) {
    _pageScrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeInOutCubic,
    );
  }

  void _toggleTheme() {
    _themeTransitionController.forward().then((_) {
      setState(() {
        _isDarkMode = !_isDarkMode;
      });
      _themeTransitionController.reverse();
    });
  }

  void _toggleContactForm() {
    setState(() {
      _showContactForm = !_showContactForm;
    });

    if (_showContactForm) {
      _contactFormController.forward();
    } else {
      _contactFormController.reverse();
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }

  // Contact form methods
  void _sendEmail() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showErrorDialog('Please enter a valid email address');
      return;
    }

    final subject = Uri.encodeComponent(
      'New Portfolio Contact from ${_nameController.text}',
    );
    final body = Uri.encodeComponent(
      'You have received a new contact form submission:\n\n'
      'CLIENT DETAILS:\n'
      'Name: ${_nameController.text}\n'
      'Email: ${_emailController.text}\n'
      'Date: ${DateTime.now().toString().split('.')[0]}\n\n'
      'PROJECT DESCRIPTION:\n'
      '${_messageController.text}\n\n'
      'REPLY TO: ${_emailController.text}\n\n'
      'This message was sent from your portfolio website contact form.',
    );

    final yourEmail = 'sabeenahmad796@gmail.com';
    final emailUrl =
        'mailto:$yourEmail?subject=$subject&body=$body&reply-to=${_emailController.text}';
    _launchURL(emailUrl);
    _showSuccessDialog();

    Future.delayed(Duration(seconds: 2), () {
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      _toggleContactForm();
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: _contactFormController,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.8 + (_contactFormController.value * 0.2),
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Error',
                        style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        message,
                        style: TextStyle(color: _subtextColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: _contactFormController,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.8 + (_contactFormController.value * 0.2),
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 48,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Success!',
                        style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Your message has been prepared for sending. Your email client should open shortly.',
                        style: TextStyle(color: _subtextColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Great!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
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

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5 + (_backgroundAnimation.value * 0.2),
              colors: AppColors.getBackgroundGradient(_isDarkMode),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScrollIndicator() {
    return AnimatedBuilder(
      animation: _scrollIndicatorAnimation,
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _showScrollIndicator ? 1.0 : 0.0,
          child: Transform.translate(
            offset: Offset(0, _scrollIndicatorAnimation.value * 10),
            child: ScrollIndicator(isDarkMode: _isDarkMode),
          ),
        );
      },
    );
  }

  Widget _buildContactFormModal() {
    return AnimatedBuilder(
      animation: _contactFormAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _contactFormAnimation.value,
          child: Opacity(
            opacity: _contactFormAnimation.value,
            child: ContactFormModal(
              isDarkMode: _isDarkMode,
              nameController: _nameController,
              emailController: _emailController,
              messageController: _messageController,
              onClose: _toggleContactForm,
              onSend: _sendEmail,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeTransitionAnimation,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            brightness: _isDarkMode ? Brightness.dark : Brightness.light,
            primaryColor: _primaryColor,
          ),
          child: Scaffold(
            backgroundColor: _backgroundColor,
            body: Stack(
              children: [
                // Animated background gradient
                _buildAnimatedBackground(),

                // Theme transition overlay
                if (_themeTransitionController.isAnimating)
                  Container(
                    color: Colors.black.withOpacity(
                      _themeTransitionAnimation.value * 0.3,
                    ),
                  ),

                // Main content with fade transition
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _themeTransitionController.isAnimating ? 0.7 : 1.0,
                  child: SingleChildScrollView(
                    controller: _pageScrollController,
                    child: Column(
                      children: [
                        // HERO SECTION WITH THEME TOGGLE INTEGRATION
                        HeroScreen(
                          scrollToSection: _scrollToSection,
                          toggleContactForm: () {
                            setState(() {
                              var showContactModal = true;
                            });
                          },
                        ),

                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: ScrollIndicator(isDarkMode: _isDarkMode),
                        ),
                        AboutScreen(),

                        SkillsScreen(),
                        ProjectsScreen(),
                        ContactScreen(),
                      ],
                    ),
                  ),
                ),

                // Animated navigation bar
              ],
            ),
          ),
        );
      },
    );
  }
}
