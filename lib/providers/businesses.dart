import '../models/business.dart';
import 'package:flutter/foundation.dart';


class Businesses with ChangeNotifier{ 
  List<Business> _businesses = [];
  List<Business> _hidden = [];
  List<Business> _favorites = [];

  List<Business> get businesses {
    return [..._businesses];
  }

  List<Business> get hidden {
    return [..._hidden];
  }

  List<Business> get favorites {
    return [..._favorites];
  }

  void initBusinesses(List<Business> businesses){
    businesses.removeWhere((business) => _hidden.contains(business));
    _businesses = businesses;
    notifyListeners();
  }

  void addHidden(Business business){
    _hidden.add(business);
    notifyListeners();  
  }

  void addFavorite(Business business){
    _favorites.add(business);
    notifyListeners();
  }

  void removeBusiness(Business businessToRemove){
    _businesses.removeWhere((business) => business == businessToRemove);
    notifyListeners();
  }

  Business findById(String id){
    return _businesses.where((business) => business.id == id) as Business;
  }

}