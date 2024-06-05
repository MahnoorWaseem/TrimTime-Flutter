import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/authentication/signup_page.dart';
import 'package:trim_time/views/barberScreens/manage_days.dart';

class ManageSlots extends StatefulWidget {
  const ManageSlots({super.key, required this.day});

  final String day;

  @override
  State<ManageSlots> createState() => _ManageSlotsState();
}

class _ManageSlotsState extends State<ManageSlots> {
  final isClient = false;

  @override
  Widget build(BuildContext context) {
    print('widget rebuiding');
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);
    print('DAy ----> ${widget.day}');

    print(
        'isEqual ----> ${sampleProvider.barberAvailability[widget.day] == '2024-06-08T02:31:25.461406'}');
    print('slots ----> ${sampleProvider.barberAvailability[widget.day]}');
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Slots updated successfully'),
              ),
            );

            await updateBarberAvailabilityInFireStore(
              barberId: sampleProvider.uid,
              data: sampleProvider.barberAvailability,
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ManageDays(),
            //   ),
            // );
          },
          child: const Icon(Icons.done_rounded),
        ),
        appBar: AppBar(
          title: Text('  Day ${widget.day}'),
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
        body: sampleProvider.barberAvailability[widget.day] == null
            ? const Center(
                child: Text('No slots available for this day'),
              )
            : ListView.builder(
                itemCount: sampleProvider
                    .barberAvailability[widget.day]['slots'].length,
                itemBuilder: (context, index) {
                  var slot = sampleProvider.barberAvailability[widget.day]
                      ['slots'][index];
                  return Consumer<SampleProvider>(
                      builder: (context, provider, child) {
                    return ListTile(
                      title: Text(
                          'Slot Time:      ${DateFormat('hh : mm').format(DateTime.parse(slot['start']))} - ${DateFormat('hh : mm').format(DateTime.parse(slot['end']))}'),
                      trailing: Switch(
                        value: slot['isAvailable'],
                        onChanged: (value) {
                          print('New value ------> $value');
                          provider.updateBarberAvailability(
                              day: widget.day, slotIndex: index, value: value);
                        },
                      ),
                    );
                  }
                      // child: ListTile(
                      //   title: Text(
                      //       'Slot ${index + 1} : ${slot['start']} - ${slot['end']}'),
                      //   trailing: Switch(
                      //     value: slot['isAvailable'],
                      //     onChanged: (value) {
                      //       print('New value ------> $value');
                      //       sampleProvider.barberAvailability[widget.day]['slots']
                      //           [index]['isAvailable'] = value;

                      //     },
                      //   ),
                      // ),
                      );
                }));
  }
}

// class _ManageSlotsState extends State<ManageSlots> {
 

  

  

