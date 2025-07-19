import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
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
                Icons.person,
                size: responsive.mainIconSize,
                color: const Color(0xFF1976D2),
              ),
              SizedBox(height: responsive.mainSpacing),
              Text(
                'Account',
                style: TextStyle(
                  fontSize: responsive.titleSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsive.mainSpacing * 0.5),
              Text(
                'Manage your profile and settings',
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
