import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'dashboard_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gpu.png'),
            fit: BoxFit.cover, // This ensures the image covers the full screen
          ),
        ),
        child: Container(
          // Add a dark overlay for better text readability
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: responsive.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top section with main brand name and app icon
                  SizedBox(height: responsive.mainSpacing * 0.2),
                  
                  // Top row with app icon and Lambda brand name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App icon from assets (on the left)
                      Container(
                        width: responsive.navbarIconSize * 2.25,
                        height: responsive.navbarIconSize * 2.25,
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Made transparent
                          borderRadius: BorderRadius.circular(responsive.navbarIconSize * 1.0), // Adjusted for larger size
                        ),
                        child: Image.asset(
                          'assets/icons/icon-transparent-invert.png',
                          width: responsive.navbarIconSize * 2,
                          height: responsive.navbarIconSize * 2,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: responsive.mainSpacing * 0.6),
                      // Lambda brand text (bigger size, no !)
                      Text(
                        'Lambda',
                        style: TextStyle(
                          fontSize: responsive.titleSize * 1.1,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Manrope',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: responsive.mainSpacing * 1.5),
                  
                  // Social media icons container (left side)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.mainSpacing * 0.2,
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(responsive.mainSpacing),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Gmail action
                          },
                          icon: const Icon(
                            Icons.mail,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(responsive.mainSpacing * 0.2),
                        ),
                        IconButton(
                          onPressed: () {
                            // Facebook action
                          },
                          icon: const Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(responsive.mainSpacing * 0.2),
                        ),
                        IconButton(
                          onPressed: () {
                            // Discord action
                          },
                          icon: const Icon(
                            Icons.forum,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(responsive.mainSpacing * 0.2),
                        ),
                        IconButton(
                          onPressed: () {
                            // Twitter action
                          },
                          icon: const Icon(
                            Icons.alternate_email,
                            color: Colors.white,
                            size: 20,
                          ),
                          padding: EdgeInsets.all(responsive.mainSpacing * 0.2),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DECENTRALIZED\nCOMPUTE.\nFOR CREATORS &\nINNOVATORS.\nON DEMAND.',
                        style: TextStyle(
                          fontSize: responsive.titleSize * 1.4,
                          fontWeight: FontWeight.w900, // Maximum boldness
                          fontFamily: 'Manrope',
                          color: Colors.white,
                          height: 1.1,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: responsive.mainSpacing),
                      
                      Text(
                        'Access distributed GPU power for AI training,\n3D rendering, and compute-intensive\nworkloads. Professional-grade infrastructure at a\nfraction of the cost',
                        style: TextStyle(
                          fontSize: responsive.subtitleSize,
                          fontFamily: 'Manrope',
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: responsive.mainSpacing * 1.5),
                      
                      // Continue button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to dashboard screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.mainSpacing * 0.6,
                              horizontal: responsive.mainSpacing * 1.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: responsive.subtitleSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: responsive.mainSpacing * 0.3),
                              Icon(
                                Icons.arrow_forward,
                                size: responsive.subtitleSize,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: responsive.mainSpacing * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
