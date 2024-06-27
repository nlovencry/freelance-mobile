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
    bool isDense = false,
    Color? fillColor,
    Color? borderColor,
    String? selectedItem,
    Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> list,
    TextEditingController? controller,
    TextAlign? inputAlign,
    CrossAxisAlignment align = CrossAxisAlignment.start,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? iconPadding,
    double? labelFontSize,
    FormFieldValidator? validator,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 0),
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
          DropdownButtonFormField(
            isDense: isDense,
            padding: EdgeInsets.zero,
            items: readOnly ? null : list,
            onChanged: readOnly ? null : onChanged,
            onSaved: (val) => FocusManager.instance.primaryFocus?.unfocus(),
            icon: Padding(
              padding: iconPadding ?? const EdgeInsets.fromLTRB(16, 0, 12, 0),
              child: Icon(Icons.keyboard_arrow_down,
                  color: Constant.textHintColor2, size: 24),
            ),
            // style: Constant.primaryTextStyle,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: contentPadding ?? EdgeInsets.zero,
              hintText: hintText ?? "",
              isDense: isDense,
              hintStyle: TextStyle(color: Constant.textHintColor2),
              filled: true,
              enabled: enabled,
              fillColor: fillColor ??
                  (enabled ? Colors.white : Constant.textHintColor),
              suffixIconColor: Constant.primaryColor,
              hoverColor: Constant.primaryColor,
              focusColor: Constant.primaryColor,
              prefix: SizedBox(width: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 0.5,
                  color: borderColor ?? Constant.borderSearchColor,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 0.5,
                  color: borderColor ?? Constant.borderSearchColor,
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 1,
                  color: borderColor ?? Constant.primaryColor,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            hint: Text(hintText ?? ""),
            value: selectedItem,
            validator: (value) {
              if (validator != null) {
                if (required && value?.isNotEmpty != true) {
                  return 'Harap isi $labelText';
                }
              }
              return null;
            },
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
