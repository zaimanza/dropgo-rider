import 'package:dropgorider/const/no_glow.dart';
import 'package:dropgorider/graphQl/graph_ql_api.dart';
import 'package:dropgorider/graphQl/rider_auth/verify_rider.dart';
import 'package:dropgorider/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class VerifyRiderScreen extends StatefulWidget {
  const VerifyRiderScreen({Key? key}) : super(key: key);

  @override
  _VerifyRiderScreenState createState() => _VerifyRiderScreenState();
}

class _VerifyRiderScreenState extends State<VerifyRiderScreen> {
  TextEditingController riderIdController = TextEditingController();
  bool isRiderIdEmpty = false;
  bool isRiderIdErr = false;

  bool isLoadingCircularOn = false;

  @override
  void initState() {
    super.initState();
    context.read(connectivityProvider).startConnectionProvider();
  }

  @override
  void dispose() {
    super.dispose();
    context.read(connectivityProvider).disposeConnectionProvider();
  }

  verifyRiderGQL(verifyRiderObj) async {
    setState(() {
      isLoadingCircularOn = true;
    });
    print(verifyRiderObj);
    QueryResult result;
    result = await clientQuery.query(
      QueryOptions(
        document: gql(verifyRider),
        variables: verifyRiderObj,
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
      });
      print(result.data);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Colors.yellow,
          resizeToAvoidBottomInset: true,
          body: ScrollConfiguration(
            behavior: NoGlow(),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: IntrinsicHeight(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 30,
                      ),
                      child: Stack(
                        children: [
                          AutofillGroup(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                ),
                                const Text(
                                  "Verify Rider",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: const ShapeDecoration(
                                    color: Colors.white,
                                    shape: StadiumBorder(),
                                  ),
                                  child: TextFormField(
                                    autofillHints: const [AutofillHints.email],
                                    buildCounter: (BuildContext context,
                                            {required currentLength,
                                            maxLength,
                                            required isFocused}) =>
                                        null,
                                    maxLength: 320,
                                    onChanged: (value) {
                                      setState(() {
                                        isRiderIdEmpty = false;
                                        isRiderIdErr = false;
                                      });
                                    },
                                    controller: riderIdController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Rider Id",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.only(left: 40),
                                    ),
                                  ),
                                ),
                                if (isRiderIdEmpty || isRiderIdErr) ...[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Rider Id cannot be empty and must only contain numbers.",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (riderIdController.text.isEmpty) {
                                      setState(() {
                                        isRiderIdEmpty = true;
                                      });
                                    } else {
                                      isRiderIdEmpty = false;
                                    }

                                    if (riderIdController.text.isNotEmpty) {
                                      Map<String, dynamic> verifyRiderObj = {};
                                      //Check Email
                                      setState(() {
                                        isRiderIdErr = isRiderIdEmpty = false;
                                      });
                                      verifyRiderObj['riderId'] =
                                          riderIdController.text;

                                      if (context
                                              .read(connectivityProvider)
                                              .connectionStatus ==
                                          true) {
                                        if (verifyRiderObj.isNotEmpty) {
                                          TextInput.finishAutofillContext();
                                          verifyRiderGQL(verifyRiderObj);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("No internet connection."),
                                          ),
                                        );
                                      }
                                    }
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
                                        "Verify",
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
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
