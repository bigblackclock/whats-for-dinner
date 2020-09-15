
import 'package:flutter/foundation.dart';
import '../models/business.dart';

import '../services/api_service.dart';

class Repository{
  Repository({@required this.apiService});
  final APIService apiService;

  Future<List<Business>> getBusinessData() async{
    return await apiService.getBusinesses();
  }

}