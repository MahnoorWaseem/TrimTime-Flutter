import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/controller/login.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/authentication/signup_page.dart';

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
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () async {
          sampleProvider.setLoading(true);

          await updateBarberAvailabilityInFireStore(
            barberId: sampleProvider.uid,
            data: sampleProvider.barberAvailability,
          );

          await updateUserDataInLocalStorage(
              data:
                  await getUserDataFromFirestore(sampleProvider.uid, isClient));

          sampleProvider.setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Slots updated successfully'),
              duration: Duration(seconds: 1),
            ),
          );
        }, child: Consumer<SampleProvider>(
          builder: (context, provider, child) {
            return provider.updateAvailabilityCIP
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
                          provider.updateBarberAvailability(
                              day: widget.day, slotIndex: index, value: value);
                        },
                      ),
                    );
                  });
                }));
  }
}

// class _ManageSlotsState extends State<ManageSlots> {
 

  

  

