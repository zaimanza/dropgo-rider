import 'package:dropgorider/models/receiver_model.dart';

import 'address_model.dart';

class ItemModel {
  String id;
  String itemState;
  String trackCode;
  String itemImg;
  // double totalPrice;
  String itemInstruction;
  String updateAt;
  ReceiverModel receiver;
  AddressModel address;

  ItemModel(
    this.id,
    this.itemState,
    this.trackCode,
    this.itemImg,
    // this.totalPrice,
    this.itemInstruction,
    this.updateAt,
    this.receiver,
    this.address,
  );

  Map toJson() => {
        'id': id,
        'itemState': itemState,
        'trackCode': trackCode,
        'itemImg': itemImg,
        // 'totalPrice': totalPrice,
        'itemInstruction': itemInstruction,
        'updateAt': updateAt,
        'receiver': receiver.toJson(),
        'address': address.toJson(),
      };

  ItemModel.fromJson(Map json)
      : id = json['id'],
        itemState = json['itemState'],
        trackCode = json['trackCode'],
        itemImg = json['itemImg'],
        // totalPrice = json['totalPrice'],
        itemInstruction = json['itemInstruction'],
        updateAt = json['updateAt'],
        receiver = json['receiver'],
        address = json['address'];
}
