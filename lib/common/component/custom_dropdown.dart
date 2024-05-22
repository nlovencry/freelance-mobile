import 'package:flutter/material.dart';

import '../helper/constant.dart';
import '../helper/dropdown_search.dart';

class CustomDropdown {
  static Widget normalDropdown({
    String? labelText,
    String? hintText,
    int line = 1,
    TextInputType type = TextInputType.text,
    bool readOnly = false,
    bool required = true,
    bool enabled = true,
    Color? fillColor,
    String? selectedItem,
    Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> list,
    TextEditingController? controller,
    TextAlign? inputAlign,
    CrossAxisAlignment align = CrossAxisAlignment.start,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    labelText,
                    style: Constant.primaryTextStyle.copyWith(
                      fontSize: labelFontSize ?? 14,
                      fontWeight: Constant.medium,
                    ),
                  ),
                  required
                      ? Text(
                          '*',
                          style: Constant.primaryTextStyle.copyWith(
                            fontSize: labelFontSize ?? 14,
                            fontWeight: Constant.medium,
                            color: Colors.red,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          CustomDropdownSearch().dropdown2(
            label: labelText,
            hint: hintText ?? "",
            list: list,
            enabled: enabled,
            readOnly: readOnly,
            fillColor: fillColor,
            onChanged: onChanged,
            required: required,
            selectedItem: selectedItem,
          ),
        ],
      ),
    );
  }

  static Widget filterDropdown({
    String? labelText,
    String? hintText,
    int line = 1,
    TextInputType type = TextInputType.text,
    bool readOnly = false,
    bool required = false,
    String? selectedItem,
    Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> list,
    TextEditingController? controller,
    TextAlign? inputAlign,
    CrossAxisAlignment align = CrossAxisAlignment.start,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                labelText,
                style: Constant.primaryTextStyle.copyWith(
                  fontSize: labelFontSize ?? 14,
                  fontWeight: Constant.medium,
                ),
              ),
            ),
          CustomDropdownSearch().dropdownFilter(
            label: labelText,
            hint: hintText ?? "",
            list: list,
            onChanged: onChanged,
            required: required,
            selectedItem: selectedItem,
          ),
        ],
      ),
    );
  }

  static Widget searchDropdown({
    String? labelText,
    String? hintText,
    int line = 1,
    TextInputType type = TextInputType.text,
    bool readOnly = false,
    bool required = false,
    String? selectedItem,
    Function(String?)? onChanged,
    required List<String> list,
    TextEditingController? controller,
    TextAlign? inputAlign,
    CrossAxisAlignment align = CrossAxisAlignment.start,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        if (labelText != null)
          Text(
            labelText,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        CustomDropdownSearch().dropdownSearch(
          label: labelText,
          hint: hintText ?? "",
          list: list,
          onChanged: onChanged,
          required: required,
        ),
      ],
    );
  }
}
