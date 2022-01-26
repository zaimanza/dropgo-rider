import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropgorider/const/string_capital.dart';
import 'package:dropgorider/graphQl/graph_ql_api.dart';
import 'package:dropgorider/graphQl/order/rider_update_item_status.dart';
import 'package:dropgorider/models/address_model.dart';
import 'package:dropgorider/models/receiver_model.dart';
import 'package:dropgorider/providers/in_progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class InProgressItemBox extends StatefulWidget {
  final String orderId;
  final String itemId;
  final String itemImg;
  final String itemState;
  final String trackCode;
  final String totalPrice;
  final String itemInstruction;
  final ReceiverModel receiver;
  final AddressModel address;
  final Function buildOrderList;
  const InProgressItemBox({
    Key? key,
    required this.orderId,
    required this.itemId,
    required this.itemState,
    required this.trackCode,
    required this.itemImg,
    required this.totalPrice,
    required this.itemInstruction,
    required this.receiver,
    required this.address,
    required this.buildOrderList,
  }) : super(key: key);

  @override
  _InProgressItemBoxState createState() => _InProgressItemBoxState();
}

class _InProgressItemBoxState extends State<InProgressItemBox> {
  bool isLoadingCircularOn = false;

  riderUpdateItemStatusGQL(itemState) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(riderUpdateItemStatus),
        variables: {
          "orderId": widget.orderId,
          "itemId": widget.itemId,
          "itemState": itemState
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
    if (result.hasException == false && result.isLoading == false) {
      context.read(inProgressProvider).updateOrdersItemStatus(widget.orderId,
          widget.itemId, widget.itemState, widget.buildOrderList);
      ;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: double.infinity,
        margin:
            const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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
                    Expanded(
                      child: widget.itemImg.startsWith("http") == true
                          ? Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                // shape: StadiumBorder(),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: widget.itemImg,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Text(
                          "Parcel state :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.itemState.capitalize(),
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
                          "Track code :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.trackCode,
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
                          "Price :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "RM" + widget.totalPrice,
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
                          "Rider's instruction :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.itemInstruction.capitalize(),
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
                          "Receiver :",
                        )),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.receiver.name.toString().capitalize(),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                          Text(
                            widget.receiver.pNumber,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
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
                        widget.address.fullAddr.toString().capitalize(),
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
                        widget.address.state.toString().capitalize(),
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
                        widget.address.city.toString().capitalize(),
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
                        widget.address.country.toString().capitalize(),
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
                if (widget.itemState != "delivered") ...[
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (widget.itemState == "accepted") {
                        riderUpdateItemStatusGQL("picked up");
                        //update provider to picked up
                      } else if (widget.itemState == "picked up") {
                        riderUpdateItemStatusGQL("delivered");
                        // check provider, if semua item dh delivered delete
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlue,
                        shape: StadiumBorder(),
                      ),
                      child: Center(
                        child: Text(
                          (() {
                            if (widget.itemState == "accepted") {
                              return "Pick Up";
                            } else if (widget.itemState == "picked up") {
                              return "Deliver";
                            } else {
                              return "Pick Up";
                            }
                          }()),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
