// import 'package:chatour/common/component/custom_appbar.dart';
// import 'package:chatour/common/component/custom_button.dart';
// import 'package:chatour/common/component/custom_container.dart';
// import 'package:chatour/common/helper/constant.dart';
// import 'package:chatour/common/helper/safe_network_image.dart';
// import 'package:chatour/utils/Utils.dart';
// // import 'package:chatour/common/helper/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// import '../provider/paket_provider.dart';

// class PaketDetailHajiView extends StatefulWidget {
//   const PaketDetailHajiView({super.key, required this.paketId});

//   final String paketId;

//   @override
//   State<PaketDetailHajiView> createState() => _PaketDetailHajiViewState();
// }

// class _PaketDetailHajiViewState extends State<PaketDetailHajiView> {
//   @override
//   void initState() {
//     context
//         .read<PaketProvider>()
//         .fetchDetailPaket(paketId: widget.paketId, withLoading: true);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final detailP = context.watch<PaketProvider>().paketDetailModel.data;
//     final readMore = context.watch<PaketProvider>().readMore;
//     PreferredSizeWidget header() {
//       return CustomAppBar.appBar(
//         detailP?.name ?? "Detail Paket",
//         color: Colors.black,
//         isLeading: true,
//         isCenter: true,
//       );
//     }

//     Widget gambar() {
//       return SafeNetworkImage(
//           width: 100.w, height: 20.h, url: detailP?.banner?.first ?? "");
//     }

