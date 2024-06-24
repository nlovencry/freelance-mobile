import 'dart:async';
import 'dart:developer';

import 'package:mata/common/component/custom_appbar.dart';
import 'package:mata/common/component/custom_container.dart';
import 'package:mata/common/component/custom_dropdown.dart';
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

class RiwayatView extends StatefulWidget {
  @override
  State<RiwayatView> createState() => _RiwayatViewState();
}

class _RiwayatViewState extends BaseState<RiwayatView> {
  @override
  void initState() {
    final turbineP = context.read<TurbineProvider>();
    // turbineP.pagingController = PagingController(firstPageKey: 1)
    //   ..addPageRequestListener(
    //       (pageKey) => turbineP.fetchTurbine(page: pageKey));
    turbineP.fetchTurbine(withLoading: true);
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
        "Riwayat",
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16
        ),
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
            onRefresh: () async =>
                await context.read<TurbineProvider>().fetchTurbine(),
            // onRefresh: () async => pagingC.refresh(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // search(),
                // Constant.xSizedBox16,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Filter",
                          style: Constant.grayMedium.copyWith(
                              color: Colors.black, fontWeight: FontWeight.w400)),
                      Container(
                        height: 30,
                        width: 90,
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
                            PopupMenuButton<String>(
                              position: PopupMenuPosition.under,
                              child: Row(
                                children: [
                                  Text(
                                    'Tanggal',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'Open-Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.keyboard_arrow_down, size: 15,)
                                ],
                              ),
                              itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'transaksi',
                                  child: Text('Transaksi'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'informasi',
                                  child: Text('Informasi'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'feed',
                                  child: Text('Feed'),
                                ),
                                // Tambahkan PopupMenuItem sesuai kebutuhan
                              ],
                              onSelected: (String result) {
                                // Tindakan yang akan diambil ketika opsi dipilih
                                log('Selected: $result');
                              },
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                Constant.xSizedBox16,
                Flexible(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: turbineData.length,
                      // pagingController: pagingC,
                      padding: EdgeInsets.fromLTRB(4, 18, 4, 20),
                      separatorBuilder: (_, __) => Constant.xSizedBox16,
                      itemBuilder: (context, index) {
                        final item = turbineData[index];
                        return InkWell(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            turbineP.turbineSearchC.clear();
                            final f = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShaftDetailView(id: item?.Id ?? '')));
                            if (f != null) {
                              pagingC.refresh();
                            }

                            // turbineP.turbineModelData =
                            //     TurbineModelData();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      }
                      // builderDelegate:
                      //     PagedChildBuilderDelegate<TurbineModelData>(
                      //   firstPageProgressIndicatorBuilder: (_) => Container(
                      //     color: Colors.white,
                      //     padding: EdgeInsets.only(top: 32),
                      //     child: CustomLoadingIndicator.buildIndicator(),
                      //   ),
                      //   newPageProgressIndicatorBuilder: (_) => Container(
                      //     color: Colors.white,
                      //     child: CustomLoadingIndicator.buildIndicator(),
                      //   ),
                      //   noItemsFoundIndicatorBuilder: (_) => Padding(
                      //     padding: const EdgeInsets.only(top: 56),
                      //     child: Utils.notFoundImage(),
                      //   ),
                      //   itemBuilder: (context, item, indexs) {
                      //     return InkWell(
                      //       onTap: () async {
                      //         FocusManager.instance.primaryFocus?.unfocus();
                      //         turbineP.turbineSearchC.clear();
                      //         final f = await Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     ShaftDetailView(id: item.Id ?? '')));
                      //         if (f != null) {
                      //           pagingC.refresh();
                      //         }

                      //         // turbineP.turbineModelData =
                      //         //     TurbineModelData();
                      //       },
                      //       child: CustomContainer.mainCard(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Row(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 Expanded(
                      //                   flex: 5,
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       Text(item.TowerName ?? "-",
                      //                           style: Constant.blackBold),
                      //                       SizedBox(height: 5),
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 Constant.xSizedBox4,
                      //                 Expanded(
                      //                   flex: 5,
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.end,
                      //                     children: [
                      //                       Text(
                      //                         '${DateFormat('dd/MM/yyyy  |  HH : mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(item.CreatedAt ?? '${DateTime.now()}'))}',
                      //                         style: Constant.grayRegular,
                      //                         textAlign: TextAlign.right,
                      //                       ),
                      //                       SizedBox(height: 7),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             Constant.xSizedBox12,
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
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
