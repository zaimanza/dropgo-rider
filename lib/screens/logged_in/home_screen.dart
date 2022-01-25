import 'package:dropgorider/const/no_glow.dart';
import 'package:dropgorider/widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> dropLocations = [];
  bool isLoadingCircularOn = false;
  final ValueNotifier<double> totalPriceFloatActionButton =
      ValueNotifier<double>(0);

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
            centerTitle: true,
            title: const Text(
              "Drop Go",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
          body: ScrollConfiguration(
            behavior: NoGlow(),
            child: SingleChildScrollView(
              primary: false,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.yellow,
                      child: const Center(
                        child: Text("Order today with Drop Go"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 150,
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
                              child: Container(),
                            ),
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ],
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
