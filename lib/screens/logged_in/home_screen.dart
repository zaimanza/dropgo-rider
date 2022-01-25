import 'package:dropgorider/const/date_format.dart';
import 'package:dropgorider/const/no_glow.dart';
import 'package:dropgorider/graphQl/graph_ql_api.dart';
import 'package:dropgorider/graphQl/order/end_work.dart';
import 'package:dropgorider/graphQl/order/in_progress.dart';
import 'package:dropgorider/graphQl/order/nearby_vendor.dart';
import 'package:dropgorider/graphQl/order/start_work.dart';
import 'package:dropgorider/providers/connectivity_provider.dart';
import 'package:dropgorider/providers/in_progress_provider.dart';
import 'package:dropgorider/providers/location_provider.dart';
import 'package:dropgorider/widget/my_order_box.dart';
import 'package:dropgorider/widget/navigation_drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'in_progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switchValue = false;
  List<Widget> dropLocations = [];
  bool isLoadingCircularOn = false;
  List<Widget> orderList = [];
  final ValueNotifier<double> totalPriceFloatActionButton =
      ValueNotifier<double>(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read(connectivityProvider).startConnectionProvider();
    context.read(locationProvider).askLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    context.read(connectivityProvider).disposeConnectionProvider();
  }

  startWorkGQL() async {
    setState(() {
      isLoadingCircularOn = true;
    });
    final Position _locationResult = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(startWork),
        variables: {
          "liveLatLng": _locationResult.latitude.toString() +
              "," +
              _locationResult.longitude.toString(),
        },
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
        orderList = [];
        isLoadingCircularOn = false;
        result.data!['startWork'].forEach((order) {
          orderList.add(
            MyOrderBox(
              items: order["items"],
              address: order["address"],
              id: order["_id"],
              dateCreated: dateFormat(order["dateCreated"]),
              dateAccepted: dateFormat(order["dateAccepted"]),
              dateFinish: dateFormat(order["dateFinish"]),
              rider: order["rider"] ?? {},
              nearbyVendorGQL: nearbyVendorGQL,
            ),
          );
        });
        switchValue = true;
      });
    }
  }

  endWorkGQL() async {
    setState(() {
      isLoadingCircularOn = true;
    });
    final Position _locationResult = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(endWork),
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
        orderList = [];
        isLoadingCircularOn = false;
        context.read(inProgressProvider).inProgressOrders = [];
        switchValue = false;
      });
    }
  }

  nearbyVendorGQL() async {
    setState(() {
      isLoadingCircularOn = true;
    });
    final Position _locationResult = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(nearbyVendor),
        variables: {
          "liveLatLng": _locationResult.latitude.toString() +
              "," +
              _locationResult.longitude.toString(),
        },
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
        orderList = [];
        isLoadingCircularOn = false;
        result.data!['nearbyVendor'].forEach((order) {
          orderList.add(
            MyOrderBox(
              items: order["items"],
              address: order["address"],
              id: order["_id"],
              dateCreated: dateFormat(order["dateCreated"]),
              dateAccepted: dateFormat(order["dateAccepted"]),
              dateFinish: dateFormat(order["dateFinish"]),
              rider: order["rider"] ?? {},
              nearbyVendorGQL: nearbyVendorGQL,
            ),
          );
        });
      });
    }
  }

  inProgressGQL() async {
    setState(() {
      isLoadingCircularOn = true;
    });
    final Position _locationResult = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(inProgress),
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
        orderList = [];
        isLoadingCircularOn = false;
        context
            .read(inProgressProvider)
            .setInProgress(result.data!['inProgress']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const NavigationDrawerWidget(),
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.yellow,
            title: switchValue
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, __, ___) =>
                              const InProgressScreen(),
                        ),
                      );
                    },
                    child: Consumer(
                      builder: (context, watch, child) {
                        return Text(
                          "In Progress (${watch(inProgressProvider).inProgressOrders.length.toString()})",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  )
                : const Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
            actions: [
              Center(
                child: switchValue
                    ? const Text(
                        "Online",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        "Offline",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              Switch.adaptive(
                activeColor: Colors.green,
                activeTrackColor: Colors.green.withOpacity(0.4),
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red.withOpacity(0.4),
                splashRadius: 50,
                value: switchValue,
                onChanged: (value) {
                  if (switchValue == false) {
                    startWorkGQL();
                    inProgressGQL();
                  } else {
                    endWorkGQL();
                  }
                },
              )
            ],
          ),
          body: ScrollConfiguration(
            behavior: NoGlow(),
            child: SingleChildScrollView(
              primary: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: switchValue
                      ? orderList.isNotEmpty
                          ? Consumer(
                              builder: (context, watch, child) {
                                return watch(inProgressProvider)
                                            .inProgressOrders
                                            .length <
                                        4
                                    ? Column(
                                        children: orderList,
                                      )
                                    : Column(
                                        children: const [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Maximum Orders Reached",
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text("Maximum of 4 orders reached."),
                                        ],
                                      );
                              },
                            )
                          : Column(
                              children: const [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "No Orders Yet",
                                  style: TextStyle(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("There is no nearby order"),
                              ],
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
                            Text("You are offline"),
                          ],
                        ),
                ),
              ),
            ),
          ),
          floatingActionButton: switchValue
              ? FloatingActionButton(
                  child: const Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    nearbyVendorGQL();
                    inProgressGQL();
                  },
                )
              : Container(),
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
