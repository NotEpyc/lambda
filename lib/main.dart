import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/compute_controller.dart';
import 'screens/landing_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, 
    statusBarIconBrightness: Brightness.dark,
  ));
  
  runApp(const LambdaApp());
}

class LambdaApp extends StatelessWidget {
  const LambdaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ComputeController()),
      ],
      child: MaterialApp(
        title: 'Lambda',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LandingScreen(),
      ),
    );
  }
}
