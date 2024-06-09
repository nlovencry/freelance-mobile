import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_navigator.dart';
import 'package:mata/src/work_order/wo_realization/provider/wo_realization_provider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../../common/base/base_state.dart';
import '../../../../../common/component/custom_loading_indicator.dart';
import '../../../../../common/component/custom_textfield.dart';
import '../../../../../common/helper/constant.dart';
import '../../../../../utils/utils.dart';
import '../../model/wo_search.dart';

class WOPersonilSearchView extends StatefulWidget {
  const WOPersonilSearchView({super.key});
  @override
  State<WOPersonilSearchView> createState() => _WOPersonilSearchViewState();
}

class _WOPersonilSearchViewState extends BaseState<WOPersonilSearchView> {
  @override
  void initState() {
    final woTP = context.read<WORealizationProvider>();
    woTP.clearAllListPersonil();
    woTP.pWoPersonilController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => woTP.fetchWOPersonilSearch(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final woPersonilP = context.watch<WORealizationProvider>();
    final pagingC =
        context.watch<WORealizationProvider>().pWoPersonilController;

    Widget search() => CustomTextField.borderTextField(
          controller: woPersonilP.woPersonilSearchC,
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
            pagingC.refresh();
          },
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "Search Personil",
        action: [
          InkWell(
              onTap: () async {
                if (woPersonilP.boolListPersonil.any((e) => e == true)) {
                  await woPersonilP.addListPersonil();
                  CusNav.nPop(
                    context,
                    woPersonilP.listPersonilSelected
                        .map((e) => e.nip)
                        .toList()
                        .join(','),
                    // woPersonilP.listPersonilSelectedNip
                    //     .map((e) => e.nip)
                    //     .toList()
                    //     .join(','),
                  );
                }
              },
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 24, 0),
                  child: Text("Selesai",
                      style: Constant.blueBold12.copyWith(fontSize: 14))))
        ],
      ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Personil",
                          style: Constant.grayMedium.copyWith(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500)),
                      // Checkbox(
                      //   value: woPersonilP.allPersonilSelected,
                      //   activeColor: Constant.primaryColor,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       woPersonilP.allPersonilSelected = value ?? false;
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ),
                Flexible(
                  child: PagedListView.separated(
                    shrinkWrap: true,
                    pagingController: pagingC,
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 18),
                    separatorBuilder: (_, __) =>
                        Divider(thickness: 1, color: Constant.textHintColor),
                    builderDelegate:
                        PagedChildBuilderDelegate<WOPersonilSearchModelData>(
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
                        var personilItem = woPersonilP.boolListPersonil[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              woPersonilP.boolListPersonil[index] =
                                  !woPersonilP.boolListPersonil[index];
                            });
                          },
                          // onTap: () => Navigator.pop(context, item),
                          child: Container(
                            height: 80,
                            color: personilItem
                                ? Constant.tableBlueColor
                                : Colors.white,
                            width: 100.w,
                            // margin:
                            //     EdgeInsets.only(left: 20, right: 20, top: 10),
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 12, bottom: 12),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: woPersonilP.boolListPersonil[index],
                                  activeColor: Constant.primaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      woPersonilP.boolListPersonil[index] =
                                          value ?? false;
                                      // if (value == true &&
                                      //     woPersonilP.boolListPersonil.any(
                                      //         (element) => element == false)) {
                                      //   woPersonilP.allPersonilSelected = true;
                                      // }
                                      // if (value == false &&
                                      //     woPersonilP.boolListPersonil.any(
                                      //         (element) => element == true)) {
                                      //   woPersonilP.allPersonilSelected = false;
                                      // }
                                      // if (!woPersonilP.boolListPersonil
                                      //     .any((element) => element != value)) {
                                      //   woPersonilP.allPersonilSelected =
                                      //       value ?? false;
                                      // }
                                    });
                                  },
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name ?? "",
                                        style: Constant.blackBold),
                                    Text(item.jabatan ?? "",
                                        style: Constant.grayRegular12),
                                  ],
                                ),
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
