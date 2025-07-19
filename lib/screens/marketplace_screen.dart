import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marketplace',
          style: TextStyle(fontSize: responsive.appBarTitleSize),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: responsive.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.store,
                size: responsive.mainIconSize,
                color: const Color(0xFF1976D2),
              ),
              SizedBox(height: responsive.mainSpacing),
              Text(
                'Marketplace',
                style: TextStyle(
                  fontSize: responsive.titleSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.mainSpacing * 0.5),
              Text(
                'Browse compute services and providers',
                style: TextStyle(
                  fontSize: responsive.subtitleSize,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.screenNavbarSpace),
            ],
          ),
        ),
      ),
    );
  }
}
