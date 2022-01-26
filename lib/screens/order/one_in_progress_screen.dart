import 'package:dropgorider/const/no_glow.dart';
import 'package:dropgorider/graphQl/graph_ql_api.dart';
import 'package:dropgorider/graphQl/order/accept_order.dart';
import 'package:dropgorider/models/address_model.dart';
import 'package:dropgorider/models/item_model.dart';
import 'package:dropgorider/widget/in_progress_item_box.dart';
import 'package:dropgorider/widget/order_item_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OneInProgressScreen extends StatefulWidget {
  final String id;
  final String dateCreated;
  final String dateAccepted;
  final String dateFinish;
  final AddressModel address;
  final List<ItemModel> items;
  const OneInProgressScreen({
    Key? key,
    required this.id,
    required this.dateCreated,
    required this.dateAccepted,
    required this.dateFinish,
    required this.address,
    required this.items,
  }) : super(key: key);

  @override
  _OneInProgressScreenState createState() => _OneInProgressScreenState();
}

class _OneInProgressScreenState extends State<OneInProgressScreen> {
  bool isLoadingCircularOn = false;
  List<Widget> orderItemsBox = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var item in widget.items) {
      orderItemsBox.add(
        InProgressItemBox(
          itemState: item.itemState,
          trackCode: item.trackCode,
          itemImg: item.itemImg,
          totalPrice: item.totalPrice.toStringAsFixed(2),
          itemInstruction: item.itemInstruction,
          receiver: item.receiver,
          address: item.address,
        ),
      );
    }
  }

  acceptOrderGQL() async {
    setState(() {
      isLoadingCircularOn = true;
    });
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(acceptOrder),
        variables: {
          "orderId": widget.id,
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
        isLoadingCircularOn = false;
        print(result.data);
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white.withOpacity(0.95),
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.yellow,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              widget.address.fullAddr,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
          ),
          body: ScrollConfiguration(
            behavior: NoGlow(),
            child: SingleChildScrollView(
              primary: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              bottom: 6.0), //Same as `blurRadius` i guess
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                            boxShadow: const [
                              //pickup location
                              // deliver location
                              // add button. max 4
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "Created",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Text(widget.dateCreated),
                                      ],
                                    ),
                                  ),
                                  if (widget.dateAccepted != "") ...[
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "Accepted",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Text(widget.dateAccepted),
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (widget.dateFinish != "") ...[
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "Finished",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Text(widget.dateFinish),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              bottom: 6.0), //Same as `blurRadius` i guess
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                            boxShadow: const [
                              //pickup location
                              // deliver location
                              // add button. max 4
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Pickup address",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              bottom: 6.0), //Same as `blurRadius` i guess
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                            boxShadow: const [
                              //pickup location
                              // deliver location
                              // add button. max 4
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Full address :",
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.address.fullAddr,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "State :",
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.address.state,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "City :",
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.address.city,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Country :",
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.address.country,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Postcode :",
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.address.postcode.toString(),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Unit/Floor :",
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          widget.address.unitFloor,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              bottom: 6.0), //Same as `blurRadius` i guess
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                            boxShadow: const [
                              //pickup location
                              // deliver location
                              // add button. max 4
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Parcels",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: orderItemsBox,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          acceptOrderGQL();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: const ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: StadiumBorder(),
                          ),
                          child: const Center(
                            child: Text(
                              "Accept Order",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
