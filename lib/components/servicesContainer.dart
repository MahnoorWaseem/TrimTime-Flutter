import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';

class Services extends StatelessWidget {
  final bool isSelected;
  final Map service;
  final bool isFirstCard;
  final String imageFileName;

  const Services({
    Key? key,
    required this.service,
    required this.isSelected,
    required this.isFirstCard,
    required this.imageFileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        appProvider.updateSelectedService(service['serviceId']);
      },

      // appProvider.updateSelectedService(service['serviceId']),
      child: Container(
        height: 160,
        width: 120,
        margin: EdgeInsets.only(right: 10, left: isFirstCard ? 16 : 0),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.peelOrange : CustomColors.charcoal,
          border: Border.all(color: CustomColors.peelOrange.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 94,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: CustomColors.white),
                child: Image.asset(
                  'assets/images/$imageFileName',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              service['serviceName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.white,
                // fontFamily: 'Raleway',
              ),
            ),
            Text(
              service['price'].toString(),
              style: TextStyle(
                color: CustomColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
