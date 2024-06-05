import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/barberScreens/manageSlots.dart';
import 'package:intl/intl.dart';

class ManageDays extends StatefulWidget {
  const ManageDays({super.key});

  // final barberAvailability;
  @override
  State<ManageDays> createState() => _ManageDaysState();
}

class _ManageDaysState extends State<ManageDays> {
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
        Provider.of<SampleProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Days'),
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
                const Text('Manage Days'),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: sampleProvider.barberAvailability.keys.length,
                    itemBuilder: (context, index) {
                      var day = sampleProvider.barberAvailability.keys
                          .toList()[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageSlots(
                                day: day,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                              'Day : ${DateFormat('EEEE').format(DateTime.parse(day))}'),
                          subtitle: Text(
                              'Date : ${DateFormat('d MMM').format(DateTime.parse(day))}'),
                          trailing: Icon(
                            (Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      );
                    })
              ],
            ),
    );
  }
}
