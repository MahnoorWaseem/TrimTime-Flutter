import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/views/authentication/signup.dart';

class ClientHomePage extends StatelessWidget {
  ClientHomePage({super.key});

  // final User? user = FirebaseAuth.instance.currentUser;

  Map<String, dynamic>? localData;
  getLocalData() async {
    localData = await getDataFromLocalStorage();
  }

  //  LocalStorageModel? localStorageData;
  // getUserId() async {
  //   localStorageData =
  //       await LocalStorageModel.fromJson(await getDataFromLocalStorage());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Signup()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
          child: FutureBuilder(
        future: getLocalData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return Text(
              'Welcome Client with userID \n${localData!['uid']} \n isClient: ${localData!['isClient']}');
        },
      )),
    );
  }
}
