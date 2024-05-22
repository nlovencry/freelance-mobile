// import 'dart:developer';

// import 'package:chatour/common/base/base_state.dart';
// import 'package:chatour/common/component/custom_appbar.dart';
// import 'package:chatour/common/component/custom_button.dart';
// import 'package:chatour/common/component/custom_container.dart';
// import 'package:chatour/common/component/custom_dropdown.dart';
// import 'package:chatour/common/helper/constant.dart';
// import 'package:chatour/src/paket/model/paket_filter_model.dart';
// import 'package:chatour/src/paket/provider/paket_provider.dart';
// import 'package:chatour/src/paket/view/paket_detail_umroh_view.dart';
// import 'package:chatour/utils/Utils.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// import '../../../common/helper/safe_network_image.dart';
// import '../model/paket_model.dart';

// class PaketUmrohView extends StatefulWidget {
//   const PaketUmrohView({super.key});

//   @override
//   State<PaketUmrohView> createState() => _PaketUmrohViewState();
// }

// class _PaketUmrohViewState extends BaseState<PaketUmrohView> {
//   List<String> kota_ = [
//     'Surabaya',
//     'Jember',
//     'Pasuruan',
//     'Probolinggo',
//   ];
//   List<String> bulan_ = [
//     'Januari',
//     'Februari',
//     'Maret',
//     'April',
//     'Mei',
//     'Juni',
//     'Juli',
//     'Agustus',
//     'September',
//     'Oktober',
//     'November',
//     'Desember',
//   ];

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   getData() async {
//     loading(true);
//     await context.read<PaketProvider>().clearFilter();
//     await context.read<PaketProvider>().fetchPaketUmroh();
//     await context.read<PaketProvider>().fetchCityDeparture();
//     setState(() {});
//     loading(false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paketP = context.watch<PaketProvider>();
//     final paketL = context.watch<PaketProvider>().paketUmrohModel;
//     final cityDeparture =
//         context.watch<PaketProvider>().paketCityDepartureModel;
//     final reguler = context.watch<PaketProvider>().isReguler;
//     final promo = context.watch<PaketProvider>().isPromo;
//     final kota = context.watch<PaketProvider>().selectedKota;
//     PreferredSizeWidget header() {
//       return CustomAppBar.appBar(
//         'Paket Umroh',
//         color: Colors.black,
//         action: [
//           InkWell(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: Icon(Icons.filter_list),
//             ),
//             onTap: () async {
//               await CustomContainer.showModalBottom(
//                 context: context,
//                 initialChildSize: 0.61,
//                 child: StatefulBuilder(
//                   builder: (context, state) {
//                     final reguler2 = context.watch<PaketProvider>().isReguler;
//                     final promo2 = context.watch<PaketProvider>().isPromo;
//                     return Container(
//                       margin: EdgeInsets.only(top: 8, left: 12, right: 12),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 'Pilih Jenis Paket',
//                                 style: Constant.primaryTextStyle.copyWith(
//                                     fontWeight: Constant.semibold,
//                                     fontSize: 18),
//                               ),
//                               Spacer(),
//                               // Text(
//                               //   'X',
//                               //   style: Constant.s12BoldBlack,
//                               // )
//                             ],
//                           ),
//                           CheckboxListTile(
//                             value: paketP.isReguler,
//                             onChanged: (bool? newValue) {
//                               state(() {
//                                 paketP.isReguler = newValue;
//                               });
//                               setState(() {});
//                             },
//                             title: Text('Reguler'),
//                             contentPadding: EdgeInsets.zero,
//                             activeColor: Constant.primaryColor,
//                             checkColor: Colors.white,
//                           ),
//                           CheckboxListTile(
//                             value: paketP.isPromo,
//                             onChanged: (bool? newValue) {
//                               state(() {
//                                 paketP.isPromo = newValue;
//                               });

//                               setState(() {});
//                             },
//                             title: Text('Promo'),
//                             contentPadding: EdgeInsets.zero,
//                             activeColor: Constant.primaryColor,
//                             checkColor: Colors.white,
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Pilih Kota Keberangkatan',
//                             style: Constant.primaryTextStyle.copyWith(
//                                 fontWeight: Constant.semibold, fontSize: 18),
//                           ),
//                           SizedBox(height: 5),
//                           CustomDropdown.filterDropdown(
//                             list: (cityDeparture.data ?? []).map(
//                               (element) {
//                                 return DropdownMenuItem(
//                                     child: Text(element?.name ?? "-"),
//                                     value: element?.name);
//                               },
//                             ).toList(),
//                             padding: EdgeInsets.zero,
//                             selectedItem: paketP.selectedKotaName,
//                             onChanged: (val) {
//                               int kotaId = (cityDeparture?.data ?? [])
//                                       .firstWhere((element) =>
//                                           element?.name == (val ?? ""))
//                                       ?.id ??
//                                   0;
//                               String kotaName = (cityDeparture?.data ?? [])
//                                       .firstWhere((element) =>
//                                           element?.name == (val ?? ""))
//                                       ?.name ??
//                                   "";
//                               state(() {
//                                 context.read<PaketProvider>().selectedKota =
//                                     kotaId.toString();
//                                 context.read<PaketProvider>().selectedKotaName =
//                                     kotaName;
//                               });
//                             },
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Pilih Bulan Keberangkatan',
//                             style: Constant.primaryTextStyle.copyWith(
//                                 fontWeight: Constant.semibold, fontSize: 18),
//                           ),
//                           SizedBox(height: 5),
//                           CustomDropdown.filterDropdown(
//                             list: bulan_.map(
//                               (element) {
//                                 return DropdownMenuItem(
//                                     child: Text(element), value: element);
//                               },
//                             ).toList(),
//                             selectedItem: paketP.selectedBulan == null
//                                 ? null
//                                 : bulan_[(paketP.selectedBulan ?? 1) - 1],
//                             padding: EdgeInsets.zero,
//                             onChanged: (val) {
//                               int bulan = bulan_.indexOf(val ?? "-") + 1;
//                               state(() {
//                                 context.read<PaketProvider>().selectedBulan =
//                                     bulan;
//                               });
//                             },
//                           ),
//                           SizedBox(height: 20),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               CustomButton.mainButton(
//                                 'Bersihkan Filter',
//                                 () async {
//                                   context.read<PaketProvider>().clearFilter();
//                                   loading(true);
//                                   await context
//                                       .read<PaketProvider>()
//                                       .fetchPaketUmroh();
//                                   loading(false);
//                                   Navigator.pop(context);
//                                 },
//                                 stretched: true,
//                               ),
//                               SizedBox(width: 5),
//                               Expanded(
//                                 child: CustomButton.mainButton(
//                                   'Filter',
//                                   () async {
//                                     loading(true);
//                                     await context
//                                         .read<PaketProvider>()
//                                         .fetchPaketUmroh();
//                                     loading(false);
//                                     // paketP.paketFilterModel = PaketFilterModel(
//                                     //     reguler: _isReguler ?? false,
//                                     //     promo: _isPromo ?? false,
//                                     //     kotaKeberangkatan: selectedKota ?? "",
//                                     //     bulanKeberangkatan: 1);
//                                     Navigator.pop(context);
//                                   },
//                                   stretched: true,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               );

//               // log("REGULER : ${paketP.paketFilterModel.reguler}");
//               // log("PROMO : ${paketP.paketFilterModel.promo}");
//               // log("KOTA : ${paketP.paketFilterModel.kotaKeberangkatan}");
//               // log("BULAN : ${paketP.paketFilterModel.bulanKeberangkatan}");
//             },
//           )
//         ],
//         isLeading: true,
//         isCenter: true,
//       );
//     }

//     Widget paketUmrohList() {
//       if (paketL.data == null) {
//         return SizedBox();
//       }
//       if ((paketL.data ?? []).isEmpty) {
//         return Utils.notFoundImage();
//       }
//       return WillPopScope(
//         onWillPop: () async {
//           // paketP.paketUmrohModel = PaketModel();
//           return true;
//         },
//         child: RefreshIndicator(
//           onRefresh: () => getData(),
//           child: ListView.separated(
//             // physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             separatorBuilder: (context, index) => SizedBox(),
//             itemCount: paketL.data?.length ?? 0,
//             itemBuilder: (context, index) {
//               final paket = paketL.data?[index];
//               return InkWell(
//                 onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => PaketDetailUmrohView(
//                             paketId: (paket?.id ?? 0).toString()))),
//                 child: CustomContainer.mainCard(
//                   isShadow: true,
//                   margin: EdgeInsets.only(top: 8, left: 10, right: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: SafeNetworkImage.circle(
//                               url: '${paket?.thumbnailPath}',
//                               radius: 50,
//                               errorBuilder: CircleAvatar(
//                                 radius: 30,
//                                 backgroundImage: AssetImage(
//                                     'assets/images/img-placeholder.png'),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             flex: 9,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('${paket?.cityName}',
//                                     style: Constant.primaryTextStyle),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   '${paket?.name}',
//                                   // maxLines: 1,
//                                   // overflow: TextOverflow.ellipsis,
//                                   style: Constant.primaryTextStyle
//                                       .copyWith(fontWeight: Constant.semibold),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Expanded(
//                                       flex: 9,
//                                       child: Text(
//                                         'Mulai ${paket?.price}',
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: Constant.primaryTextStyle
//                                             .copyWith(
//                                                 color: Constant.textPriceColor),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Flexible(
//                                       child: Text(
//                                         '${paket?.day} Hari',
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 2,
//                                         textAlign: TextAlign.right,
//                                         style: Constant.primaryTextStyle,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     }

//     return Scaffold(appBar: header(), body: paketUmrohList()
//         // ListView.separated(
//         //   physics: AlwaysScrollableScrollPhysics(),
//         //   shrinkWrap: true,
//         //   itemCount: 6,
//         //   itemBuilder: (context, index) => paketUmrohList(),
//         //   separatorBuilder: (context, index) => SizedBox(),
//         // ),
//         );
//   }
// }
