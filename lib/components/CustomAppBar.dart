import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trim_time/colors/custom_colors.dart';

PreferredSizeWidget CustomAppBar(
    {String title = '',
    Widget? rightIcon,
    bool showYellowBg = true,
    Widget? leftIcon}) {
  return AppBar(
    leadingWidth: 80,
    leading: leftIcon ?? Container(),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
        color: CustomColors.white, fontSize: 18, fontWeight: FontWeight.w500),
    backgroundColor:
        showYellowBg ? CustomColors.peelOrange : CustomColors.gunmetal,
    surfaceTintColor: Colors.amber,
    title: Text(
      '$title',
    ),
    actions: [rightIcon ?? Container()],
  );
}
