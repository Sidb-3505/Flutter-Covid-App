import 'package:covid_app/Services/states_services.dart';
import 'package:covid_app/View/country_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({super.key});

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatesServices stateServices = StatesServices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Your Country Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: stateServices.countriesListApi(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            children: [
                              ListTile(
                                title: Container(
                                  height: 10,
                                  width: 80,
                                  color: Colors.white,
                                ),
                                subtitle: Container(
                                  height: 10,
                                  width: 80,
                                  color: Colors.white,
                                ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        //taking the var to store snapshot
                        var data = snapshot.data![index];
                        //making the search functionality
                        String countryName = data['country'];
                        //comparisons
                        if (searchController.text.isEmpty) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CountryDetailsScreen(
                                            name: data['country'],
                                            image: data['countryInfo']['flag'],
                                            totalCases: data['cases'],
                                            totalDeaths: data['deaths'],
                                            totalRecovered: data['recovered'],
                                            active: data['active'],
                                            critical: data['critical'],
                                            todayRecovered:
                                                data['todayRecovered'],
                                          ),
                                    ),
                                  );
                                  setState(() {
                                    searchController.clear();
                                  });
                                },
                                child: ListTile(
                                  title: Text(data['country']),
                                  subtitle: Text(data['cases'].toString()),
                                  leading: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(
                                      data['countryInfo']['flag'],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (countryName.toLowerCase().contains(
                          searchController.text.toLowerCase(),
                        )) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CountryDetailsScreen(
                                            name: data['country'],
                                            image: data['countryInfo']['flag'],
                                            totalCases: data['cases'],
                                            totalDeaths: data['deaths'],
                                            totalRecovered: data['recovered'],
                                            active: data['active'],
                                            critical: data['critical'],
                                            todayRecovered:
                                                data['todayRecovered'],
                                          ),
                                    ),
                                  );
                                  setState(() {
                                    searchController.clear();
                                  });
                                },
                                child: ListTile(
                                  title: Text(data['country']),
                                  subtitle: Text(data['cases'].toString()),
                                  leading: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(
                                      data['countryInfo']['flag'],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
