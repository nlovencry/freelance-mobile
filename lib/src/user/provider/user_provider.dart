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

class UserProvider extends BaseController with ChangeNotifier {
  GlobalKey<FormState> UserKey = GlobalKey<FormState>();

  TextEditingController searchC = TextEditingController();
  Duration duration = const Duration(seconds: 2);
  Timer? _searchOnStoppedTyping;
  Timer? get searchOnStoppedTyping => this._searchOnStoppedTyping;

  set searchOnStoppedTyping(Timer? value) {
    this._searchOnStoppedTyping = value;
    notifyListeners();
  }

  int currentIndex = 0;
  late TabController tabController;

  bool _loadingg = false;
  bool get loadingg => this._loadingg;

  set loadingg(bool value) => this._loadingg = value;

  simulateFetch() async {
    loadingg = true;
    notifyListeners();
    await Future.delayed(duration);
    notifyListeners();
    loadingg = false;
    notifyListeners();
  }

  List<String> role = ["User", "Admin"];
  String? roleSelected;

  TextEditingController nameC = TextEditingController();
  TextEditingController usernameC = TextEditingController();
  TextEditingController roleC = TextEditingController();
  TextEditingController divisionC = TextEditingController();
}
