import 'dart:convert';

import 'package:dropgorider/models/rider_model.dart';
import 'package:dropgorider/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

final riderProvider = ChangeNotifierProvider((ref) => RiderProvider());
final RiderProvider riderProviderVar = RiderProvider();

class RiderProvider extends ChangeNotifier {
  late RiderModel riderModel = RiderModel(
    "",
    "",
    "",
    "",
    "",
    "",
    false,
    "",
    "",
    VehicleModel(
      "",
      "",
      "",
      "",
    ),
    "",
  );

  bool initialPrefCall = false;
  String accessToken = "";

  initState() async {
    if (initialPrefCall == false) {
      getSharedPreference();
    }
  }

  Future<String> getToken() async {
    if (accessToken != "") {
      return accessToken;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('accessToken') != null) {
      accessToken = sharedPreferences.getString('accessToken')!;
      return accessToken;
    }
    return "";
  }

  setRiderModel(riderResult) {
    print("setRiderModel");

    riderModel = RiderModel(
      riderResult['_id'] ?? "",
      riderResult['name'] ?? "",
      riderResult['email'] ?? "",
      riderResult['pNumber'] ?? "",
      riderResult['createAt'] ?? "",
      riderResult['updateAt'] ?? "",
      riderResult['isWork'] ?? false,
      riderResult['profileImg'] ?? "",
      riderResult['wallet'] ?? "",
      VehicleModel(
        riderResult['vehicle']['_id'],
        riderResult['vehicle']['plateNum'],
        riderResult['vehicle']['type'],
        riderResult['vehicle']['vehicleModel'],
      ),
      riderResult['accessToken'] ?? "",
    );
    accessToken = riderResult['accessToken'];
    notifyListeners();
    syncSharedPreference();
  }

  updateRiderModel(email, fullName, pNumber) {
    riderModel.email = email;
    riderModel.name = fullName;
    riderModel.pNumber = pNumber;
    notifyListeners();
    syncSharedPreference();
  }

  syncSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'rider', json.encode(riderModel.toJson()));
    await sharedPreferences.setString('accessToken', accessToken);
  }

  deleteSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    riderModel = RiderModel(
      "",
      "",
      "",
      "",
      "",
      "",
      false,
      "",
      "",
      VehicleModel(
        "",
        "",
        "",
        "",
      ),
      "",
    );
    accessToken = "";
    sharedPreferences.remove("accessToken");
    sharedPreferences.remove("rider");
    notifyListeners();
  }

  Future getSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('accessToken') != null) {
      accessToken = sharedPreferences.getString('accessToken')!;

      notifyListeners();
    }

    if (sharedPreferences.getString('rider') != null) {
      var resultRider = sharedPreferences.getString('rider');
      Map tempDecodeRider = json.decode(resultRider!);
      RiderModel tempriderModel = RiderModel(
        tempDecodeRider['id'] ?? "",
        tempDecodeRider['name'] ?? "",
        tempDecodeRider['email'] ?? "",
        tempDecodeRider['pNumber'] ?? "",
        tempDecodeRider['createAt'] ?? "",
        tempDecodeRider['updateAt'] ?? "",
        tempDecodeRider['isWork'] ?? false,
        tempDecodeRider['profileImg'] ?? "",
        tempDecodeRider['wallet'] ?? "",
        VehicleModel.fromJson(tempDecodeRider['vehicle']),
        tempDecodeRider['accessToken'] ?? "",
      );
      riderModel = tempriderModel;
    }

    initialPrefCall = true;
    notifyListeners();
  }
}
