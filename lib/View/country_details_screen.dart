import 'package:flutter/material.dart';

class CountryDetailsScreen extends StatefulWidget {
  String name, image;
  int totalCases,
      totalDeaths,
      totalRecovered = 0,
      active,
      critical,
      todayRecovered;
  CountryDetailsScreen({
    super.key,
    required this.name,
    required this.image,
    required this.totalCases,
    required this.totalDeaths,
    required this.todayRecovered,
    required this.active,
    required this.critical,
    required int totalRecovered,
  });

  @override
  State<CountryDetailsScreen> createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name), centerTitle: true),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.077,
                    bottom: MediaQuery.of(context).size.height * 0.037,
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(widget.image),
                  ),
                ),
                ReusableRows(
                  title: 'Total Cases',
                  value: (widget.totalCases ?? 0).toString(),
                ),
                ReusableRows(
                  title: 'Recovered',
                  value: (widget.totalRecovered ?? 0).toString(),
                ),
                ReusableRows(
                  title: 'Deaths',
                  value: (widget.totalDeaths ?? 0).toString(),
                ),
                ReusableRows(
                  title: 'Active',
                  value: (widget.active ?? 0).toString(),
                ),
                ReusableRows(
                  title: 'Critical',
                  value: (widget.critical ?? 0).toString(),
                ),
                ReusableRows(
                  title: 'Today Recovered',
                  value: (widget.todayRecovered ?? 0).toString(),
                ),
              ],
            ),
          ),
        ],
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
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
