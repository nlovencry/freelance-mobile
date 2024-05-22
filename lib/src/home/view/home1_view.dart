import 'package:bimops/common/component/custom_container.dart';
import 'package:bimops/common/helper/constant.dart';
import 'package:flutter/material.dart';

class Home1View extends StatefulWidget {
  const Home1View({super.key});

  @override
  State<Home1View> createState() => _Home1ViewState();
}

class _Home1ViewState extends State<Home1View> {
  static const List<String> staticArray = [
    'User',
    'Upper',
    'Clutch',
    'Turbine',
    'Shaft',
    'Upper',
    'Clutch',
    'Turbine'
  ];

  @override
  Widget build(BuildContext context) {
    Widget headKonten() {
      return Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.only(right: 10, top: 25),
        padding: EdgeInsets.fromLTRB(20, 30, 10, 15),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/img_home.png'),
                fit: BoxFit.contain)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alifano Reinanda",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Turbine Engineer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/icons/ic-prof-home.png',
                  scale: 1.8,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overall Turbine Status",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            height: 30,
                            color: Colors.lightBlueAccent.shade100
                                .withOpacity(0.3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic-inbox.png',
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Add Data",
                                  style: TextStyle(
                                    color: Constant.primaryColor,
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                    Text(
                      "8/10",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    LinearProgressIndicator(
                      value: 0.8,
                      color: Constant.primaryColor,
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
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Menu",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              GridView.count(
                shrinkWrap: true,
                  crossAxisCount: 4,
                childAspectRatio: 0.8,
                crossAxisSpacing: 5.0, // Spasi antar kolom
                mainAxisSpacing: 15.0, // Spasi antar baris
                padding: EdgeInsets.all(8.0),
                children: List.generate(staticArray.length, (index) => Column(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightBlueAccent.shade200
                              .withOpacity(0.3),
                          image: DecorationImage(
                              image: AssetImage('assets/icons/ic-menu1.png'),
                              scale: 2)),
                    ),
                    Text(staticArray[index])
                  ],
                ),),
              ),
              // Row(
              //   children: [
              //     Column(
              //       children: [
              //         Container(
              //           height: 70,
              //           width: 70,
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(15),
              //               color: Colors.lightBlueAccent.shade200
              //                   .withOpacity(0.3),
              //               image: DecorationImage(
              //                   image: AssetImage('assets/icons/ic-menu1.png'),
              //                   scale: 2)),
              //         ),
              //       ],
              //     )
              //   ],
              // ),
            ],
          ));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headKonten(),
            SizedBox(
              height: 5,
            ),
            bodyKonten(),
          ],
        ),
      ),
    );
  }
}
