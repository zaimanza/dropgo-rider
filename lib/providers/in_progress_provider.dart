import 'package:dropgorider/const/is_interger.dart';
import 'package:dropgorider/models/address_model.dart';
import 'package:dropgorider/models/in_progress_order_model.dart';
import 'package:dropgorider/models/item_model.dart';
import 'package:dropgorider/models/receiver_model.dart';
import 'package:dropgorider/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final inProgressProvider =
    ChangeNotifierProvider((ref) => InProgressProvider());
final InProgressProvider inProgressProviderVar = InProgressProvider();

class InProgressProvider extends ChangeNotifier {
  List<InProgressOrderModel> inProgressOrders = [];
  bool allowBuild = false;

  updateOrdersItemStatus(orderId, itemId, itemState, buildOrderList) {
    print("updateOrdersItemStatus");
    print(itemState);
    if (itemState == "accepted") {
      print("accepted c1");
      for (var element in inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items) {
        print(element.itemState);
      }
      var itemIndex = inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items
          .indexWhere(
            (item) => item.id == itemId,
          );
      var changingItem = inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items[itemIndex];
      changingItem.itemState = "picked up";
      inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items[itemIndex] = changingItem;

      print("accepted c2");
      for (var element in inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items) {
        print(element.itemState);
      }
    } else if (itemState == "picked up") {
      var itemIndex = inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items
          .indexWhere(
            (item) => item.id == itemId,
          );
      var changingItem = inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items[itemIndex];
      changingItem.itemState = "delivered";

      inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items[itemIndex] = changingItem;

      print(inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items[itemIndex]
          .itemState);
      print("c1");
      //check each item
      bool canDelete = true;
      for (var item in inProgressOrders[inProgressOrders.indexWhere(
        (order) => order.id == orderId,
      )]
          .items) {
        print("c2");
        print(item.itemState);
        if (item.itemState == "accepted" || item.itemState == "picked up") {
          canDelete = false;
        }
      }
      print("canDelete");
      print(canDelete);
      if (canDelete == true) {
        inProgressOrders.removeAt(inProgressOrders.indexWhere(
          (order) => order.id == orderId,
        ));
        buildOrderList();
      }
    }
    notifyListeners();
  }

  setInProgress(inProgressResults) {
    inProgressOrders = [];

    inProgressResults.forEach((order) {
      List<ItemModel> items = [];
      order['items'].forEach((item) {
        double totalPrice = 0.0;
        if (isInteger(item["totalPrice"])) {
          totalPrice = item["totalPrice"].toDouble();
        } else {
          totalPrice = item["totalPrice"];
        }
        items.add(
          ItemModel(
            item["_id"] ?? "",
            item["itemState"] ?? "",
            item["trackCode"] ?? "",
            item["itemImg"] ?? "",
            totalPrice,
            item["itemInstruction"] ?? "",
            item["updateAt"] ?? "",
            ReceiverModel(
              item["receiver"]["_id"] ?? "",
              item["receiver"]["name"] ?? "",
              item["receiver"]["pNumber"] ?? "",
            ),
            AddressModel(
              item["address"]["_id"] ?? "",
              item["address"]["latLng"] ?? "",
              item["address"]["state"] ?? "",
              item["address"]["city"] ?? "",
              item["address"]["country"] ?? "",
              item["address"]["fullAddr"] ?? "",
              item["address"]["postcode"] ?? 0,
              item["address"]["unitFloor"] ?? "",
            ),
          ),
        );
      });

      inProgressOrders.add(
        InProgressOrderModel(
          order["_id"] ?? "",
          order["dateCreated"] ?? "",
          order["dateAccepted"] ?? "",
          order["dateFinish"] ?? "",
          items,
          AddressModel(
            order["address"]["_id"] ?? "",
            order["address"]["latLng"] ?? "",
            order["address"]["state"] ?? "",
            order["address"]["city"] ?? "",
            order["address"]["country"] ?? "",
            order["address"]["fullAddr"] ?? "",
            order["address"]["postcode"] ?? 0,
            order["address"]["unitFloor"] ?? "",
          ),
          VendorModel(
            order["vendor"]["_id"] ?? "",
            order["vendor"]["name"] ?? "",
            order["vendor"]["email"] ?? "",
            order["vendor"]["pNumber"] ?? "",
            order["vendor"]["createAt"] ?? "",
            order["vendor"]["updateAt"] ?? "",
          ),
        ),
      );
    });
    notifyListeners();
  }
}
