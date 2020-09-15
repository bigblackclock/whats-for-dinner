import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './data/repository.dart';
import './models/business.dart';
import './services/api.dart';
import './services/api_service.dart';
import './widgets/restaurant_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
      create: (_) => Repository(
        apiService: APIService(API.dev()),
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Business> _businesses;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> businesses = await repository.getBusinessData();
    setState(() {
      _businesses = businesses;
    });
    print(_businesses.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: _businesses != null ? ListView.builder(
            itemCount: _businesses.length,
            itemBuilder: (BuildContext ctx, int index) {
              return RestaurantCard(_businesses[index]);
            },
          ) : Text('Press the button to load restaurants'),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateData,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
