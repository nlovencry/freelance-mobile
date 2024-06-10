import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mata/common/base/base_controller.dart';
import 'package:mata/common/helper/constant.dart';
import 'package:mata/src/work_order/wo_realization/model/wo_dropdown.dart';
import 'package:mata/src/work_order/wo_realization/model/wo_realization_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../../../../common/base/base_response.dart';
import '../../../../common/component/custom_button.dart';
import '../../../../common/component/custom_container.dart';
import '../../../../common/component/custom_dialog.dart';
import '../../../../common/component/custom_navigator.dart';
import '../../../../common/helper/encrypt.dart';
import '../../../../common/helper/multipart.dart';
import '../../../../utils/utils.dart';

class DataAddProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> dataAddKey = GlobalKey<FormState>();

  TextEditingController genBearingKoplingC = TextEditingController();
  TextEditingController koplingTurbinC = TextEditingController();
  TextEditingController totalC = TextEditingController();
  TextEditingController rasioC = TextEditingController();

  String? selectedDropdown;
  List<String> dropdownList = [
    "Upper",
    "Clutch",
    "Turbine",
  ];
  List<int> selectedUpper = [];
}
