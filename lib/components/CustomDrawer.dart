import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trim_time/colors/custom_colors.dart';
import 'package:trim_time/providers/sample_provider.dart';
import 'package:trim_time/utilities/helpers/functions.dart';
import 'package:trim_time/views/editProfile/edit_profile.dart';
import 'package:trim_time/views/faq/faq.dart';
import 'package:trim_time/views/rateApp/rate_app.dart';
import 'package:trim_time/views/sign_in/sign_in.dart';
import 'package:trim_time/views/supportAndFeedback/support_and_feedback.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Drawer(
      backgroundColor: CustomColors.gunmetal,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.only(top: 100, bottom: 10),
            decoration: const BoxDecoration(
              color: CustomColors.peelOrange,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<AppProvider>(builder: (context, provider, child) {
                  return provider.profileImageInBytes != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              MemoryImage(appProvider.profileImageInBytes!))
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(appProvider
                              .localDataInProvider['userData']['photoURL']),
                        );
                }),
                // appProvider.profileImageInBytes != null
                //     ? CircleAvatar(
                //         radius: 60,
                //         backgroundImage:
                //             MemoryImage(appProvider.profileImageInBytes!))
                //     : CircleAvatar(
                //         radius: 60,
                //         backgroundImage: NetworkImage(appProvider
                //             .localDataInProvider['userData']['photoURL']),
                //       ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${capitalizeFirstLetterOfEachWord(appProvider.localDataInProvider['userData']['name'])}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${appProvider.localDataInProvider['userData']['email']}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          //DrawerHeader
          Container(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                DrawerItem(
                  icon: const Icon(Icons.person, color: CustomColors.white),
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileClient()),
                    );
                  },
                ),
                DrawerItem(
                  icon: const Icon(Icons.support_agent_outlined,
                      color: CustomColors.white),
                  title: 'Customer Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SupportAndFeedback()),
                    );
                  },
                ),
                DrawerItem(
                  icon: const Icon(Icons.star_rate_rounded,
                      color: CustomColors.white),
                  title: 'Rate App',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RateApp()),
                    );
                  },
                ),
                DrawerItem(
                  icon: const Icon(Icons.question_answer_rounded,
                      color: CustomColors.white),
                  title: 'FAQs',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQScreen()),
                    );
                  },
                ),
                DrawerItem(
                  icon: const Icon(Icons.logout, color: CustomColors.white),
                  title: 'Logout',
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        titlePadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        backgroundColor: CustomColors.charcoal,
                        title: const Text(
                          "Are You Sure You Want To Logout?",
                          style: TextStyle(
                            color: CustomColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.peelOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: CustomColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await appProvider.handleLogoutByProvider();

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const SignIn()),
                                    (Route route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.peelOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: CustomColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  final Widget icon;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        color: Colors.transparent,
        height: 54,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 14,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
