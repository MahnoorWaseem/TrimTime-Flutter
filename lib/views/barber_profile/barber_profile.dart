import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/carousel.dart';
import 'package:trim_time/components/reviewBox.dart';
import 'package:trim_time/components/servicesContainer.dart';
import 'package:trim_time/components/timeSlotBox.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/helpers/functions.dart';
import 'package:trim_time/views/appointment_summary/appointment_summary.dart';

class BarberProfile extends StatefulWidget {
  const BarberProfile({super.key});

  @override
  State<BarberProfile> createState() => _BarberProfileState();
}

class _BarberProfileState extends State<BarberProfile> {
  late bool isFavourite;

  bool clicked = false;
  var selectedService = null; //req for make an appointment
  var selectedDate = null; //req for make an appointment
  var selectedDay = null;

  int selectedIndex = -1;
  var selectedtime = null; //req for make an appointment
  List<String> selectedServices = [];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    String selectedBarberId = appProvider.selectedBarber['uid'];
    List services = appProvider.getBarberServicesForBarberProfile();
    appProvider.resetIsSlotTileExpanded();

    print('services in widgett ----> $services');

    print('selected barber ----> ${appProvider.selectedBarber['uid']}');

    return Scaffold(
      backgroundColor: CustomColors.gunmetal,
      body: Stack(
        children: [
          // Scrollable background content
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //1.Carousel
              Container(
                  height: 250,
                  color: Colors.transparent,
                  child: ImageCarousel()),
              // const SizedBox(
              //   height: 50,
              // ),
              // Align(
              //   alignment: Alignment.center,
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(100),
              //     child: Image.network(
              //       appProvider.selectedBarber['photoURL'],
              //       width: 170,
              //       height: 170,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 24,
              ),

              //2. Name
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      capitalizeFirstLetterOfEachWord(
                          appProvider.selectedBarber['name']),
                      style: const TextStyle(
                        fontSize: 24,
                        color: CustomColors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,

                        // fontFamily: 'Raleway'
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Consumer<AppProvider>(
                          builder: (context, provider, Widget? child) {
                        isFavourite = appProvider.allBarbers.firstWhere(
                            (element) =>
                                element['uid'] ==
                                selectedBarberId)['isFavourite'];
                        return GestureDetector(
                          onTap: () async {
                            if (isFavourite) {
                              print('remove fav');
                              appProvider
                                  .removeBarberFromFavourites(selectedBarberId);
                            } else {
                              print('add fav');
                              appProvider
                                  .addBarberToFavourites(selectedBarberId);
                            }
                          },
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite ? Colors.red : Colors.white,
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),

              //3. Salon Name
              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.store_mall_directory,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      capitalizeFirstLetterOfEachWord(
                          appProvider.selectedBarber['shopName']),
                      style: const TextStyle(
                          color: CustomColors.white,
                          fontSize: 14,
                          // fontFamily: 'Raleway',
                          letterSpacing: 1),
                    )
                  ],
                ),
              ),

              //4. Address
              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.pin,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        capitalizeFirstLetterOfEachWord(
                            appProvider.selectedBarber['shopAddress']),
                        style: const TextStyle(
                          color: CustomColors.white,
                          fontSize: 14,
                          // fontFamily: 'Raleway',
                          letterSpacing: 1,
                        ),
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),

