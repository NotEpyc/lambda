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
          // Always show navbar in dashboard screen
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
  bool _isOverviewLoaded = false;

  final List<String> _sections = ['OVERVIEW', 'AS RENTER', 'AS PROVIDER'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // Animation controller for stats cards
    _statsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000), // Made much slower (was 1200ms)
      vsync: this,
    );
    
    _statsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _statsAnimationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    // Start animation after a delay when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 600), () { // Increased delay
        if (mounted && _selectedSection == 0) {
          setState(() {
            _isOverviewLoaded = true;
          });
          _statsAnimationController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _statsAnimationController.dispose();
    super.dispose();
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
      
      // Restart animation when returning to overview
      if (index == 0) {
        _statsAnimationController.reset();
        Future.delayed(const Duration(milliseconds: 700), () { // Increased delay
          if (mounted && _selectedSection == 0) {
            _statsAnimationController.forward();
          }
        });
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedSection = index;
    });
    
    // Restart animation when swiping to overview
    if (index == 0) {
      _statsAnimationController.reset();
      Future.delayed(const Duration(milliseconds: 500), () { // Increased delay
        if (mounted && _selectedSection == 0) {
          _statsAnimationController.forward();
        }
      });
    }
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
              // Top section with Dashboard text
              SizedBox(height: responsive.mainSpacing * 0.2),
              
              // Dashboard text (same style as Lambda in landing screen)
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: responsive.titleSize * 1.1,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Manrope',
                  color: Colors.black, // Black color instead of white
                ),
              ),
              
              SizedBox(height: responsive.mainSpacing * 0.8),
              
              // Tabbed section
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
              
              // Content area with swipeable pages
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
    return Container(
      padding: EdgeInsets.only(top: responsive.mainSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards grid
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.325,
            child: GridView.count(
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
          
          // Recent Activity Section
          SizedBox(height: responsive.mainSpacing * 0.01), // Minimal spacing - reduced from 0.05
          
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
          
          // Recent Activity Table
          Container(
            height: MediaQuery.of(context).size.height * 0.22, // Reduced from 0.25 to decrease bottom gap
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(responsive.mainSpacing * 0.4),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: EdgeInsets.all(responsive.mainSpacing * 0.6),
                  decoration: BoxDecoration(
                    color: Colors.white, // Changed from Colors.grey.shade50 to white
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(responsive.mainSpacing * 0.4),
                      topRight: Radius.circular(responsive.mainSpacing * 0.4),
                    ),
                  ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2, // Reduced from 3 to decrease gap with STATUS
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
                          flex: 1, // Keep same to maintain gap with RUNTIME
                          child: Text(
                            'STATUS',
                            style: TextStyle(
                              fontSize: responsive.subtitleSize * 0.7,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'RUNTIME',
                            textAlign: TextAlign.right, // Align to right
                            style: TextStyle(
                              fontSize: responsive.subtitleSize * 0.7,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'EARNINGS',
                            textAlign: TextAlign.right, // Align to right
                            style: TextStyle(
                              fontSize: responsive.subtitleSize * 0.65, // Reduced from 0.7 to prevent wrapping
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Table Rows
                  Expanded(
                    child: Column(
                      children: [
                        _buildActivityRow(
                          jobName: 'AI Model Training',
                          status: 'Running',
                          statusColor: Colors.green,
                          runtime: '2h 34m',
                          earnings: '\$12.50',
                          responsive: responsive,
                        ),
                        _buildActivityRow(
                          jobName: 'Video Rendering',
                          status: 'Completed',
                          statusColor: Colors.blue,
                          runtime: '45m',
                          earnings: '\$8.75',
                          responsive: responsive,
                        ),
                        _buildActivityRow(
                          jobName: 'Cryptocurrency Mining',
                          status: 'Queued',
                          statusColor: Colors.orange,
                          runtime: '-',
                          earnings: '-',
                          responsive: responsive,
                        ),
                        _buildActivityRow(
                          jobName: '3D Model Processing',
                          status: 'Completed',
                          statusColor: Colors.blue,
                          runtime: '1h 23m',
                          earnings: '\$15.25',
                          responsive: responsive,
                          isLast: true, // Add flag for last row
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

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
        
        // Calculate different phases with overlap
        final layoutPhase = ((animation - 0.3) * 1.43).clamp(0.0, 1.0); // 0.3 to 1.0
        final valuePhase = ((animation - 0.5) * 2.0).clamp(0.0, 1.0); // 0.5 to 1.0
        
        // Calculate positions for smooth transition
        final iconSize = responsive.mainIconSize * (0.6 - 0.1 * layoutPhase); // 0.6 to 0.5
        
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
              // Centered icon and text that animate to corners
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon - starts centered, moves to top-left
                    Transform.translate(
                      offset: Offset(
                        layoutPhase * (-responsive.mainSpacing * 2.0), // Reduced movement
                        layoutPhase * (-responsive.mainSpacing * 0.1), // Further reduced upward movement
                      ),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: isHighlighted ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                    
                    SizedBox(height: responsive.mainSpacing * 0.3),
                    
                    // Text - starts centered below icon, moves to bottom-left
                    Transform.translate(
                      offset: Offset(
                        layoutPhase * (-responsive.mainSpacing * 2.0), // Reduced movement
                        layoutPhase * (responsive.mainSpacing * 0.1), // Further reduced downward movement
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
              
              // Value positioned at top-right (slides in from right)
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

  Widget _buildRenterContent() {
    final responsive = context.responsive;
    return Container(
      padding: EdgeInsets.only(top: responsive.mainSpacing),
      child: const Center(
        child: Text(
          'As Renter Content',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Manrope',
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildProviderContent() {
    final responsive = context.responsive;
    return Container(
      padding: EdgeInsets.only(top: responsive.mainSpacing),
      child: const Center(
        child: Text(
          'As Provider Content',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Manrope',
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityRow({
    required String jobName,
    required String status,
    required Color statusColor,
    required String runtime,
    required String earnings,
    required Responsive responsive,
    bool isLast = false, // Add optional parameter for last row
  }) {
    return Container(
      padding: EdgeInsets.all(responsive.mainSpacing * 0.6),
      decoration: BoxDecoration(
        border: isLast ? null : Border( // Remove border for last row
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2, // Reduced from 3 to match header
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
            flex: 1, // Keep same to match header
            child: Row(
              children: [
                Container(
                  width: 6, // Reduced from 8
                  height: 6, // Reduced from 8
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: responsive.mainSpacing * 0.2), // Reduced spacing
                Flexible( // Added Flexible to prevent overflow
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: responsive.subtitleSize * 0.7, // Reduced font size
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Manrope',
                      color: statusColor,
                    ),
                    overflow: TextOverflow.ellipsis, // Added overflow handling
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              runtime,
              textAlign: TextAlign.right, // Align to right
              style: TextStyle(
                fontSize: responsive.subtitleSize * 0.75,
                fontWeight: FontWeight.w500,
                fontFamily: 'Manrope',
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              earnings,
              textAlign: TextAlign.right, // Align to left within earnings column
              style: TextStyle(
                fontSize: responsive.subtitleSize * 0.7, // Reduced from 0.75 to fit better
                fontWeight: FontWeight.w600,
                fontFamily: 'Manrope',
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis, // Add overflow handling
            ),
          ),
        ],
      ),
    );
  }
}
