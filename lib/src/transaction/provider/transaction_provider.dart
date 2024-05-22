import 'dart:convert';
import 'dart:developer';

import 'package:bimops/common/base/base_controller.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:bimops/src/transaction/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionProvider extends BaseController with ChangeNotifier {
  String isSubAgent = "agen";
  String get getIsSubAgent => this.isSubAgent;
  TransactionModel transactionModel = TransactionModel();

  TransactionModel get getTransactionModel => this.transactionModel;

  set setTransactionModel(TransactionModel transactionModel) =>
      this.transactionModel = transactionModel;
  set setIsSubAgent(String isSubAgent) => this.isSubAgent = isSubAgent;

  Future<void> fetchTransaction({bool withLoading = false}) async {
    log("IS SUB AGENT : $getIsSubAgent");
    if (withLoading) loading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setIsSubAgent = prefs.getString(Constant.kSetPrefRoles) ?? "agen";

    final response = await get(Constant.BASE_API_FULL + '/transaction');

    if (response.statusCode == 201 || response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setTransactionModel =
          TransactionModel.fromJson(jsonDecode(response.body));
      notifyListeners();

      if (withLoading) loading(false);
      // return model;
    } else {
      final message = jsonDecode(response.body)["message"];
      loading(false);
      throw Exception(message);
    }
  }
}
