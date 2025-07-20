import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../utils/responsive.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

// DATA MODEL FOR A GPU LISTING
class GpuListing {
  final String gpuName;
  final String gpuSpecs;
  final String providerName;
  final String location;
  final String region;
  final String reliability;
  final String uptime;
  final double price;

  GpuListing({
    required this.gpuName,
    required this.gpuSpecs,
    required this.providerName,
    required this.location,
    required this.region,
    required this.reliability,
    required this.uptime,
    required this.price,
  });
}

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with TickerProviderStateMixin {
  // --- State for Filters ---
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // ✅ ADD THIS
  String? _selectedGpuModel;
  String? _selectedRegion;
  SfRangeValues _priceRangeValues = const SfRangeValues(0.0, 3.0);
  bool _isFilterExpanded = false;

  // --- State for Data and Filtering ---
  late List<GpuListing> _filteredListings;
  final List<GpuListing> _allListings = [
    GpuListing(gpuName: 'NVIDIA RTX 4090', gpuSpecs: '24GB GDDR6X • 16,384 CUDA Cores', providerName: 'TechMiner', location: 'New York', region: 'North America', reliability: 'Excellent', uptime: '99.8% uptime', price: 0.85),
    GpuListing(gpuName: 'NVIDIA RTX 3090', gpuSpecs: '24GB GDDR6X • 10,496 CUDA Cores', providerName: 'EuroCompute', location: 'Frankfurt', region: 'Europe', reliability: 'High', uptime: '97.5% uptime', price: 0.65),
    GpuListing(gpuName: 'NVIDIA A100', gpuSpecs: '80GB HBM2e • 6,912 CUDA Cores', providerName: 'AsiaTech', location: 'Singapore', region: 'Asia Pacific', reliability: 'Enterprise', uptime: '99.9% uptime', price: 2.5),
    GpuListing(gpuName: 'NVIDIA RTX 4080', gpuSpecs: '16GB GDDR6X • 9,728 CUDA Cores', providerName: 'BritishGPU', location: 'London', region: 'Europe', reliability: 'High', uptime: '98.2% uptime', price: 0.75),
    GpuListing(gpuName: 'NVIDIA V100', gpuSpecs: '32GB HBM2 • 5,120 CUDA Cores', providerName: 'JapanCloud', location: 'Tokyo', region: 'Asia Pacific', reliability: 'Professional', uptime: '99.1% uptime', price: 1.2),
  ];

  // --- Animation Controllers ---
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _filteredListings = _allListings;
    _searchController.addListener(_filterListings);

    _searchFocusNode.addListener(() {
      // If the search bar has focus and the filter card is not already expanded, expand it.
      if (_searchFocusNode.hasFocus && !_isFilterExpanded) {
        setState(() {
          _isFilterExpanded = true;
        });
      }
    });

    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _slideController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterListings);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _filterListings() {
    List<GpuListing> listings = _allListings;

    final searchText = _searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      listings = listings.where((listing) {
        return listing.gpuName.toLowerCase().contains(searchText) ||
               listing.providerName.toLowerCase().contains(searchText);
      }).toList();
    }

    if (_selectedGpuModel != null && _selectedGpuModel != 'All Models') {
      listings = listings.where((listing) => listing.gpuName.contains(_selectedGpuModel!)).toList();
    }
    
    if (_selectedRegion != null && _selectedRegion != 'All Regions') {
      listings = listings.where((listing) => listing.region == _selectedRegion).toList();
    }

    listings = listings.where((listing) {
      return listing.price >= _priceRangeValues.start && listing.price <= _priceRangeValues.end;
    }).toList();

    setState(() {
      _filteredListings = listings;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: responsive.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: responsive.mainSpacing * 0.2),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'GPU Marketplace',
                  style: TextStyle(
                    fontSize: responsive.titleSize * 1.1,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Manrope',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: responsive.mainSpacing * 0.5),
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _slideController,
                  child: Card(
                    elevation: 0,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.white, width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                      horizontal: responsive.mainSpacing * 0.4, 
                      vertical: responsive.mainSpacing * 1.5,
                    ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Search GPUs or providers...',
                                    prefixIcon: Icon(Icons.search),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: AnimatedRotation(
                                  turns: _isFilterExpanded ? 0.5 : 0,
                                  duration:
                                      const Duration(milliseconds: 300),
                                  child:
                                      const Icon(Icons.keyboard_arrow_down),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFilterExpanded = !_isFilterExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topCenter,
                            child: _isFilterExpanded
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(height: 20),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'GPU MODEL',
                                                  style: TextStyle(
                                                    fontSize: responsive
                                                            .subtitleSize *
                                                        0.8,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color:
                                                        Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: responsive
                                                            .mainSpacing *
                                                        0.5),
                                                DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  decoration:
                                                      InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(12),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(12),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                  ),
                                                  value: _selectedGpuModel,
                                                  hint: const Text('All'),
                                                  items: <String>[
                                                    'All',
                                                    'RTX 4090',
                                                    'RTX 3090',
                                                    'A100',
                                                    'V100'
                                                  ].map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedGpuModel =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              width: responsive.mainSpacing),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'REGION',
                                                  style: TextStyle(
                                                    fontSize: responsive
                                                            .subtitleSize *
                                                        0.8,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color:
                                                        Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: responsive
                                                            .mainSpacing *
                                                        0.5),
                                                DropdownButtonFormField<
                                                    String>(
                                                  isExpanded: true,
                                                  decoration:
                                                      InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(12),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(12),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                  ),
                                                  value: _selectedRegion,
                                                  hint: const Text('All'),
                                                  items: <String>[
                                                    'All',
                                                    'North America',
                                                    'Europe',
                                                    'Asia Pacific'
                                                  ].map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedRegion =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              responsive.mainSpacing * 2),
                                      Text(
                                        'PRICE: \$${_priceRangeValues.start.toStringAsFixed(2)} - \$${_priceRangeValues.end.toStringAsFixed(2)} / HR',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade700,
                                          fontSize: responsive.subtitleSize *
                                              0.8,
                                        ),
                                      ),
                                      SfRangeSlider(
                                        min: 0.0,
                                        max: 3.0,
                                        values: _priceRangeValues,
                                        
                                        enableTooltip: false,

                                        showTicks: false,
                                        showLabels: false,
                                        thumbShape: _HollowThumbShape(),
                                        onChanged: (SfRangeValues newValues) {
                                          setState(() {
                                            _priceRangeValues = newValues;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsive.mainSpacing * 0.5),

              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredListings.length,
                  itemBuilder: (context, index) {
                    final listing = _filteredListings[index];
                    return _buildGpuListingItem(listing, responsive);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGpuListingItem(GpuListing listing, Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.mainSpacing),
      padding: EdgeInsets.symmetric(vertical: responsive.mainSpacing * 1.5, horizontal: responsive.mainSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.gpuName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: responsive.subtitleSize * 1.1)),
                SizedBox(height: 4),
                Text(listing.gpuSpecs, style: TextStyle(color: Colors.grey.shade600, fontSize: responsive.subtitleSize * 0.8)),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.providerName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: responsive.subtitleSize)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: responsive.subtitleSize * 0.9, color: Colors.grey.shade600),
                    SizedBox(width: 4),
                    Flexible(child: Text(listing.location, style: TextStyle(color: Colors.grey.shade600, fontSize: responsive.subtitleSize * 0.9), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(listing.reliability, style: TextStyle(fontWeight: FontWeight.w600, fontSize: responsive.subtitleSize)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: responsive.subtitleSize * 0.9, color: Colors.green),
                    SizedBox(width: 4),
                    // ✅ FIX: Wrapped the uptime Text with Flexible to prevent overflow
                    Flexible(
                      child: Text(
                        listing.uptime,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: responsive.subtitleSize * 0.9),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '\$${listing.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.titleSize * 0.8,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'per hour',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: responsive.subtitleSize * 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HollowThumbShape extends SfThumbShape {
  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox, required RenderBox? child, required SfSliderThemeData themeData,
      SfRangeValues? currentValues, dynamic currentValue, required Paint? paint, required Animation<double> enableAnimation,
      required TextDirection textDirection, required SfThumb? thumb}) {
    final Paint fillPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()..color = themeData.activeTrackColor!..style = PaintingStyle.stroke..strokeWidth = 2;
    context.canvas.drawCircle(center, 8, fillPaint);
    context.canvas.drawCircle(center, 10, borderPaint);
  }
}