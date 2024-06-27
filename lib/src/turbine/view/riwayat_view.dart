import 'dart:developer';
import 'package:mata/common/component/custom_button.dart';
import 'package:mata/common/component/custom_container.dart';
import 'package:mata/common/component/custom_date_picker.dart';

import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_textfield.dart';
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

class RiwayatView extends StatefulWidget {
  @override
  State<RiwayatView> createState() => _RiwayatViewState();
}

class _RiwayatViewState extends BaseState<RiwayatView> {
  @override
  void initState() {
    final turbineP = context.read<TurbineProvider>();
    turbineP.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(
          (pageKey) => turbineP.fetchTurbine(page: pageKey));
    // turbineP.fetchTurbine(withLoading: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final turbineP = context.watch<TurbineProvider>();
    final turbineData =
        context.watch<TurbineProvider>().turbineModel.Data ?? [];
    final pagingC = context.watch<TurbineProvider>().pagingController;

    Widget search() => CustomTextField.borderTextField(
          controller: turbineP.turbineSearchC,
          required: false,
          hintText: "Cari Riwayat",
          hintColor: Constant.textHintColor2,
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
            // turbineP.searchOnStoppedTyping = Timer(turbineP.duration, () async {
            //   await context
            //       .read<TurbineProvider>()
            //       .fetchTurbine(withLoading: true);
            pagingC.refresh();
            // });
          },
        );

