import 'package:hy_tutorial/common/base/base_state.dart';
import 'package:hy_tutorial/common/component/custom_container.dart';
import 'package:hy_tutorial/common/component/custom_navigator.dart';
import 'package:hy_tutorial/common/helper/constant.dart';
import 'package:hy_tutorial/src/data/view/data_add_view.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/utils.dart';
import '../../auth/provider/auth_provider.dart';
import '../../shaft/view/shaft_latest_view.dart';

class Home1View extends StatefulWidget {
  const Home1View({super.key});

  @override
  State<Home1View> createState() => _Home1ViewState();
}

class _Home1ViewState extends BaseState<Home1View> {
  String? name;
  String? division;
  static const List<String> staticArray = [
    'Shaft',
    'Upper',
    'Clutch',
    'Turbine',
    'Result'
    // 'Shaft',
    // 'Upper',
    // 'Clsutch',
    // 'Turbine'
  ];
  static const List<String> staticImage = [
    'assets/icons/ic-shaft.png',
    'assets/icons/ic-upper.png',
    'assets/icons/ic-clutch.png',
    'assets/icons/ic-turbine.png',
    'assets/icons/ic-shaft.png',
    // 'Shaft',
    // 'Upper',
    // 'Clutch',
    // 'Turbine'
  ];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString(Constant.kSetPrefName);
    division = prefs.getString(Constant.kSetPrefRoles);
    setState(() {});
    await context.read<AuthProvider>().getConfig();
  }

  @override
  Widget build(BuildContext context) {
    Widget headKonten() {
      return Container(
        color: Constant.primaryColor,
        height: 300,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20, 60, 20, 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? "Alifano Reinanda",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    Constant.xSizedBox8,
                    Text(
                      division ?? "Turbine Engineer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                InkWell(
                    onTap: () async {},
                    child: Image.asset('assets/icons/ic-user.png',
                        scale: 4)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            DottedLine(
                dashColor: Colors.white.withOpacity(0.7),
                lineThickness: 1,
                dashLength: 2),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Constant.secondaryColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Overall Turbine Status",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "8/10",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          flex: 4,
                          child: InkWell(
                            onTap: () => CusNav.nPush(context, DataAddView()),
                            child: Container(
                                padding: EdgeInsets.all(7),
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Constant.thirdColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Add Data",
                                      style: TextStyle(
                                          color: Constant.primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      'assets/icons/ic-inbox.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pencapaian",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          "80%",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LinearProgressIndicator(
                      value: 0.8,
                      color: Colors.lightBlueAccent,
                      backgroundColor: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget bodyKonten() {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Menu",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: List.generate(
                        staticArray.length,
                        (indexx) => InkWell(
                          onTap: () {
                            CusNav.nPush(
                                context,
                                ShaftLatestView(
                                    index: indexx == 1
                                        ? 2
                                        : indexx == 3
                                            ? 1
                                            : 0));
                          },
                          child: Column(
                            children: [
                              CustomContainer.mainCard(
                                isShadow: false,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: Colors
                                                .lightBlueAccent.shade200
                                                .withOpacity(0.3),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    staticImage[indexx]),
                                                scale: 3)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            staticArray[indexx],
                                            style: Constant.iPrimaryMedium8
                                                .copyWith(fontSize: 16),
                                          ),
                                          Text("Cek laporan mengenai " +
                                              staticArray[indexx]),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                          size: 20,
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox();
                  },
                  itemCount: 1),

            ],
          ));
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<AuthProvider>().getConfig();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headKonten(),
              SizedBox(height: 5),
              bodyKonten(),
            ],
          ),
        ),
      ),
    );
  }
}