//     Widget hotelItem() {
//       return ListView.separated(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: detailP?.hotel?.length ?? 0,
//         itemBuilder: (context, index) {
//           final hotel = detailP?.hotel?[index];
//           return Column(
//             children: [
//               Container(
//                 // width: 350,
//                 // height: 150,
//                 padding: EdgeInsets.all(5.0),
//                 margin: EdgeInsets.only(top: 8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: SafeNetworkImage(
//                   height: 20.h,
//                   width: 1100.w,
//                   url: hotel?.picturePath ?? "-",
//                 ),
//               ),
//               SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     hotel?.name ?? "-",
//                     style: Constant.s12BoldBlack
//                         .copyWith(fontSize: 15, fontWeight: FontWeight.w900),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Hotel ${hotel?.city ?? "-"} |',
//                             // hotel?.city ?? "-"
//                           ),
//                           SizedBox(width: 5),
//                           RatingBar(
//                             ignoreGestures: true,
//                             initialRating: (hotel?.rating ?? 0).toDouble(),
//                             direction: Axis.horizontal,
//                             itemCount: 5,
//                             itemSize: 15,
//                             ratingWidget: RatingWidget(
//                               full: Icon(Icons.star_rounded,
//                                   color: Colors.yellow.shade600),
//                               half: Icon(Icons.star_half_rounded,
//                                   color: Colors.yellow.shade600),
//                               empty: Icon(Icons.star_rounded,
//                                   color: Colors.grey.shade300),
//                             ),
//                             itemPadding:
//                                 const EdgeInsets.symmetric(horizontal: 0),
//                             onRatingUpdate: (double value) {},
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           InkWell(
//                             onTap: () {},
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Constant.primaryColor,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Icon(Icons.location_pin,
//                                       color: Colors.white, size: 15),
//                                   SizedBox(width: 5),
//                                   Text(
//                                     'Lihat detail',
//                                     style: Constant.primaryTextStyle
//                                         .copyWith(color: Colors.white),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 5),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           );
//         },
//         separatorBuilder: (context, index) {
//           return Column(
//             children: [
//               SizedBox(height: 4),
//               Divider(color: Constant.textColor),
//               SizedBox(height: 8),
//             ],
//           );
//         },
//       );
//     }

//     //ini mencoba
//     Widget facilityItem() {
//       return GridView.count(
//         physics: NeverScrollableScrollPhysics(),
//         crossAxisCount: 3,
//         shrinkWrap: true,
//         children: List.generate(
//           detailP?.facility?.length ?? 0,
//           (index) => Container(
//             margin: EdgeInsets.all(5),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // Image.asset(
//                 //   'assets/icons/Tiket PP.png',
//                 //   width: 45,
//                 //   height: 45,
//                 //   fit: BoxFit.cover,
//                 // ),
//                 Expanded(
//                   child: Image.network(
//                     detailP?.facility?[index]?.iconPath ?? "",
//                     // width: 45,
//                     // height: 45,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     detailP?.facility?[index]?.name ?? "",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 12.0),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // [

//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Visa Umroh.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Visa Umroh',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/zam-zam.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Zam-Zam 5L',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/land Arrangement.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Land Arrangement',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Transportasi Saudi 1.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Transportasi Saudia',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Full Guide Muthowif 1.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Full Guide Muthowif',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/makan.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Makan 3X',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Handling airport.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Handling Airport',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Tasreekh Ziarah Raudho 1.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Tasreekh Ziarah Raudho',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // ],
//       );
//     }

//     //Ini yang asli
//     // Widget facilityItem() {
//     //   return ListView.separated(
//     //     physics: NeverScrollableScrollPhysics(),
//     //     shrinkWrap: true,
//     //     itemCount: detailP?.facility?.length ?? 0,
//     //     itemBuilder: (context, index) {
//     //       final facility = detailP?.facility?[index];
//     //       return Row(
//     //         children: [
//     //           SafeNetworkImage(
//     //               width: 24, height: 24, url: facility?.iconPath ?? "-"),
//     //           SizedBox(width: 5),
//     //           Text(
//     //             facility?.name ?? "-",
//     //             style: Constant.primaryTextStyle
//     //                 .copyWith(fontWeight: Constant.semibold),
//     //           ),
//     //         ],
//     //       );
//     //     },
//     //     separatorBuilder: (context, index) => SizedBox(height: 6),
//     //   );
//     // }

//     Widget facilityNotIncludedItem() {
//       return GridView.count(
//         physics: NeverScrollableScrollPhysics(),
//         crossAxisCount: 3,
//         shrinkWrap: true,
//         children: List.generate(
//           detailP?.facilityNotIncluded?.length ?? 0,
//           (index) => Container(
//             margin: EdgeInsets.all(5),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // Image.asset(
//                 //   'assets/icons/Tiket PP.png',
//                 //   width: 45,
//                 //   height: 45,
//                 //   fit: BoxFit.cover,
//                 // ),
//                 Expanded(
//                   child: Image.network(
//                     detailP?.facilityNotIncluded?[index]?.iconPath ?? "",
//                     // width: 45,
//                     // height: 45,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     detailP?.facilityNotIncluded?[index]?.name ?? "",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 12.0),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // [

//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Visa Umroh.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Visa Umroh',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/zam-zam.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Zam-Zam 5L',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/land Arrangement.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Land Arrangement',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Transportasi Saudi 1.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Transportasi Saudia',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Full Guide Muthowif 1.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Full Guide Muthowif',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/makan.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Makan 3X',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Handling airport.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Handling Airport',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // Column(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Image.asset(
//         //       'assets/icons/Tasreekh Ziarah Raudho 1.png',
//         //       width: 45,
//         //       height: 45,
//         //       fit: BoxFit.cover,
//         //     ),
//         //     Text(
//         //       'Tasreekh Ziarah Raudho',
//         //       textAlign: TextAlign.center,
//         //       style: TextStyle(fontSize: 12.0),
//         //     ),
//         //   ],
//         // ),
//         // ],
//       );
//     }

//     // Ini asli
//     // Widget facilityNotIncludedItem() {
//     //   return ListView.separated(
//     //     physics: NeverScrollableScrollPhysics(),
//     //     shrinkWrap: true,
//     //     itemCount: detailP?.facilityNotIncluded?.length ?? 0,
//     //     itemBuilder: (context, index) {
//     //       final facilityNotIncluded = detailP?.facilityNotIncluded?[index];
//     //       return Row(
//     //         children: [
//     //           SafeNetworkImage(
//     //               width: 24,
//     //               height: 24,
//     //               url: facilityNotIncluded?.iconPath ?? "-"),
//     //           SizedBox(width: 5),
//     //           Text(
//     //             facilityNotIncluded?.name ?? "-",
//     //             style: Constant.primaryTextStyle
//     //                 .copyWith(fontWeight: Constant.semibold),
//     //           ),
//     //         ],
//     //       );
//     //     },
//     //     separatorBuilder: (context, index) => SizedBox(height: 6),
//     //   );
//     // }

//     Widget agendaItem() {
//       if ((detailP?.agenda?.length ?? 0) > 0)
//         return ListView.separated(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: readMore ? (detailP?.agenda?.length ?? 0) : 1,
//           itemBuilder: (context, index) {
//             final agenda = detailP?.agenda?[index];
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 8,
//                   height: 8,
//                   margin: EdgeInsets.only(top: 8),
//                   decoration: BoxDecoration(
//                       shape: BoxShape.circle, color: Colors.black),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           'Hari ke-${agenda?.day}\n${agenda?.description ?? "-"}'),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           },
//           separatorBuilder: (context, index) => SizedBox(height: 6),
//         );
//       return SizedBox();
//       // return Utils.notFoundImage(text: "Tidak ada agenda");
//     }

//     Widget detailHaji() {
//       return CustomContainer.mainCard(
//         isShadow: true,
//         padding: EdgeInsets.all(20.0),
//         margin: EdgeInsets.only(top: 8, left: 8, right: 8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               detailP?.name ?? "-",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 15),
//             Flexible(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.calendar_today_outlined, size: 20),
//                   SizedBox(width: 5),
//                   Flexible(
//                     child: Text(
//                       '${detailP?.name ?? "-"} ${detailP?.duration ?? "-"} Hari',
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: Constant.primaryTextStyle
//                           .copyWith(fontWeight: Constant.semibold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 // Image.asset('assets/icons/Airplane Take Off.png'),
//                 Icon(Icons.airplanemode_on_outlined, size: 20),
//                 SizedBox(width: 5),
//                 Text(
//                   detailP?.cityName ?? "-",
//                   style: Constant.primaryTextStyle
//                       .copyWith(fontWeight: Constant.semibold),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 // Image.asset('assets/icons/Stack of Coins.png'),
//                 Icon(Icons.payment, size: 20),
//                 SizedBox(width: 5),
//                 Text(
//                   'Mulai ${detailP?.price ?? ""}',
//                   style: Constant.primaryTextStyle
//                       .copyWith(fontWeight: Constant.semibold, fontSize: 14),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 // Image.asset('assets/icons/Schedule.png'),
//                 Icon(Icons.schedule, size: 20),
//                 SizedBox(width: 5),
//                 Text(
//                   'Keberangkatan ${detailP?.dateDeparture ?? "-"}',
//                   style: Constant.primaryTextStyle
//                       .copyWith(fontWeight: Constant.semibold, fontSize: 14),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Divider(color: Constant.textColor),
//             SizedBox(height: 8),
//             hotelItem(),
//             SizedBox(height: 8),
//             Divider(color: Constant.textColor),
//             SizedBox(height: 8),
//             Text(
//               'Fasilitas Termasuk',
//               style: Constant.primaryTextStyle
//                   .copyWith(fontWeight: Constant.semibold, fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             facilityItem(),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               'Fasilitas Belum Termasuk',
//               style: Constant.primaryTextStyle
//                   .copyWith(fontWeight: Constant.semibold, fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             facilityNotIncludedItem(),
//             SizedBox(height: 10),
//             Divider(color: Constant.textColor),
//             SizedBox(height: 8),
//             if ((detailP?.agenda?.length ?? 0) > 0)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Text(
//                   'Agenda Perjalanan',
//                   style: Constant.primaryTextStyle
//                       .copyWith(fontWeight: Constant.semibold, fontSize: 15),
//                 ),
//               ),
//             agendaItem(),
//             Visibility(
//               visible: detailP?.agenda?.isNotEmpty ?? false,
//               child: InkWell(
//                 onTap: () {
//                   context.read<PaketProvider>().readMore = !readMore;
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 30, bottom: 15),
//                   child: Text(
//                     'Lihat lebih ${readMore ? "sedikit" : "lengkap"}',
//                     style: Constant.primaryTextStyle
//                         .copyWith(color: Color.fromARGB(255, 6, 28, 221)),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget buttonUnduhBrosur() {
//       return Container(
//         margin: EdgeInsets.symmetric(horizontal: 20),
//         child: CustomButton.mainButton('Unduh Brosur', () {}),
//       );
//     }

//     return Scaffold(
//       appBar: header(),
//       body: ListView(
//         shrinkWrap: true,
//         children: [
//           gambar(),
//           detailHaji(),
//           SizedBox(height: 15),
//           // buttonPesanPaket(),
//           // SizedBox(height: 10),
//           buttonUnduhBrosur(),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
