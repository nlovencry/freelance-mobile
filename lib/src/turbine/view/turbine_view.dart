import 'dart:async';

import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_container.dart';
import 'package:mata/common/component/custom_textfield.dart';
import 'package:mata/src/data/view/data_add_upper_view.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/base/base_state.dart';
import '../../../../common/component/custom_loading_indicator.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../../shaft/view/shaft_detail_view.dart';
import '../model/turbine_model.dart';
import '../provider/turbine_provider.dart';

class TurbineView extends StatefulWidget {
  @override
  State<TurbineView> createState() => _TurbineViewState();
}

class _TurbineViewState extends BaseState<TurbineView> {
  @override
  void initState() {
    final turbineP = context.read<TurbineProvider>();
    turbineP.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => turbineP.fetchTurbine(page: pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final turbineP = context.watch<TurbineProvider>();
    final pagingC = context.watch<TurbineProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: turbineP.turbineSearchC,
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
            if (turbineP.searchOnStoppedTyping != null) {
              turbineP.searchOnStoppedTyping!.cancel();
            }
            turbineP.searchOnStoppedTyping = Timer(turbineP.duration, () {
              pagingC.refresh();
            });
          },
        );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "Turbine List",
        titleSpacing: 20,
        isLeading: false,
      ),
      body: SafeArea(
        child: Container(
          padding:
              EdgeInsets.fromLTRB(20, 0, 20, kBottomNavigationBarHeight - 42),
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
                Text("Turbine List",
                    style: Constant.grayMedium.copyWith(
                        color: Colors.black38, fontWeight: FontWeight.w500)),
                Constant.xSizedBox16,
                Flexible(
                  child: PagedListView.separated(
                    shrinkWrap: true,
                    pagingController: pagingC,
                    padding: EdgeInsets.fromLTRB(4, 18, 4, 20),
                    separatorBuilder: (_, __) => Constant.xSizedBox16,
                    builderDelegate:
                        PagedChildBuilderDelegate<TurbineModelData>(
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
                      itemBuilder: (context, item, indexs) {
                        return InkWell(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            turbineP.turbineSearchC.clear();
                            final f = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShaftDetailView(id: item.Id ?? '')));
                            if (f != null) {
                              pagingC.refresh();
                            }

                            // turbineP.turbineModelData =
                            //     TurbineModelData();
                          },
                          child: CustomContainer.mainCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.TowerName ?? "-",
                                              style: Constant.blackBold),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                    Constant.xSizedBox4,
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${DateFormat('dd/MM/yyyy  |  HH : mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(item.CreatedAt ?? '${DateTime.now()}'))}',
                                            style: Constant.grayRegular,
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: 7),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Constant.xSizedBox12,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
