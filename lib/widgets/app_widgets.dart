import 'package:flutter/material.dart';

class AppWidgets {
  static Widget textField({
    required TextEditingController controller,
    required Function(String) onChanged,
    required TextInputType keyboardType,
    required int maxLength,
    required String hint,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool enabled = true,
    bool autofocus = false,
    Color borderColor = Colors.black,
    TextStyle? textStyle,
    TextStyle? hintTextStyle,
    double height = 48,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: height,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              // color: backgroundColor,
              border:
                  Border.all(color: borderColor, width: 1), // set border width
              borderRadius: const BorderRadius.all(
                  Radius.circular(8.0)), // set rounded corner radius
            ),
            child: TextFormField(
              textCapitalization: textCapitalization,
              enabled: enabled,
              autofocus: autofocus,
              controller: controller,
              onChanged: onChanged,
              // maxLines: isObscureText ? 1 : null,
              style: textStyle ??
                  const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Proxima Nova",
                  ),
              decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: hintTextStyle ??
                      const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Proxima Nova",
                      ),
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon),
            ),
          ),
        ),
      ],
    );
  }
}
