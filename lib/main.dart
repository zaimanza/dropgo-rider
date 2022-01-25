import 'package:dropgorider/providers/rider_provider.dart';
import 'package:dropgorider/screens/logged_in/home_screen.dart';
import 'package:dropgorider/screens/start_screen.dart';
import 'package:dropgorider/services/firebase_messaging_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphQl/graph_ql_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initHiveForFlutter();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initFCMState();
    context.read(riderProvider).initState();
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Drop Go',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Consumer(
            builder: (context, watch, child) {
              return watch(riderProvider).initialPrefCall == true
                  ? watch(riderProvider).accessToken != ""
                      ? const HomeScreen()
                      : const StartScreen()
                  : const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
