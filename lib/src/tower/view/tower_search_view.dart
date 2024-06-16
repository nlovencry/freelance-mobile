import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../common/component/custom_appbar.dart';
import '../../../../common/base/base_state.dart';
import '../../../../common/helper/constant.dart';
import '../../../../utils/utils.dart';
import '../provider/tower_provider.dart';

class TowerSearchView extends StatefulWidget {
  const TowerSearchView({super.key});
  @override
  State<TowerSearchView> createState() => _TowerSearchViewState();
}

class _TowerSearchViewState extends BaseState<TowerSearchView> {
  @override
  void initState() {
    context.read<TowerProvider>().fetchTower(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final towerList = context.watch<TowerProvider>().towerModel.Data ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Pilih PLTA"),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: RefreshIndicator(
            color: Constant.primaryColor,
            onRefresh: () => context.read<TowerProvider>().fetchTower(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                context.read<TowerProvider>().search(context),
                Constant.xSizedBox16,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Select Asset Meter Category",
                      style: Constant.grayMedium.copyWith(
                          color: Colors.black38, fontWeight: FontWeight.w500)),
                ),
                Flexible(
                  child: towerList.isEmpty
                      ? Utils.notFoundImage()
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(20, 18, 20, 18),
                          itemCount: towerList.length,
                          separatorBuilder: (_, __) => Divider(
                              thickness: 1, color: Constant.textHintColor),
                          itemBuilder: (context, index) {
                            final item = towerList[index];
                            return InkWell(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.read<TowerProvider>().searchC.clear();
                                Navigator.pop(context, item);
                              },
                              child: Container(
                                height: 80,
                                width: 100.w,
                                // margin:
                                //     EdgeInsets.only(left: 20, right: 20, top: 10),
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 12, bottom: 12),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item?.Name ?? '',
                                        style: Constant.blackBold),
                                    Text(item?.Id ?? '',
                                        style: Constant.grayRegular12),
                                  ],
                                ),
                              ),
                            );
                          },
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
