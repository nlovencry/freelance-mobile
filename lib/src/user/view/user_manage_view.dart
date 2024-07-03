import 'dart:async';

import 'package:hy_tutorial/common/component/custom_button.dart';
import 'package:hy_tutorial/common/component/custom_container.dart';
import 'package:hy_tutorial/common/component/custom_navigator.dart';
import 'package:hy_tutorial/src/user/provider/user_provider.dart';
import 'package:hy_tutorial/src/user/view/user_add_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_textField.dart';
import '../../../common/helper/constant.dart';

class UserManageView extends StatefulWidget {
  const UserManageView({super.key});

  @override
  State<UserManageView> createState() => _UserManageViewState();
}

class _UserManageViewState extends State<UserManageView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    final p = context.read<UserProvider>();
    p.tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<UserProvider>();
    Widget search() => CustomTextField.borderTextField(
          controller: p.searchC,
          required: false,
          hintText: "Cari",
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
            if (p.searchOnStoppedTyping != null) {
              p.searchOnStoppedTyping!.cancel();
            }
            p.searchOnStoppedTyping = Timer(p.duration, () {
              p.simulateFetch();
              // pagingC.refresh();
            });
          },
        );

    Widget toggleTab() {
      return SingleChildScrollView(
        child: TabBar(
          labelColor: Constant.primaryColor,
          unselectedLabelColor: Constant.grayColor,
          indicatorColor: Constant.primaryColor,
          controller: p.tabController,
          tabs: [
            Tab(child: Text("User Aktif")),
            Tab(child: Text("User Nonaktif")),
          ],
        ),
      );
      // return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(50),
      //     border: Border.all(color: Constant.primaryColor, width: 0.5)),
      // child: FlutterToggleTab(
      //   width: 91, // width in percent
      //   // borderRadius: 30,
      //   height: 40,
      //   selectedIndex: p.currentIndex,
      //   selectedBackgroundColors: [Colors.white],
      //   unSelectedBackgroundColors: [Colors.white],
      //   selectedTextStyle: TextStyle(
      //       color: Constant.primaryColor, fontWeight: FontWeight.bold),
      //   unSelectedTextStyle: TextStyle(color: Colors.black26),
      //   labels: ["User Aktif", "User Nonaktif"],

      //   selectedLabelIndex: (index) {
      //     setState(() {
      //       p.currentIndex = index;
      //       p.tabController.index = index;
      //     });
      //     // if (index == 0)
      //     // context.read<UserProvider>().pagingController.refresh();
      //     // if (index == 1)
      //     // context.read<UserProvider>().pagingController2.refresh();
      //   },
      //   isScroll: false,
      // ),
      // );
    }

    Widget userAktif = ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 4,
      separatorBuilder: (_, __) => Constant.xSizedBox16,
      itemBuilder: (c, i) {
        if (p.loadingg) return Center(child: CircularProgressIndicator());
        return InkWell(
          onTap: () {
            CusNav.nPush(context, UserAddView(isEdit: true));
          },
          child: CustomContainer.mainCard(
            color: Colors.grey.shade100,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person),
                ),
                Constant.xSizedBox8,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      style: Constant.blackBold13,
                    ),
                    Constant.xSizedBox4,
                    Text(
                      "Machine Engineer",
                      style: Constant.grayBold12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Manage Users"),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Manage Users", style: Constant.blackBold20),
                        Constant.xSizedBox4,
                        Text("Atur segala kebutuhan user disini",
                            style: Constant.grayMedium.copyWith(fontSize: 15)),
                      ],
                    )),
                Constant.xSizedBox8,
                Expanded(
                  flex: 5,
                  child: CustomButton.secondaryButtonWithicon(
                      Icon(
                        Icons.person_add_alt_outlined,
                        color: Constant.primaryColor,
                      ),
                      'Add Users', () {
                    CusNav.nPush(context, UserAddView());
                  },
                      textStyle: TextStyle(
                          color: Constant.primaryColor,
                          fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.only(left: 16),
                      mainAxisAlignment: MainAxisAlignment.start),
                ),
              ],
            ),
            Constant.xSizedBox16,
            search(),
            Constant.xSizedBox16,
            Container(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    toggleTab(),
                    Constant.xSizedBox16,
                    Container(
                      // constraints: BoxConstraints.expand(),
                      child: [userAktif][p.currentIndex],
                      height: 48.h,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      // child: TabBarView(
                      //   physics: NeverScrollableScrollPhysics(),
                      //   controller: p.tabController,
                      //   children: [userAktif, userAktif],
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
