import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';
import 'package:whats_for_dinner/providers/favorites.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../providers/businesses.dart';

class NearbyScreen extends StatefulWidget {
  final String title;
  static const routeName = '/nearby';
  NearbyScreen({Key key, this.title}) : super(key: key);

  @override
  _NearbyScreen createState() => _NearbyScreen();
}

class _NearbyScreen extends State<NearbyScreen> {
  final Location location = Location();
  LocationData _locationData;
  bool _isInit = true;

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<Businesses>(context);
    return Center(
      child: businessProvider.nearby.length > 0
          ? ListView.builder(
              itemCount: businessProvider.nearby.length,
              itemBuilder: (context, int index) {
                return RestaurantCard(
                    business: businessProvider.nearby[index],
                    cardColor: Colors.white);
              },
            )
          : CircularProgressIndicator(),
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Favorites>(context)
          .fetchAndSetFavorites(Provider.of<Auth>(context).uid);
      Provider.of<CustomLists>(context)
          .fetchAndSetCustomLists(Provider.of<Auth>(context).uid);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    _locationData = await location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> businesses = await repository.getBusinessData(
      lat: _locationData.latitude,
      long: _locationData.longitude,
      radius: 2000,
    );
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initNearby(businesses);
  }
}
