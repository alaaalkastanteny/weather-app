import 'dart:developer';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import '../model/country_Info.dart';
import '../managers/api_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryInfo> countries = [];
  List<CountryInfo> FilteredCountries = [];

  bool isLoading = true;
  getCountries() async {
    dynamic data = await apiManger.getCountries();
    countries = CountryInfo.fromJsonArray(data);
    countries.sort((c1, c2) {
      return c1.name!.compareTo(c2.name!);
    });
    FilteredCountries = countries;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AnimSearchBar(
                /*  onChanged: (val) {
                  setState(() {
                    if (val.isEmpty) {
                      FilteredCountries = countries;
                    }
                    FilteredCountries = countries
                        .where((Country) =>
                            Country.name!.toLowerCase().startsWith(val) ||
                            Country.capital!.toLowerCase().startsWith(val))
                        .toList();
                  });
                },*/
                width: 400,
                textController: _searchController,
                rtl: true,
                suffixIcon: const Icon(Icons.search),
                onSuffixTap: () {
                  Navigator.pop(context, _searchController.text);
                },
              ),
              isLoading
                  ? const Expanded(
                      child: Center(
                      child: CircularProgressIndicator(),
                    ))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: FilteredCountries.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(
                                    context, FilteredCountries[index].capital!);
                              },
                              title: Text(FilteredCountries[index].name!),
                              subtitle: Text(FilteredCountries[index].capital!),
                              trailing: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    FilteredCountries[index].flagUrl!),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        )),
      ),
    );
  }
}
