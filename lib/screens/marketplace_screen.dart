import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String? _selectedGpuModel;
  String? _selectedRegion;
  SfRangeValues _priceRangeValues = const SfRangeValues(0.5, 2.5);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: responsive.screenPadding,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: responsive.mainSpacing * 0.2),
                // ✅ REPLACED DashboardItem with a correctly styled Text widget
                Text(
                  'GPU Marketplace',
                  style: TextStyle(
                    fontSize: responsive.titleSize * 1.1,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Manrope',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: responsive.mainSpacing * 2),
                
                // Search and Filter Card
                Card(
                  elevation: 2,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                     side: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(responsive.mainSpacing * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search GPUs or providers...',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                        SizedBox(height: responsive.mainSpacing * 1.5),

                        // Dropdowns in a Row
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'GPU MODEL',
                                ),
                                value: _selectedGpuModel,
                                hint: const Text('All'),
                                items: <String>[
                                  'RTX 4090',
                                  'RTX 3090',
                                  'A100',
                                  'V100'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGpuModel = newValue;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: responsive.mainSpacing),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'REGION',
                                ),
                                value: _selectedRegion,
                                hint: const Text('All'),
                                items: <String>[
                                  'North America',
                                  'Europe',
                                  'Asia Pacific'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedRegion = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.mainSpacing * 2),

                        // Price Range Slider
                        Text(
                          'PRICE: \$${_priceRangeValues.start.toStringAsFixed(2)} - \$${_priceRangeValues.end.toStringAsFixed(2)} / HR',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                            fontSize: responsive.subtitleSize * 0.8,
                          ),
                        ),
                        SfRangeSlider(
                          min: 0.0,
                          max: 3.0,
                          values: _priceRangeValues,
                          interval: 1,
                          showTicks: true,
                          showLabels: true,
                          enableTooltip: true,
                          minorTicksPerInterval: 1,
                          onChanged: (SfRangeValues newValues) {
                            setState(() {
                              _priceRangeValues = newValues;
                            });
                          },
                        ),
                      ],
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