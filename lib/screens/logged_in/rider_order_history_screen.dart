import 'package:dropgorider/const/date_format.dart';
import 'package:dropgorider/const/no_glow.dart';
import 'package:dropgorider/graphQl/graph_ql_api.dart';
import 'package:dropgorider/graphQl/order/rider_order_history.dart';
import 'package:dropgorider/providers/rider_order_history_provider.dart';
import 'package:dropgorider/widget/in_progress_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RiderOrderHistoryScreen extends StatefulWidget {
  const RiderOrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _RiderOrderHistoryScreenState createState() =>
      _RiderOrderHistoryScreenState();
}

class _RiderOrderHistoryScreenState extends State<RiderOrderHistoryScreen> {
  bool isLoadingCircularOn = false;
  List<Widget> orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    riderOrderHistoryGQL();
  }

  riderOrderHistoryGQL() async {
    setState(() {
      isLoadingCircularOn = true;
    });
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(riderOrderHistory),
      ),
    );

    if (result.hasException == true) {
      setState(() {
        isLoadingCircularOn = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.exception!.graphqlErrors[0].message.toString()),
        ),
      );
    }

    if (result.data != null) {
      setState(() {
        isLoadingCircularOn = false;
        context
            .read(riderOrderHistoryProvider)
            .setRiderOrderHistory(result.data!['riderOrderHistory']);
        print("passing");
        print(context
            .read(riderOrderHistoryProvider)
            .riderOrderHistoryOrders
            .length);
        orderList = [];
        for (var order in context
            .read(riderOrderHistoryProvider)
            .riderOrderHistoryOrders) {
          orderList.add(
            InProgressBox(
              items: order.items,
              address: order.address,
              id: order.id,
              dateCreated: dateFormat(order.dateCreated),
              dateAccepted: dateFormat(order.dateAccepted),
              dateFinish: dateFormat(order.dateFinish),
              buildOrderList: buildOrderList,
            ),
          );
        }
        setState(() {});
      });
    }
  }

  buildOrderList() {}

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
              "Order History",
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
                      if (watch(riderOrderHistoryProvider).allowBuild == true) {
                        buildOrderList();
                      }
                      return watch(riderOrderHistoryProvider)
                              .riderOrderHistoryOrders
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
                                  "No Order History",
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
