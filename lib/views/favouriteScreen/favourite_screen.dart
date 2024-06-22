import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/components/CustomAppBar.dart';
import 'package:trim_time/components/EmptyList.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/views/barber_listing/barber_listing.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    SampleProvider sampleProvider =
        Provider.of<SampleProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Your Favourite Barbers',
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        color: CustomColors.gunmetal,
        child: Consumer<SampleProvider>(
          builder: (context, provider, child) {
            return sampleProvider.inAppfavouriteList.isEmpty
                ? EmptyList(
                    message: 'You have not Favourited any Barber yet.',
                  )
                : ListView.builder(
                    itemCount: provider.inAppfavouriteList.length,
                    itemBuilder: (context, index) {
                      final barber = provider.inAppfavouriteList[index];
                      return BarberCard(
                        barberId: barber['uid'],
                        barberName: barber['name'],
                        shopName: barber['shopName'],
                        stars: '5',
                        imageUrl: barber['photoURL'],
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
