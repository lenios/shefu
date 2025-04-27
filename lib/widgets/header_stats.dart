import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildHeaderStat(
  BuildContext context, {
  String? iconPath,
  IconData? iconData,
  required int value,
  required String unit,
  Color color = Colors.white,
}) {
  if (value == 0) return Container();

  Widget iconWidget;
  if (iconPath != null) {
    iconWidget = SvgPicture.asset(
      iconPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: 16,
      height: 16,
    );
  } else if (iconData != null) {
    iconWidget = Icon(iconData, size: 16, color: color);
  } else {
    return Container();
  }

  return Row(
    children: [
      iconWidget,
      const SizedBox(width: 2),
      Text("$value $unit", style: TextStyle(color: color, fontSize: 12)),
    ],
  );
}