              //5. phone

              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      appProvider.selectedBarber['phoneNumber'],
                      style: const TextStyle(
                          color: CustomColors.white,
                          fontSize: 14,
                          // fontFamily: 'Raleway',
                          letterSpacing: 1),
                    ),
                  ],
                ),
              ),

              //6. rating
              const SizedBox(
                height: 10,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_half_outlined,
                      color: CustomColors.peelOrange,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      appProvider.selectedBarber['averageRating'],
                      style: const TextStyle(
                          color: CustomColors.white,
                          fontSize: 14,
                          // fontFamily: 'Raleway',
                          letterSpacing: 1),
                    ),
                    Text(
                      ' (${appProvider.selectedBarber['reviews'].length} Reviews)',
                      style: const TextStyle(
                          color: CustomColors.white,
                          fontSize: 14,
                          // fontFamily: 'Raleway',
                          letterSpacing: 1),
                    )
                  ],
                ),
              ),
              //7. Services
              const SizedBox(
                height: 24,
              ),

              // const Divider(
              //   color: CustomColors.charcoal,
              // ),

              Container(
                padding: const EdgeInsets.only(left: 16),
                child: const Text(
                  'Select Service',
                  style: TextStyle(
                      // fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white),
                ),
              ),

              //services boxes
              const SizedBox(
                height: 12,
              ),

              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Consumer<AppProvider>(
                        builder: (context, provider, child) {
                      return Services(
                        isFirstCard: index == 0,
                        service: services[index],
                        isSelected: provider.selectedService ==
                            services[index]['serviceId'],
                        imageFileName: services[index]['imageFileName'],
                        // onTap: provider.updateSelectedService(
                        //     services[index]['serviceId']),
                      );
                    });
                  },
                  itemCount: services.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              //8. date

              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Date',
                      style: TextStyle(
                          // fontFamily: 'Raleway',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.white),
                    ),
                    Consumer<AppProvider>(builder: (context, provider, child) {
                      return InkWell(
                        onTap: () async {
                          DateTime? selected = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 6),
                            ),
                            initialDate:
                                appProvider.selectedDate ?? DateTime.now(),
                          );

                          print('DAte selected ----> $selected');

                          if (selected != null) {
                            appProvider.updateSelectedDate(selected);
                            appProvider.updateSlotsToShow();
                          }
                          print(
                              'DAte selected in provider ----> ${appProvider.selectedDate}');
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: CustomColors.white,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    // height: 70,
                    decoration: const BoxDecoration(
                        color: CustomColors.charcoal,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Consumer<AppProvider>(
                        builder: (context, provider, child) {
                          var date = DateFormat('EEEE, dd-MM-yyyy')
                              .format(provider.selectedDate);
                          return Text(
                            provider.selectedDate == null
                                ? 'No Day Selected'
                                : 'Schedule Booking on $date',
                            style: const TextStyle(
                              color: CustomColors.white,
                              // fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    )),
              ),

              //9. Time

              const SizedBox(
                height: 24,
              ),

              Container(
                padding: const EdgeInsets.only(left: 16),
                child: const Text(
                  'Select Time',
                  style: TextStyle(
                      // fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                // height: 70,
                decoration: const BoxDecoration(
                    color: CustomColors.charcoal,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child:
                    Consumer<AppProvider>(builder: (context, provider, child) {
                  var day = DateFormat('EEEE').format(provider.selectedDate);

                  // List slots = provider.slotsToShow;
                  List slots = provider.getSlotsToShow();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: provider.selectedDate == null
                        ? const Center(
                            child: Text(
                              'No Day Selected',
                              style: TextStyle(
                                color: CustomColors.white,
                                // fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                          )
                        : slots.length == 0
                            ? Center(
                                child: Text(
                                  'Barber is not Available on $day',
                                  style: const TextStyle(
                                    color: CustomColors.white,
                                    // fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : Consumer<AppProvider>(
                                builder: (context, provider, child) {
                                return ExpansionTile(
                                  shape:
                                      const Border(), //to remove divider lines when expanded
                                  title: Text(
                                    day,
                                    style: const TextStyle(
                                      color: CustomColors.white,
                                      // fontFamily: 'Poppins',
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Icon(
                                    provider.isSlotTileExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: provider.isSlotTileExpanded
                                        ? CustomColors.peelOrange
                                        : CustomColors.peelOrange,
                                  ),
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                            child: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: List.generate(slots.length,
                                              (index) {
                                            return TimeSlot(
                                              slot: slots[index],
                                              isSelected: provider
                                                      .selectedSlot['slotId'] ==
                                                  slots[index]['slotId'],
                                            );
                                          }),
                                        )),
                                      ],
                                    )
                                  ],
                                  onExpansionChanged: (bool expanded) {
                                    provider.setIsSlotTileExpanded(expanded);
                                  },
                                );
                              }),
                  );
                }),
              ),

              const SizedBox(
                height: 24,
              ),

              Container(
                margin: const EdgeInsets.only(left: 16),
                child: const Text(
                  'Reviews',
                  style: TextStyle(
                      // fontFamily: 'Raleway',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              //Reviews

              appProvider.selectedBarber['reviews'].length == 0
                  ? const Center(
                      child: Text(
                        'No Reviews Yet',
                        style: TextStyle(
                          color: CustomColors.white,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Review(
                          ClientName: appProvider.selectedBarber['reviews']
                              [index]['clientName'],
                          review: appProvider.selectedBarber['reviews'][index]
                              ['review'],
                          rating: appProvider.selectedBarber['reviews'][index]
                              ['rating'],
                          isLastReview: index ==
                              appProvider.selectedBarber['reviews'].length - 1,
                        );
                      },
                      itemCount: appProvider.selectedBarber['reviews'].length,
                    ),

              //for space

              Container(
                height: 110,
                width: 200,
                color: CustomColors.transparent,
              ),
            ]),
          ),
          // Fixed position container

          Consumer<AppProvider>(builder: (context, provider, child) {
            return Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: CustomColors.gunmetal,
                height: 70,
                child: InkWell(
                  onTap: () async {
                    print('\n Booking Data ---------->');
                    print(
                        '\n Booking Date ----------> ${provider.selectedDate.toIso8601String()}');
                    print(
                        '\n Booking service ----------> ${provider.selectedService}');
                    print(
                        '\n Booking Slot ----------> ${provider.selectedSlot}');

                    if (provider.selectedSlot.isEmpty ||
                        provider.selectedService == '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            titlePadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            backgroundColor: CustomColors.charcoal,
                            title: Text(
                              provider.selectedService == ''
                                  ? 'Kindly select service.'
                                  : 'Kindly select time slot.',
                              style: TextStyle(
                                color: CustomColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.peelOrange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                                child: const Text(
                                  'Ok',
                                  style: TextStyle(
                                    color: CustomColors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    // }
                    else {
                      print('in else block');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppointmentSummary()),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 16, right: 16),
                    height: 50,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: CustomColors.peelOrange,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                      child: provider.createBookingCIP
                          ? const SpinKitFadingCircle(
                              color: CustomColors.charcoal,
                              size: 30.0,
                            )
                          : const Text(
                              'Book Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
