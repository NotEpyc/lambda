import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the package
import '../utils/responsive.dart';
import '../utils/app_theme.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _expansionController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _expansionAnimation;

  bool _areCardsExpanded = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _expansionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _expansionAnimation =
        CurvedAnimation(parent: _expansionController, curve: Curves.easeInOut);

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _expansionController.dispose();
    super.dispose();
  }

  void _toggleCardExpansion() {
    setState(() {
      _areCardsExpanded = !_areCardsExpanded;
      if (_areCardsExpanded) {
        _expansionController.forward();
      } else {
        _expansionController.reverse();
      }
    });
  }
  
  // ✅ NEW: Method to launch the URL
  void _launchURL() async {
    final Uri url = Uri.parse('https://lambda101.vercel.app/provider');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Show an error message if the URL can't be launched
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.mainSpacing * 0.5,
            vertical: responsive.screenPadding.vertical,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: responsive.mainSpacing * 2),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'BECOME A GPU PROVIDER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: responsive.titleSize * 1.2,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: responsive.mainSpacing),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: responsive.mainSpacing),
                        child: Text(
                          'Join thousands earning cryptocurrency by sharing their GPU compute power.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: responsive.subtitleSize,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.mainSpacing * 3),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _slideController,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.monetization_on_outlined,
                              title: 'PASSIVE INCOME',
                              description:
                                  'Earn money while your GPU is idle. Average providers make \$50 - 200/month.',
                              isExpanded: _areCardsExpanded,
                              onTap: _toggleCardExpansion,
                              expansionAnimation: _expansionAnimation,
                              responsive: responsive,
                            ),
                          ),
                          SizedBox(width: responsive.mainSpacing * 1.0),
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.shield_outlined,
                              title: 'SECURE & SAFE',
                              description:
                                  'Sandboxed execution environment protects your system from malicious code.',
                              isExpanded: _areCardsExpanded,
                              onTap: _toggleCardExpansion,
                              expansionAnimation: _expansionAnimation,
                              responsive: responsive,
                            ),
                          ),
                          SizedBox(width: responsive.mainSpacing * 1.0),
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.bolt_outlined,
                              title: 'INSTANT PAYMENTS',
                              description:
                                  'Get paid automatically in cryptocurrency after each completed job.',
                              isExpanded: _areCardsExpanded,
                              onTap: _toggleCardExpansion,
                              expansionAnimation: _expansionAnimation,
                              responsive: responsive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.mainSpacing * 3),
                // ✅ NEW: PROVIDE Button
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _slideController,
                    child: ElevatedButton(
                      onPressed: _launchURL,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background, // Makes text and icon white
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.mainSpacing * 1.5,
                          vertical: responsive.mainSpacing * 0.75, // Reduced height
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PROVIDE',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.titleSize,
                              color: Colors.black
                            ),
                          ),
                          SizedBox(width: responsive.mainSpacing),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: (responsive.subtitleSize + responsive.subtitleSize * 0.5),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.screenNavbarSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isExpanded;
  final VoidCallback onTap;
  final Animation<double> expansionAnimation;
  final Responsive responsive;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isExpanded,
    required this.onTap,
    required this.expansionAnimation,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.mainSpacing * 0.5,
          vertical: responsive.mainSpacing,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded ? AppColors.onTap : AppColors.primary,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: responsive.mainIconSize * 0.8,
              color: Colors.black87,
            ),
            SizedBox(height: responsive.mainSpacing * 0.8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: responsive.subtitleSize * 0.85,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: expansionAnimation,
              child: Padding(
                padding: EdgeInsets.only(top: responsive.mainSpacing * 0.5),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: responsive.subtitleSize * 0.8,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}