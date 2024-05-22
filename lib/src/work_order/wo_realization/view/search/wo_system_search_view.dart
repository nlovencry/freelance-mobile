import 'package:bimops/common/component/custom_appbar.dart';
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

class WOSystemSearchView extends StatefulWidget {
  const WOSystemSearchView({super.key});
  @override
  State<WOSystemSearchView> createState() => _WOSystemSearchViewState();
}

class _WOSystemSearchViewState extends BaseState<WOSystemSearchView> {
  @override
  void initState() {
    final woTP = context.read<WORealizationProvider>();
    woTP.pWoSystemController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => woTP.fetchWOSystemSearch(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final woSystemP = context.watch<WORealizationProvider>();
    final pagingC = context.watch<WORealizationProvider>().pWoSystemController;

    Widget search() => CustomTextField.borderTextField(
          controller: woSystemP.woSystemSearchC,
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
      appBar: CustomAppBar.appBar(context, "Search System"),
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
                  child: Text("Select System",
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
                        PagedChildBuilderDelegate<WOSystemSearchModelData>(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${item.code ?? ""}.",
                                    style: Constant.blackBold),
                                Constant.xSizedBox16,
                                Text(item.name ?? "",
                                    style: Constant.blackBold),
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
