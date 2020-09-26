import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/screen_type.dart';
import 'package:whats_for_dinner/widgets/choose_one_button.dart';
import 'package:whats_for_dinner/widgets/nav_drawer.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../providers/businesses.dart';
import '../widgets/dismissible_card.dart';

class RestaurantScreen extends StatefulWidget {
  final String title;

  RestaurantScreen({Key key, this.title}) : super(key: key);

  @override
  _RestaurantScreen createState() => _RestaurantScreen();
}

class _RestaurantScreen extends State<RestaurantScreen> {
  final Location location = Location();
  LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby restaurants'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: businessList.businesses.length > 0
            ? ListView.builder(
                itemCount: businessList.businesses.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return DismissibleCard(index, RestaurantVisibility.visible);
                },
              )
            : RaisedButton(
                onPressed: _updateData,
                child: Text('Load nearby restaurants',
                    style: Theme.of(context).textTheme.bodyText1),
                color: Theme.of(context).accentColor),
      ),
      drawer: NavDrawer(),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return ChooseOneButton(list: businessList.businesses, color: Color(0xffa4d1a2), errorText: 'There are no nearby restaurants!', screenType: ScreenType.nearby);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
    );
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initBusinesses(businesses);
  }
}