    Widget filterAllWidget() => StatefulBuilder(
            builder: (BuildContext context, StateSetter sheetState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter',
                  style: Constant.iPrimaryMedium14
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 24),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 5,
                            child: CustomTextField.borderTextField(
                              controller: turbineP.startDateC,
                              labelText: "Start Date",
                              hintText: "Start Date",
                              required: true,
                              readOnly: true,
                              onTap: () async {
                                await turbineP.setStartDate(
                                    await CustomDatePicker.pickDate(
                                        context, DateTime.now()));
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              suffixIcon: Icon(Icons.calendar_month),
                              suffixIconColor: Constant.textHintColor,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: CustomTextField.borderTextField(
                            controller: turbineP.endDateC,
                            labelText: "End Date",
                            hintText: "End Date",
                            required: true,
                            readOnly: true,
                            onTap: () async {
                              await turbineP.setEndDate(
                                  await CustomDatePicker.pickDate(
                                      context, DateTime.now()));
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            suffixIcon: Icon(Icons.calendar_month),
                            suffixIconColor: Constant.textHintColor,
                          ),
                        ),
                      ],
                    ),
                    Constant.xSizedBox16,
                    Text('Sort Order'),
                    Wrap(
                      children: [
                        FilterChip(
                          selectedColor: Constant.primaryColor,
                          backgroundColor: Colors.white,
                          showCheckmark: false,
                          labelStyle: TextStyle(
                              color: turbineP.ascending
                                  ? Colors.white
                                  : Constant.primaryColor),
                          side: BorderSide(color: Constant.primaryColor),
                          label: Text('Ascending'),
                          selected: turbineP.ascending,
                          onSelected: (value) {
                            context.read<TurbineProvider>().ascending = true;
                            context.read<TurbineProvider>().descending = false;
                            sheetState(() {});
                          },
                        ),
                        Constant.xSizedBox16,
                        FilterChip(
                          selectedColor: Constant.primaryColor,
                          backgroundColor: Colors.white,
                          showCheckmark: false,
                          labelStyle: TextStyle(
                              color: turbineP.descending
                                  ? Colors.white
                                  : Constant.primaryColor),
                          side: BorderSide(color: Constant.primaryColor),
                          label: Text('Descending'),
                          selected: turbineP.descending,
                          onSelected: (value) {
                            context.read<TurbineProvider>().descending = true;
                            context.read<TurbineProvider>().ascending = false;
                            sheetState(() {});
                          },
                        ),
                      ],
                    ),
                    Constant.xSizedBox16,
                    Text('Sort By'),
                    Wrap(
                      children: [
                        FilterChip(
                          selectedColor: Constant.primaryColor,
                          backgroundColor: Colors.white,
                          showCheckmark: false,
                          labelStyle: TextStyle(
                              color: turbineP.towerName
                                  ? Colors.white
                                  : Constant.primaryColor),
                          side: BorderSide(color: Constant.primaryColor),
                          label: Text('Tower Name'),
                          selected: turbineP.towerName,
                          onSelected: (value) {
                            context.read<TurbineProvider>().towerName = true;
                            context.read<TurbineProvider>().createdAt = false;
                            sheetState(() {});
                          },
                        ),
                        Constant.xSizedBox16,
                        FilterChip(
                          selectedColor: Constant.primaryColor,
                          backgroundColor: Colors.white,
                          showCheckmark: false,
                          labelStyle: TextStyle(
                              color: turbineP.createdAt
                                  ? Colors.white
                                  : Constant.primaryColor),
                          side: BorderSide(color: Constant.primaryColor),
                          label: Text('Created At'),
                          selected: turbineP.createdAt,
                          onSelected: (value) {
                            context.read<TurbineProvider>().createdAt = true;
                            context.read<TurbineProvider>().towerName = false;
                            sheetState(() {});
                          },
                        ),
                      ],
                    ),
                    Constant.xSizedBox16,
                  ],
                ),
              ),
              CustomButton.mainButton("View Result", () {
                Navigator.pop(context);
                pagingC.refresh();
                turbineP.clearDate();
              }),
            ],
          );
        });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
        context,
        "Riwayat",
        textStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        titleSpacing: 20,
        isLeading: false,
        color: Constant.primaryColor,
      ),
      body: SafeArea(
        child: Container(
          padding:
              EdgeInsets.fromLTRB(20, 10, 20, kBottomNavigationBarHeight - 42),
          color: Colors.transparent,
          child: RefreshIndicator(
            color: Constant.primaryColor,
            // onRefresh: () async => await context
            //     .read<TurbineProvider>()
            //     .fetchTurbine(withLoading: true),
            onRefresh: () async => pagingC.refresh(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Constant.xSizedBox16,
                search(),
                Constant.xSizedBox16,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Filter",
                          style: Constant.grayMedium.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                      InkWell(
                        onTap: () async {
                          CustomContainer.showModalBottomScroll(
                              context: context, child: filterAllWidget());
                        },
                        child: Container(
                          height: 30,
                          width: 60,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_alt_outlined, size: 20),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, size: 15)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Constant.xSizedBox8,
                Flexible(
                  child: PagedListView.separated(
                    shrinkWrap: true,
                    // itemCount: turbineData.length,
                    pagingController: pagingC,
                    padding: EdgeInsets.fromLTRB(0, 18, 0, 20),
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
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${DateFormat('HH : mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(item?.CreatedAt ?? '${DateTime.now()}'))}',
                                      style: Constant.blackRegular12,
                                    ),
                                    Text(
                                      '${DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(item?.CreatedAt ?? '${DateTime.now()}'))}',
                                      style: Constant.blackRegular12,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Divider(
                                  thickness: 0.5,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/ic-file.png',
                                      scale: 3.5,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item?.TowerName ?? "-",
                                            style: Constant.blackBold),
                                        SizedBox(height: 5),
                                        Text(item?.TowerName ?? "-",
                                            style: Constant.grayRegular13),
                                      ],
                                    ),
                                  ],
                                ),
                                Constant.xSizedBox8,
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // itemBuilder: (context, index) {
                    //   final item = turbineData[index];
                    //   if (isLoading)
                    //     return Container(
                    //       color: Colors.white,
                    //       padding: EdgeInsets.only(top: 32),
                    //       child: CustomLoadingIndicator.buildIndicator(),
                    //     );
                    //   return InkWell(
                    //     onTap: () async {
                    //       FocusManager.instance.primaryFocus?.unfocus();
                    //       turbineP.turbineSearchC.clear();
                    //       final f = await Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) =>
                    //                   ShaftDetailView(id: item?.Id ?? '')));
                    //       if (f != null) {
                    //         pagingC.refresh();
                    //       }

                    //       // turbineP.turbineModelData =
                    //       //     TurbineModelData();
                    //     },
                    //     child: CustomContainer.mainCard(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Row(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Expanded(
                    //                 flex: 5,
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text(item?.TowerName ?? "-",
                    //                         style: Constant.blackBold),
                    //                     SizedBox(height: 5),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Constant.xSizedBox4,
                    //               Expanded(
                    //                 flex: 5,
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.end,
                    //                   children: [
                    //                     Text(
                    //                       '${DateFormat('dd/MM/yyyy  |  HH : mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(item?.CreatedAt ?? '${DateTime.now()}'))}',
                    //                       // style: Constant.gray,
                    //                       textAlign: TextAlign.right,
                    //                     ),
                    //                     SizedBox(height: 7),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           Constant.xSizedBox12,
                    //         ],
                    //       ),
                    //     ),
                    //   );
                    // }
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
