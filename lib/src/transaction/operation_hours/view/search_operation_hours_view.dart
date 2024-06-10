import 'dart:async';

import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/src/transaction/asset_meter/provider/asset_meter_provider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/base/base_state.dart';
import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/component/custom_textfield.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../model/operation_hours_category_model.dart';
import '../provider/operation_hours_provider.dart';

class SearchOperationHoursView extends StatefulWidget {
  const SearchOperationHoursView({super.key});
  @override
  State<SearchOperationHoursView> createState() =>
      _SearchOperationHoursViewState();
}

class _SearchOperationHoursViewState
    extends BaseState<SearchOperationHoursView> {
  @override
  void initState() {
    final oHP = context.read<OperationHoursProvider>();
    oHP.pagingControllerCategory = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => oHP.fetchAssetCategory(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final assetMeterP = context.watch<OperationHoursProvider>();
    final pagingC =
        context.watch<OperationHoursProvider>().pagingControllerCategory;

    Widget search() => CustomTextField.borderTextField(
          controller: assetMeterP.assetSearchCategoryC,
          required: false,
          hintText: "Search",
          hintColor: Constant.textHintColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/ic-search.png',
              width: 5,
              height: 5,
            ),
          ),
          onChange: (val) {
            if (assetMeterP.searchOnStoppedTyping != null) {
              assetMeterP.searchOnStoppedTyping!.cancel();
            }
            assetMeterP.searchOnStoppedTyping = Timer(assetMeterP.duration, () {
              pagingC.refresh();
            });
          },
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Asset Meter Category"),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: RefreshIndicator(
            color: Constant.primaryColor,
            onRefresh: () async => pagingC.refresh(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                search(),
                Constant.xSizedBox16,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Select Asset Meter Category",
                      style: Constant.grayMedium.copyWith(
                          color: Colors.black38, fontWeight: FontWeight.w500)),
                ),
                Flexible(
                  child: PagedListView.separated(
                    shrinkWrap: true,
                    pagingController: pagingC,
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 18),
                    separatorBuilder: (_, __) =>
                        Divider(thickness: 1, color: Constant.textHintColor),
                    builderDelegate: PagedChildBuilderDelegate<
                        OperationHoursCategoryModelData>(
                      firstPageProgressIndicatorBuilder: (_) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 32),
                        child: CustomLoadingIndicator.buildIndicator(),
                      ),
                      newPageProgressIndicatorBuilder: (_) => Container(
                        color: Colors.white,
                        child: CustomLoadingIndicator.buildIndicator(),
                      ),
                      noItemsFoundIndicatorBuilder: (_) => Padding(
                        padding: const EdgeInsets.only(top: 56),
                        child: Utils.notFoundImage(),
                      ),
                      itemBuilder: (context, item, index) {
                        return InkWell(
                          onTap: () => Navigator.pop(context, item),
                          child: Container(
                            height: 80,
                            width: 100.w,
                            // margin:
                            //     EdgeInsets.only(left: 20, right: 20, top: 10),
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 12, bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name ?? "",
                                    style: Constant.blackBold),
                                Text(item.code ?? "",
                                    style: Constant.grayRegular12),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
