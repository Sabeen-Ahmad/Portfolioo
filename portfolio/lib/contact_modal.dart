import 'package:flutter/material.dart';
import 'package:portfolio/app_colors.dart'; // Adjust the path if necessary

class ContactFormModal extends StatefulWidget {
  final bool isDarkMode;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final VoidCallback onClose;
  final VoidCallback onSend;

  const ContactFormModal({
    Key? key,
    required this.isDarkMode,
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.onClose,
    required this.onSend,
  }) : super(key: key);

  @override
  _ContactFormModalState createState() => _ContactFormModalState();
}

class _ContactFormModalState extends State<ContactFormModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _modalController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _modalController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modalController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modalController,
      curve: Curves.easeOut,
    ));

    _modalController.forward();
  }

  @override
  void dispose() {
    _modalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.buttonDark;
    final backgroundColor =  AppColors.backgroundLight;
    final cardColor =  AppColors.cardLight;
    final textColor = AppColors.textLight;
    final subtextColor = AppColors.subtextLight;

    return AnimatedBuilder(
      animation: _modalController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 500,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Contact with me to sizzle your project',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: textColor),
                            onPressed: widget.onClose,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Feel free to contact me if having any questions. I\'m available for new projects or just for chatting.',
                        style: TextStyle(
                          color: subtextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: widget.nameController,
                        decoration: InputDecoration(
                          hintText: 'Your Full Name',
                          hintStyle: TextStyle(color: subtextColor),
                          filled: true,
                          fillColor: backgroundColor.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                        ),
                        style: TextStyle(color: textColor),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: widget.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Your Email Address (we\'ll reply to this)',
                          hintStyle: TextStyle(color: subtextColor),
                          filled: true,
                          fillColor: backgroundColor.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                        ),
                        style: TextStyle(color: textColor),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: widget.messageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Describe your project requirements...',
                          hintStyle: TextStyle(color: subtextColor),
                          filled: true,
                          fillColor: backgroundColor.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: Icon(Icons.message_outlined, color: primaryColor),
                          ),
                        ),
                        style: TextStyle(color: textColor),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onSend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}