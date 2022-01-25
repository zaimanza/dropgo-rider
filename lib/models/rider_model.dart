import 'package:dropgorider/models/vehicle_model.dart';

class RiderModel {
  String id;
  String name;
  String email;
  String pNumber;
  String createAt;
  String updateAt;
  bool isWork;
  String profileImg;
  String wallet;
  VehicleModel vehicle;
  String accessToken;

  RiderModel(
    this.id,
    this.name,
    this.email,
    this.pNumber,
    this.createAt,
    this.updateAt,
    this.isWork,
    this.profileImg,
    this.wallet,
    this.vehicle,
    this.accessToken,
  );

  Map toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'pNumber': pNumber,
        'createAt': createAt,
        'updateAt': updateAt,
        'isWork': isWork,
        'profileImg': profileImg,
        'wallet': wallet,
        'vehicle': vehicle.toJson(),
        'accessToken': accessToken,
      };

  RiderModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        pNumber = json['pNumber'],
        createAt = json['createAt'],
        updateAt = json['updateAt'],
        isWork = json['isWork'],
        profileImg = json['profileImg'],
        wallet = json['wallet'],
        vehicle = json['vehicle'],
        accessToken = json['accessToken'];
}
