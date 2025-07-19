import 'package:flutter/material.dart';

import '../widgets/floating_bottom_navbar.dart';

import '../utils/responsive.dart';

import 'marketplace_screen.dart';

import 'account_screen.dart';

import 'providers_screen.dart';


class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});


  @override

  State<DashboardScreen> createState() => _DashboardScreenState();

}


class _DashboardScreenState extends State<DashboardScreen> {

  int _currentIndex = 0;


  final List<Widget> _screens = [

    const HomePage(),

    const ProvidersScreen(),

    const MarketplaceScreen(),

    const AccountScreen(),

  ];


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [

          _screens[_currentIndex],

          FloatingBottomNavbar(

            currentIndex: _currentIndex,

            onTap: (index) {

              setState(() {

                _currentIndex = index;

              });

            },

          ),

        ],

      ),

    );

  }

}


class HomePage extends StatefulWidget {

  const HomePage({super.key});


  @override

  State<HomePage> createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  int _selectedSection = 0;

  late PageController _pageController;

  late AnimationController _statsAnimationController;

  late Animation<double> _statsAnimation;

  late AnimationController _activityAnimationController;

  late Animation<double> _activityAnimation;


  final List<String> _sections = ['OVERVIEW', 'AS RENTER', 'AS PROVIDER'];


  @override

