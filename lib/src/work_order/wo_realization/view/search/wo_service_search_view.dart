import 'package:mata/common/component/custom_appbar.dart';
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
import '../../provider/wo_realization_provider.dart';

class WOServiceSearchView extends StatefulWidget {
  const WOServiceSearchView({super.key});
  @override
  State<WOServiceSearchView> createState() => _WOServiceSearchViewState();
}

class _WOServiceSearchViewState extends BaseState<WOServiceSearchView> {
  @override
  void initState() {
    final woTP = context.read<WORealizationProvider>();
    woTP.pWoServiceController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => woTP.fetchWOServiceSearch(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final woServiceP = context.watch<WORealizationProvider>();
    final pagingC = context.watch<WORealizationProvider>().pWoServiceController;

    Widget search() => CustomTextField.borderTextField(
          controller: woServiceP.woServiceSearchC,
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
      appBar: CustomAppBar.appBar(context, "Search Service"),
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
                  child: Text("Select Service",
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
                    builderDelegate:
                        PagedChildBuilderDelegate<WOServiceSearchModelData>(
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
