import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/models/local_storage_model.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/barberScreens/barber_bookings.dart';
import 'package:trim_time/views/barberScreens/manage_days.dart';

class BarberHomePage extends StatefulWidget {
  BarberHomePage({super.key});

  @override
  State<BarberHomePage> createState() => _BarberHomePageState();
}

class _BarberHomePageState extends State<BarberHomePage> {
  late Map<String, dynamic> localData;
  final isClient = false;
  bool _isLoading = true;

  _loadData() async {
    localData = await getDataFromLocalStorage();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: true);

    // sampleProvider.barberAvailability = widget.barberAvailability;

    // print(
    //     ' (from provider): \n Barbers Availability--------------> ${sampleProvider.barberAvailability}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barber Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Signup()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Text('Welcome ${localData['userData']['name']}'),
                Text('Email: ${localData['userData']['email']}'),
                Text('Phone Number: ${localData['userData']['phoneNumber']}'),
                Text('isClient: ${localData['isClient']}'),
                ElevatedButton(
                  onPressed: () {
                    sampleProvider.uid = localData['userData']['uid'];
                    sampleProvider.barberAvailability =
                        localData['userData']['availability'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageDays()),
                    );
                  },
                  child: const Text('Manage Slots'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarberBookings()),
                    );
                  },
                  child: const Text('Bookings'),
                ),
              ],
            ),
    );
  }
}
