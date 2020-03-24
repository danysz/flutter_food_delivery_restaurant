import 'package:flutter/material.dart';
import 'package:great_homies_chef/main.dart';

//This Package contains the widgets for all the Form related widgets
typedef CallBackString(String val);

TextFormField getTextFormField({
  @required BuildContext context,
  @required TextEditingController controller,
  @required String strHintText,
  @required String strLabelText,
  Color textColor,
  Color fillColor,
  int maxLines,
  TextInputType keyboardType,
  CallBackString validator,
  CallBackString onChanged,
  VoidCallback onTap,
}) {
  return TextFormField(
    controller: controller,
    decoration: new InputDecoration(
      hintText: strHintText,
      fillColor: fillColor == null ? Colors.white : fillColor,
      hintStyle: myAppTheme.textTheme.bodyText1,
      labelText: strLabelText,
      labelStyle: myAppTheme.textTheme.bodyText1,
      enabledBorder: const UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
      ),
    ),
    keyboardType: keyboardType == null ? TextInputType.text : keyboardType,
    style: myAppTheme.textTheme.bodyText1,
    maxLines: maxLines == null ? 1 : maxLines,
    validator: (val) => validator(val),
    onChanged: (val) => onChanged(val),
    onTap: () => onTap(),
  );
}
