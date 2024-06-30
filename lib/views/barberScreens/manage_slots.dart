import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/firestore.dart';
import 'package:trim_time/controller/local_storage.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';

class ManageSlots extends StatefulWidget {
  const ManageSlots({super.key, required this.day});

  final String day;

  @override
  State<ManageSlots> createState() => _ManageSlotsState();
}

class _ManageSlotsState extends State<ManageSlots> {
  final isClient = false;

  _updateData(
      {required String uid,
      required Map<String, dynamic> barberAvailability}) async {
    await updateBarberAvailabilityInFirestore(
      barberId: uid,
      data: barberAvailability,
    );

    await updateUserDataInLocalStorage(
        data: await getUserDataFromFirestore(uid, isClient));
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () async {
          appProvider.setUpdateSlotsCIP(true);

          await _updateData(
              uid: appProvider.uid,
              barberAvailability: appProvider.barberAvailability);

          appProvider.setUpdateSlotsCIP(false);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Slots updated successfully'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        }, child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return provider.updateSlotsCIP
                ? Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  )
                : const Icon(Icons.done);
          },
        )),
        appBar: AppBar(
          title:
              Text('${DateFormat('EEEE').format(DateTime.parse(widget.day))}'),
          actions: [
            IconButton(
              onPressed: () async {
                await signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignIn()),
                    (Route route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: appProvider.barberAvailability[widget.day] == null
            ? const Center(
                child: Text('No slots available for this day'),
              )
            : ListView.builder(
                itemCount:
                    appProvider.barberAvailability[widget.day]['slots'].length,
                itemBuilder: (context, index) {
                  var slot = appProvider.barberAvailability[widget.day]['slots']
                      [index];
                  return Consumer<AppProvider>(
                      builder: (context, provider, child) {
                    return ListTile(
                      subtitle: slot['isBooked'] ? Text('Booked') : Text(''),
                      title: Text(
                          'Slot Time:      ${DateFormat('hh : mm').format(DateTime.parse(slot['start']))} - ${DateFormat('hh : mm').format(DateTime.parse(slot['end']))}'),
                      trailing: Switch(
                        value: slot['isAvailable'],
                        onChanged: slot['isBooked']
                            ? null
                            : (value) {
                                provider.updateBarberSlotsAvailability(
                                    day: widget.day,
                                    slotIndex: index,
                                    value: value);
                              },
                      ),
                    );
                  });
                }));
  }
}

// class _ManageSlotsState extends State<ManageSlots> {
 

  

  

