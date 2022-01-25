import 'dart:convert';

import 'package:dropgorider/models/vendor_model.dart';

import 'address_model.dart';
import 'item_model.dart';

class InProgressOrderModel {
  String id;
  String dateCreated;
  String dateAccepted;
  String dateFinish;
  List<ItemModel> items;
  AddressModel address;
  VendorModel vendor;

  InProgressOrderModel(
    this.id,
    this.dateCreated,
    this.dateAccepted,
    this.dateFinish,
    this.items,
    this.address,
    this.vendor,
  );

  Map toJson() => {
        'id': id,
        'dateCreated': dateCreated,
        'dateAccepted': dateAccepted,
        'dateFinish': dateFinish,
        'items': jsonEncode(items),
        'address': address.toJson(),
        'vendor': vendor.toJson(),
      };

  InProgressOrderModel.fromJson(Map json)
      : id = json['id'],
        dateCreated = json['dateCreated'],
        dateAccepted = json['dateAccepted'],
        dateFinish = json['dateFinish'],
        items = json['items'],
        address = json['address'],
        vendor = json['vendor'];
}
