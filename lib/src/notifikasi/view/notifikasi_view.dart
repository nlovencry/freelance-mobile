import 'package:bimops/src/notifikasi/provider/notifikasi_provider.dart';
import 'package:bimops/src/notifikasi/view/notifikasi_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_loading_indicator.dart';
import '../../../common/helper/constant.dart';
import '../../../utils/utils.dart';
import '../model/notifikasi_model.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    final nP = context.read<NotifikasiProvider>();
    nP.pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) => nP.fetchNotif(page: pageKey));
    nP.pagingController2 = PagingController(firstPageKey: 1)
      ..addPageRequestListener((pageKey) => nP.fetchNotif2(page: pageKey));
    super.initState();
  }

  @override
  Widget toggleTab() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Constant.primaryColor, width: 0.5)),
      child: FlutterToggleTab(
        width: 91, // width in percent
        borderRadius: 30,
        height: 50,
        selectedIndex: currentIndex,
        selectedBackgroundColors: [Constant.primaryColor],
        unSelectedBackgroundColors: [Color(0xffffffff)],
        selectedTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        unSelectedTextStyle: TextStyle(color: Colors.black87),
        labels: ["Need Action", "Action Complete"],
        selectedLabelIndex: (index) {
          setState(() {
            currentIndex = index;
            _tabController.index = index;
          });
          if (index == 0)
            context.read<NotifikasiProvider>().pagingController.refresh();
          if (index == 1)
            context.read<NotifikasiProvider>().pagingController2.refresh();
        },
        isScroll: false,
      ),
    );
  }

  Widget build(BuildContext context) {
    final notifP = context.watch<NotifikasiProvider>().notifikasiModel.data;
    final pagingC = context.watch<NotifikasiProvider>().pagingController;
    final pagingC2 = context.watch<NotifikasiProvider>().pagingController2;

    Widget needAction() {
      return RefreshIndicator(
        onRefresh: () async => pagingC.refresh(),
        child: Container(
          margin: EdgeInsets.only(top: 16),
          child: PagedListView.separated(
            shrinkWrap: true,
            pagingController: pagingC,
            padding: EdgeInsets.zero,
            separatorBuilder: (_, __) => Constant.xSizedBox16,
            builderDelegate: PagedChildBuilderDelegate<NotifikasiModelData>(
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
                final notifData = item;
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailNotifikasiView(
                            action: true,
                              docCode: item.assetCode ?? "",
                              woId: item.id ?? "0",
                              type: item.moduleId ?? ""))),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Badge(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.notifications,
                                color: Constant.primaryColor),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notifData.docNo ?? "Doc No -",
                                style: Constant.primaryBold15
                                    .copyWith(fontSize: 14),
                              ),
                              SizedBox(height: 3),
                              Text(
                                notifData.assetName ?? "Asset Name -",
                                style: Constant.grayBold12,
                              ),
                              SizedBox(height: 3),
                              Text(
                                notifData.description ?? "Desc -",
                                style: Constant.grayRegular13,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          notifData.dateDoc == null ||
                                  notifData.dateDoc?.trim() == ""
                              ? "Tanggal -"
                              : Utils.convertDateddMMMyyyy(
                                  notifData.dateDoc ?? "${DateTime.now()}"),
                          style: Constant.grayRegular13,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    Widget actionComplete() {
      return RefreshIndicator(
        onRefresh: () async => pagingC2.refresh(),
        child: Container(
          margin: EdgeInsets.only(top: 16),
          child: PagedListView.separated(
            shrinkWrap: true,
            pagingController: pagingC2,
            padding: EdgeInsets.zero,
            separatorBuilder: (_, __) => Constant.xSizedBox16,
            builderDelegate: PagedChildBuilderDelegate<NotifikasiModelData>(
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
                final notifData = item;
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailNotifikasiView(
                            action: false,
                              docCode: item.assetCode ?? "",
                              woId: item.id ?? "0",
                              type: item.moduleId ?? ""))),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.notifications,
                            color: Constant.grayColor,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notifData.docNo ?? "Doc No -",
                                style:
                                    Constant.blackBold15.copyWith(fontSize: 14),
                              ),
                              SizedBox(height: 3),
                              Text(
                                notifData.assetName ?? "Asset Name -",
                                style: Constant.grayBold12,
                              ),
                              SizedBox(height: 3),
                              Text(
                                notifData.description ?? "Desc -",
                                style: Constant.grayRegular13,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          notifData.dateDoc == null ||
                                  notifData.dateDoc?.trim() == ""
                              ? "Tanggal -"
                              : Utils.convertDateddMMMyyyy(
                                  notifData.dateDoc ?? "${DateTime.now()}"),
                          style: Constant.grayRegular13,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Notification"),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 8),
            toggleTab(),
            SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [needAction(), actionComplete()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