  void initState() {

    super.initState();

    _pageController = PageController(initialPage: 0);

   

    _statsAnimationController = AnimationController(

      duration: const Duration(milliseconds: 1200),

      vsync: this,

    );

   

    _statsAnimation = CurvedAnimation(

      parent: _statsAnimationController,

      curve: Curves.easeOutBack,

    );


    _activityAnimationController = AnimationController(

      duration: const Duration(milliseconds: 600),

      vsync: this,

    );


    _activityAnimation = CurvedAnimation(

      parent: _activityAnimationController,

      curve: Curves.easeInOut,

    );

   

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _startAnimations();

    });

  }


  @override

  void dispose() {

    _pageController.dispose();

    _statsAnimationController.dispose();

    _activityAnimationController.dispose();

    super.dispose();

  }

 

  void _startAnimations() {

    if (mounted) {

      // Reveal animation for all three pages now

      if (_selectedSection >= 0 && _selectedSection <= 2) {

        Future.delayed(const Duration(milliseconds: 400), () {

          if (mounted) _activityAnimationController.forward();

        });

      }

      // Stats cards animation for Overview page only

      if (_selectedSection == 0) {

        Future.delayed(const Duration(milliseconds: 400), () {

          if (mounted) _statsAnimationController.forward();

        });

      }

    }

  }

 

  void _resetAndRestartAnimations() {

    _statsAnimationController.reset();

    _activityAnimationController.reset();

    _startAnimations();

  }


  void _onSectionTap(int index) {

    if (_selectedSection != index) {

      setState(() {

        _selectedSection = index;

      });

      _pageController.animateToPage(

        index,

        duration: const Duration(milliseconds: 300),

        curve: Curves.easeInOut,

      );

     

      _resetAndRestartAnimations();

    }

  }


  void _onPageChanged(int index) {

    setState(() {

      _selectedSection = index;

    });

    _resetAndRestartAnimations();

  }

 

  @override

  Widget build(BuildContext context) {

    final responsive = context.responsive;

   

    return Scaffold(

      body: SafeArea(

        child: Padding(

          padding: responsive.screenPadding,

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(height: responsive.mainSpacing * 0.2),

              Text(

                'Dashboard',

                style: TextStyle(

                  fontSize: responsive.titleSize * 1.1,

                  fontWeight: FontWeight.w700,

                  fontFamily: 'Manrope',

                  color: Colors.black,

                ),

              ),

              SizedBox(height: responsive.mainSpacing * 0.8),

             

              Container(

                decoration: BoxDecoration(

                  border: Border(

                    bottom: BorderSide(

                      color: Colors.grey.shade300,

                      width: 1,

                    ),

                  ),

                ),

                child: Row(

                  children: _sections.asMap().entries.map((entry) {

                    int index = entry.key;

                    String section = entry.value;

                    bool isSelected = _selectedSection == index;

                   

                    return Expanded(

                      child: GestureDetector(

                        onTap: () => _onSectionTap(index),

                        child: Container(

                          padding: EdgeInsets.symmetric(

                            vertical: responsive.mainSpacing * 0.4,

                          ),

                          decoration: BoxDecoration(

                            border: Border(

                              bottom: BorderSide(

                                color: isSelected

                                    ? const Color(0xFFFFD404)

                                    : Colors.transparent,

                                width: 2,

                              ),

                            ),

                          ),

                          child: Text(

                            section,

                            textAlign: TextAlign.center,

                            style: TextStyle(

                              fontSize: responsive.subtitleSize * 0.9,

                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,

                              fontFamily: 'Manrope',

                              color: isSelected

                                ? Colors.black

                                : Colors.grey.shade600,

                            ),

                          ),

                        ),

                      ),

                    );

                  }).toList(),

                ),

              ),

             

              Expanded(

                child: PageView(

                  controller: _pageController,

                  onPageChanged: _onPageChanged,

                  children: [

                    _buildOverviewContent(),

                    _buildRenterContent(),

                    _buildProviderContent(),

                  ],

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }


  Widget _buildOverviewContent() {

    final responsive = context.responsive;

    return SingleChildScrollView(

      physics: const BouncingScrollPhysics(),

      child: Padding(

        padding: EdgeInsets.only(top: responsive.mainSpacing),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            SizedBox(

              height: MediaQuery.of(context).size.height * 0.325,

              child: GridView.count(

                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,

                crossAxisSpacing: responsive.mainSpacing * 0.5,

                mainAxisSpacing: responsive.mainSpacing * 0.5,

                childAspectRatio: 2.2,

                children: [

                  _buildStatsCard(

                    icon: Icons.attach_money,

                    title: 'TOTAL EARNINGS',

                    value: '\$2847.50',

                    isHighlighted: true,

                    responsive: responsive,

                  ),

                  _buildStatsCard(

                    icon: Icons.show_chart,

                    title: 'ACTIVE JOBS',

                    value: '3',

                    isHighlighted: false,

                    responsive: responsive,

                  ),

                  _buildStatsCard(

                    icon: Icons.dns,

                    title: 'UPTIME',

                    value: '99.2%',

                    isHighlighted: false,

                    responsive: responsive,

                  ),

                  _buildStatsCard(

                    icon: Icons.bar_chart,

                    title: 'TOTAL JOBS',

                    value: '127',

                    isHighlighted: false,

                    responsive: responsive,

                  ),

                  _buildStatsCard(

                    icon: Icons.memory,

                    title: 'GPU UTILIZATION',

                    value: '87%',

                    isHighlighted: false,

                    responsive: responsive,

                  ),

                  _buildStatsCard(

                    icon: Icons.trending_up,

                    title: 'AVG HOURLY RATE',

                    value: '\$1.25',

                    isHighlighted: false,

                    responsive: responsive,

                  ),

                ],

              ),

            ),

           

            SizedBox(height: responsive.mainSpacing * 0.01),

           

            Text(

              'RECENT ACTIVITY',

              style: TextStyle(

                fontSize: responsive.subtitleSize * 0.9,

                fontWeight: FontWeight.w600,

                fontFamily: 'Manrope',

                color: Colors.black,

              ),

            ),

           

            SizedBox(height: responsive.mainSpacing * 0.8),

           

            Container(

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(responsive.mainSpacing * 0.4),

                border: Border.all(

                  color: Colors.grey.shade200,

                  width: 1,

                ),

                color: Colors.white,

              ),

              child: Column(

                children: [
                  // Header Container for Recent Activity
                  Container(
                    padding: EdgeInsets.all(responsive.mainSpacing * 0.6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4, 
                          child: Text(
                            'JOB NAME',
                            style: TextStyle(
                              fontSize: responsive.subtitleSize * 0.7,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'STATUS',
                            textAlign: TextAlign.center, // ✅ CENTERED
                            style: TextStyle(
                              fontSize: responsive.subtitleSize * 0.7,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'RUNTIME',
                            textAlign: TextAlign.center, // ✅ CENTERED
                            style: TextStyle(
                              fontSize: responsive.subtitleSize * 0.7,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'EARNINGS',
                            textAlign: TextAlign.center, // ✅ CENTERED
                            style: TextStyle(
                              fontSize: responsive.subtitleSize * 0.65,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                 

                  SizeTransition(

                    sizeFactor: _activityAnimation,

                    axis: Axis.vertical,

                    axisAlignment: -1.0,

                    child: Column(

                      children: [

                        _buildActivityRow(

                          jobName: 'AI Model Training',

                          status: 'Running',

                          statusColor: Colors.green,

                          statusIcon: Icons.play_circle,

                          runtime: '2h 34m',

                          earnings: '\$12.50',

                          responsive: responsive,

                        ),

                        _buildActivityRow(

                          jobName: 'Video Rendering',

                          status: 'Completed',

                          statusColor: Colors.blue,

                          statusIcon: Icons.check_circle,

                          runtime: '45m',

                          earnings: '\$8.75',

                          responsive: responsive,

                        ),

                        _buildActivityRow(

                          jobName: 'Cryptocurrency Mining',

                          status: 'Queued',

                          statusColor: Colors.grey.shade600,

                          statusIcon: Icons.pause_circle,

                          runtime: '-',

                          earnings: '-',

                          responsive: responsive,

                        ),

                        _buildActivityRow(

                          jobName: '3D Model Processing',

                          status: 'Completed',

                          statusColor: Colors.blue,

                          statusIcon: Icons.check_circle,

                          runtime: '1h 23m',

                          earnings: '\$15.25',

                          responsive: responsive,

                          isLast: true,

                        ),

                      ],

                    ),

                  ),

                ],

              ),

            ),

             SizedBox(height: responsive.mainSpacing * 5),

          ],

        ),

      ),

    );

  }


  Widget _buildRenterContent() {

    final responsive = context.responsive;

    return SingleChildScrollView(

      physics: const BouncingScrollPhysics(),

      child: Padding(

        padding: EdgeInsets.only(top: responsive.mainSpacing),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(

              'YOUR JOBS',

              style: TextStyle(

                fontSize: responsive.subtitleSize,

                fontWeight: FontWeight.w600,

                fontFamily: 'Manrope',

                color: Colors.black,

              ),

            ),

            SizedBox(height: responsive.mainSpacing * 0.8),

            Container(

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(responsive.mainSpacing * 0.4),

                border: Border.all(color: Colors.grey.shade200, width: 1),

                color: Colors.white,

              ),

              child: Column(

                children: [

                  // ✅ REVISED: Header with new alignment and spacing

                  Padding(

                    padding: EdgeInsets.all(responsive.mainSpacing * 0.8),

                    child: Row(

                      children: [

                        Expanded(flex: 4, child: _buildHeaderCell('JOB NAME', responsive)),

                        Expanded(flex: 3, child: _buildHeaderCell('STATUS', responsive, align: TextAlign.center)),

                        Expanded(flex: 4, child: _buildHeaderCell('PROGRESS', responsive)),

                        Expanded(flex: 3, child: _buildHeaderCell('RUNTIME', responsive, align: TextAlign.center)),

                        Expanded(flex: 2, child: _buildHeaderCell('COST', responsive, align: TextAlign.center)),

                        Expanded(flex: 2, child: _buildHeaderCell('GPU', responsive, align: TextAlign.right)),

                      ],

                    ),

                  ),

                 

                  SizeTransition(

                    sizeFactor: _activityAnimation,

                    axis: Axis.vertical,

                    axisAlignment: -1.0,

                    child: Column(

                      children: [

                        _buildJobRow(

                          jobName: 'AI Model Training',

                          statusIcon: Icons.play_circle_outline,

                          statusColor: Colors.green,

                          progress: 0.8,

                          runtime: '2h 34m',

                          cost: '\$12.50',

                          gpu: 'RTX 4090',

                          responsive: responsive,

                        ),

                        _buildJobRow(

                          jobName: 'Video Rendering',

                          statusIcon: Icons.check_circle_outline,

                          statusColor: Colors.blue,

                          progress: 1.0,

                          runtime: '45m',

                          cost: '\$8.75',

                          gpu: 'RTX 4080',

                          responsive: responsive,

                        ),

                         _buildJobRow(

                          jobName: 'Cryptocurrency Mining',

                          statusIcon: Icons.pause_circle_outline,

                          statusColor: Colors.grey.shade600,

                          progress: 0.0,

                          runtime: '-',

                          cost: '\$0.00',

                          gpu: 'RTX 4070',

                          responsive: responsive,

                        ),

                        _buildJobRow(

                          jobName: '3D Model Processing',

                          statusIcon: Icons.check_circle_outline,

                          statusColor: Colors.blue,

                          progress: 1.0,

                          runtime: '1h 23m',

                          cost: '\$15.25',

                          gpu: 'RTX 4090',

                          responsive: responsive,

                          isLast: true,

                        ),

                      ],

                    ),

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }


  // ✅ NEW: `_buildProviderContent` builds the "AS PROVIDER" page

  Widget _buildProviderContent() {

    final responsive = context.responsive;

    return SingleChildScrollView(

      physics: const BouncingScrollPhysics(),

      child: Padding(

        padding: EdgeInsets.only(top: responsive.mainSpacing),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(

              'YOUR GPU NODES',

              style: TextStyle(

                fontSize: responsive.subtitleSize,

                fontWeight: FontWeight.w600,

                fontFamily: 'Manrope',

                color: Colors.black,

              ),

            ),

            SizedBox(height: responsive.mainSpacing * 0.8),

            Container(

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(responsive.mainSpacing * 0.4),

                border: Border.all(color: Colors.grey.shade200, width: 1),

                color: Colors.white,

              ),

              child: Column(

                children: [

                  // Header

                  Padding(

                    padding: EdgeInsets.all(responsive.mainSpacing * 0.8),

                    child: Row(

                      children: [

                        Expanded(flex: 3, child: _buildHeaderCell('GPU MODEL', responsive)),
                        Expanded(flex: 3, child: _buildHeaderCell('STATUS', responsive, align: TextAlign.center)),

                        Expanded(flex: 4, child: _buildHeaderCell('UTILIZATION', responsive)),

                        Expanded(flex: 2, child: _buildHeaderCell('EARNINGS', responsive, align: TextAlign.center)),

                        Expanded(flex: 2, child: _buildHeaderCell('UPTIME', responsive, align: TextAlign.right)),

                      ],

                    ),

                  ),

                  // Animated Rows

                  SizeTransition(

                    sizeFactor: _activityAnimation,

                    axis: Axis.vertical,

                    axisAlignment: -1.0,

                    child: Column(

                      children: [

                        _buildGpuNodeRow(

                          model: 'RTX 4090',

                          memory: '24GB',

                          statusIcon: Icons.play_arrow,

                          statusColor: Colors.green,

                          utilization: 0.87,

                          earnings: '\$45.30',

                          uptime: '12d 5h',

                          responsive: responsive,

                        ),

                        _buildGpuNodeRow(

                          model: 'RTX 4080',

                          memory: '16GB',

                          statusIcon: Icons.pause,

                          statusColor: Colors.grey.shade600,

                          utilization: 0.0,

                          earnings: '\$23.80',

                          uptime: '8d 12h',

                          responsive: responsive,

                          isLast: true,

                        ),

                      ],

                    ),

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );

  }

 

  // --- Helper and build methods ---


  Widget _buildStatsCard({

    required IconData icon,

    required String title,

    required String value,

    required bool isHighlighted,

    required Responsive responsive,

  }) {

    return AnimatedBuilder(

      animation: _statsAnimation,

      builder: (context, child) {

        final animation = _statsAnimation.value;

        final layoutPhase = ((animation - 0.3) * 1.43).clamp(0.0, 1.0);

        final valuePhase = ((animation - 0.5) * 2.0).clamp(0.0, 1.0);

        final iconSize = responsive.mainIconSize * (0.6 - 0.1 * layoutPhase);

       

        return Container(

          decoration: BoxDecoration(

            color: isHighlighted ? const Color(0xFFFFD404) : Colors.white,

            borderRadius: BorderRadius.circular(responsive.mainSpacing * 0.4),

            border: Border.all(

              color: isHighlighted ? Colors.grey.shade200 : const Color(0xFFFFD404),

              width: 1,

            ),

          ),

          padding: EdgeInsets.all(responsive.mainSpacing * 0.6),

          child: Stack(

            children: [

              Center(

                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    Transform.translate(

                      offset: Offset(

                        layoutPhase * (-responsive.mainSpacing * 2.0),

                        layoutPhase * (-responsive.mainSpacing * 0.1),

                      ),

                      child: Icon(

                        icon,

                        size: iconSize,

                        color: isHighlighted ? Colors.black : Colors.grey.shade600,

                      ),

                    ),

                   

                    SizedBox(height: responsive.mainSpacing * 0.3),

                   

                    Transform.translate(

                      offset: Offset(

                        layoutPhase * (-responsive.mainSpacing * 2.0),

                        layoutPhase * (responsive.mainSpacing * 0.1),

                      ),

                      child: Text(

                        title,

                        style: TextStyle(

                          fontSize: responsive.subtitleSize * 0.7,

                          fontWeight: FontWeight.w500,

                          fontFamily: 'Manrope',

                          color: isHighlighted ? Colors.black : Colors.grey.shade600,

                        ),

                        textAlign: TextAlign.center,

                      ),

                    ),

                  ],

                ),

              ),

             

              Positioned(

                top: responsive.mainSpacing * 0.2,

                right: responsive.mainSpacing * 0.4,

                child: Transform.translate(

                  offset: Offset((1 - valuePhase) * 50, 0),

                  child: Opacity(

                    opacity: valuePhase.clamp(0.0, 1.0),

                    child: Text(

                      value,

                      style: TextStyle(

                        fontSize: responsive.titleSize * 0.8,

                        fontWeight: FontWeight.w700,

                        fontFamily: 'Manrope',

                        color: isHighlighted ? Colors.black : Colors.black87,

                      ),

                      textAlign: TextAlign.right,

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


  Widget _buildActivityRow({

    required String jobName,

    required String status,

    required Color statusColor,

    required IconData statusIcon,

    required String runtime,

    required String earnings,

    required Responsive responsive,

    bool isLast = false,

  }) {

    return Container(

      padding: EdgeInsets.all(responsive.mainSpacing * 0.6),

      decoration: BoxDecoration(

        border: isLast ? null : Border(

          bottom: BorderSide(

            color: Colors.grey.shade100,

            width: 1,

          ),

        ),

      ),

      child: Row(

        children: [

          Expanded(

            flex: 4,

            child: Text(

              jobName,

              style: TextStyle(

                fontSize: responsive.subtitleSize * 0.75,

                fontWeight: FontWeight.w500,

                fontFamily: 'Manrope',

                color: Colors.black87,

              ),

            ),

          ),

          Expanded(

            flex: 3,

            child: Row(

              children: [

                Icon(

                  statusIcon,

                  color: statusColor,

                  size: 16,

                ),

                SizedBox(width: responsive.mainSpacing * 0.3),

                Flexible(

                  child: Text(

                    status,

                    style: TextStyle(

                      fontSize: responsive.subtitleSize * 0.7,

                      fontWeight: FontWeight.w500,

                      fontFamily: 'Manrope',

                      color: statusColor,

                    ),

                    overflow: TextOverflow.ellipsis,

                  ),

                ),

              ],

            ),

          ),

          Expanded(

            flex: 2,

            child: Text(

              runtime,

              textAlign: TextAlign.right,

              style: TextStyle(

                fontSize: responsive.subtitleSize * 0.75,

                fontWeight: FontWeight.w500,

                fontFamily: 'Manrope',

                color: Colors.grey.shade600,

              ),

            ),

          ),

          Expanded(

            flex: 2,

            child: Text(

              earnings,

              textAlign: TextAlign.right,

              style: TextStyle(

                fontSize: responsive.subtitleSize * 0.7,

                fontWeight: FontWeight.w600,

                fontFamily: 'Manrope',

                color: Colors.black87,

              ),

              overflow: TextOverflow.ellipsis,

            ),

          ),

        ],

      ),

    );

  }

 

  Widget _buildHeaderCell(String text, Responsive responsive, {TextAlign align = TextAlign.left}) {

    return Text(

      text,

      textAlign: align,

      style: TextStyle(

        fontSize: responsive.subtitleSize * 0.65,

        fontWeight: FontWeight.bold,

        fontFamily: 'Manrope',

        color: Colors.grey.shade600,

      ),

    );

  }


  Widget _buildJobRow({

    required String jobName,

    required IconData statusIcon,

    required Color statusColor,

    required double progress,

    required String runtime,

    required String cost,

    required String gpu,

    required Responsive responsive,

    bool isLast = false,

  }) {

    return Container(

      padding: EdgeInsets.symmetric(

        horizontal: responsive.mainSpacing * 0.8,

        vertical: responsive.mainSpacing,

      ),

      decoration: BoxDecoration(

        border: isLast ? null : Border(

          bottom: BorderSide(color: Colors.grey.shade200, width: 1),

        ),

      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          // Job Name

          Expanded(

            flex: 4,

            child: Text(

              jobName,

              style: TextStyle(

                fontWeight: FontWeight.bold,

                fontFamily: 'Manrope',

                fontSize: responsive.subtitleSize * 0.8,

              ),

            ),

          ),

          // Status

          Expanded(

            flex: 3,

            child: Icon(statusIcon, color: statusColor, size: 18),

          ),

          // Progress

          Expanded(

            flex: 5,

            // ✅ FIX: Added Padding to shorten the progress bar

            child: Padding(

              padding: EdgeInsets.only(right: responsive.mainSpacing),

              child: ClipRRect(

                borderRadius: BorderRadius.circular(10),

                child: LinearProgressIndicator(

                  value: progress,

                  backgroundColor: Colors.grey.shade300,

                  color: Colors.blue,

                  minHeight: 6,

                ),

              ),

            ),

          ),

          // Runtime

          Expanded(

            flex: 2,

            child: Text(

              runtime,

              textAlign: TextAlign.center,

              style: TextStyle(

                fontFamily: 'Manrope',

                fontSize: responsive.subtitleSize * 0.8,

              ),

            ),

          ),

          // Cost

          Expanded(

            flex: 2,

            child: Text(

              cost,

              textAlign: TextAlign.center,

              style: TextStyle(

                fontWeight: FontWeight.bold,

                fontFamily: 'Manrope',

                fontSize: responsive.subtitleSize * 0.8,

              ),

            ),

          ),

          // GPU

          Expanded(

            flex: 2,

            child: Text(

              gpu,

              textAlign: TextAlign.right,

              style: TextStyle(

                fontFamily: 'Manrope',

                fontSize: responsive.subtitleSize * 0.8,

              ),

            ),

          ),

        ],

      ),

    );

  }

 

  // ✅ NEW: Helper for "AS PROVIDER" data rows

  Widget _buildGpuNodeRow({

    required String model,

    required String memory,

    required IconData statusIcon,

    required Color statusColor,

    required double utilization,

    required String earnings,

    required String uptime,

    required Responsive responsive,

    bool isLast = false,

  }) {

     return Container(

      padding: EdgeInsets.symmetric(

        horizontal: responsive.mainSpacing * 0.8,

        vertical: responsive.mainSpacing,

      ),

      decoration: BoxDecoration(

        border: isLast ? null : Border(

          bottom: BorderSide(color: Colors.grey.shade200, width: 1),

        ),

      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          // GPU Model

          Expanded(

            flex: 3,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  model,

                  style: TextStyle(

                    fontWeight: FontWeight.bold,

                    fontFamily: 'Manrope',

                    fontSize: responsive.subtitleSize * 0.8,

                  ),

                ),

                Text(

                  memory,

                  style: TextStyle(

                    fontFamily: 'Manrope',

                    fontSize: responsive.subtitleSize * 0.7,

                    color: Colors.grey.shade600,

                  ),

                ),

              ],

            ),

          ),

          // Status

          Expanded(

            flex: 3,

            child: Icon(statusIcon, color: statusColor, size: 16),

          ),

          // Utilization

          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(utilization * 100).toInt()}%',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: responsive.subtitleSize * 0.7,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                // Add Padding here
                Padding(
                  padding: EdgeInsets.only(right: responsive.mainSpacing),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: utilization,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.green,
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Earnings

          Expanded(

            flex: 2,

            child: Text(

              earnings,

              textAlign: TextAlign.center,

              style: TextStyle(

                fontWeight: FontWeight.bold,

                fontFamily: 'Manrope',

                fontSize: responsive.subtitleSize * 0.8,

              ),

            ),

          ),

          // Uptime

          Expanded(

            flex: 2,

            child: Text(

              uptime,

              textAlign: TextAlign.right,

              style: TextStyle(

                fontFamily: 'Manrope',

                fontSize: responsive.subtitleSize * 0.8,

              ),

            ),

          ),

        ],

      ),

    );

  }

} 