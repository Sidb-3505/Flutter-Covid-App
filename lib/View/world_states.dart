import 'package:covid_app/Models/WorldStatesModel.dart';
import 'package:covid_app/Services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'countries_list_screen.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    StatesServices statesServices = StatesServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<WorldStatesModel>(
            future: statesServices.fetchWorldStatesRecords(),
            builder: (context, snapshot) {
              //for debugging purpose
              if (snapshot.hasError) {
                debugPrint('Snapshot error: ${snapshot.error}');
                if (snapshot.error is Exception) {
                  debugPrint((snapshot.error as Exception).toString());
                }
                if (snapshot.stackTrace != null) {
                  print(snapshot.stackTrace);
                }
              }
              if (snapshot.hasData) {
                debugPrint('Snapshot data: ${snapshot.data}');
              }

              //loading animation
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50,
                    controller: _controller,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final data = snapshot.data!;

                //main logic
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      PieChart(
                        dataMap: {
                          "Total": (data.cases ?? 0).toDouble(),
                          "Recovered": (data.recovered ?? 0).toDouble(),
                          "Deaths": (data.deaths ?? 0).toDouble(),
                        },
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        chartRadius: screenWidth / 3.2,
                        legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left,
                        ),
                        animationDuration: const Duration(milliseconds: 1200),
                        chartType: ChartType.ring,
                        colorList: colorList,
                      ),
                      SizedBox(height: screenHeight * 0.06),
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              ReusableRows(
                                title: 'Total Cases',
                                value: (data.cases ?? 0).toString(),
                              ),
                              ReusableRows(
                                title: 'Recovered',
                                value: (data.recovered ?? 0).toString(),
                              ),
                              ReusableRows(
                                title: 'Deaths',
                                value: (data.deaths ?? 0).toString(),
                              ),
                              ReusableRows(
                                title: 'Active',
                                value: (data.active ?? 0).toString(),
                              ),
                              ReusableRows(
                                title: 'Critical',
                                value: (data.critical ?? 0).toString(),
                              ),
                              ReusableRows(
                                title: 'Today Deaths',
                                value: (data.todayDeaths ?? 0).toString(),
                              ),
                              ReusableRows(
                                title: 'Today Recovered',
                                value: (data.todayRecovered ?? 0).toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountriesListScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Track Countries',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReusableRows extends StatelessWidget {
  final String title;
  final String value;

  const ReusableRows({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
