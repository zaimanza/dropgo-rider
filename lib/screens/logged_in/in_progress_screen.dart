import 'package:dropgorider/const/date_format.dart';
import 'package:dropgorider/const/no_glow.dart';
import 'package:dropgorider/providers/in_progress_provider.dart';
import 'package:dropgorider/widget/in_progress_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class InProgressScreen extends StatefulWidget {
  const InProgressScreen({Key? key}) : super(key: key);

  @override
  _InProgressScreenState createState() => _InProgressScreenState();
}

class _InProgressScreenState extends State<InProgressScreen> {
  bool isLoadingCircularOn = false;
  List<Widget> orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildOrderList();
  }

  buildOrderList() {
    print("passing");
    orderList = [];
    for (var order in context.read(inProgressProvider).inProgressOrders) {
      orderList.add(
        InProgressBox(
          items: order.items,
          address: order.address,
          id: order.id,
          dateCreated: dateFormat(order.dateCreated),
          dateAccepted: dateFormat(order.dateAccepted),
          dateFinish: dateFormat(order.dateFinish),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.yellow,
            title: const Text(
              "In Progress",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          body: ScrollConfiguration(
            behavior: NoGlow(),
            child: SingleChildScrollView(
              primary: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Consumer(
                    builder: (context, watch, child) {
                      if (watch(inProgressProvider).allowBuild == true) {
                        buildOrderList();
                      }
                      return watch(inProgressProvider)
                              .inProgressOrders
                              .isNotEmpty
                          ? Column(
                              children: orderList,
                            )
                          : Column(
                              children: const [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "No Orders",
                                  style: TextStyle(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("You haven't accept any order"),
                              ],
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isLoadingCircularOn == true) ...[
          Center(
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ],
    );
  }
}
