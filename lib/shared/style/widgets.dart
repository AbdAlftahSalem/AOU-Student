import 'package:aou_online_platform/shared/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget textFormBox({
  required var nameController,
  required String labelText,
  required String hintText,
  required TextInputType textInputType,
  var validator,
  var onChanged,
  var iconPress,
  int ?maxLines = 1,
  bool isObscureText = false,
  IconData icon = Icons.title,
  bool iconOn = false,
  bool readOnly = false,
}) {
  return TextFormField(
    keyboardType: textInputType,
    controller: nameController,
    obscureText: isObscureText,
    validator: validator,
    readOnly: readOnly,
    decoration: InputDecoration(
      suffixIcon: iconOn == true
          ? IconButton(
              icon: Icon(icon),
              onPressed: iconPress,
            )
          : null,
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
      hintText: hintText,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1)),
    ),
    onChanged: onChanged,
    maxLines: maxLines,
  );
}

Widget textCustom({
  required String text,
  FontWeight fontWeight = FontWeight.normal,
  double fontSize = 16,
  Color textColor = Colors.black,
}) =>
    Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: textColor,
      ),
    );

Widget defaultButton({
  required String text,
  required var function,
  required Color background,
  Color textColor = Colors.white,
  double textSize = 16.0,
}) =>
    MaterialButton(
      onPressed: function,
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: textSize,
        ),
      ),
    );

Widget svg({
  required String svgImage,
  double width = 250,
}) =>
    SvgPicture.asset(
      svgImage,
      width: width,
    );

Widget circularProgress() => Dialog(
  backgroundColor: Colors.transparent,
  child: Center(child: CircularProgressIndicator()),
);
