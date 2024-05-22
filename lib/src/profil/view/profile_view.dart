// import 'dart:io';

// import 'package:chatour/common/component/custom_button.dart';
// import 'package:chatour/common/component/custom_image_picker.dart';
// import 'package:chatour/common/helper/constant.dart';
// import 'package:chatour/src/auth/view/change_password_view.dart';
// import 'package:chatour/src/jamaah/model/jamaah_list_model.dart';
// import 'package:chatour/src/jamaah/model/jamaah_list_sub_agen_model.dart';
// import 'package:chatour/src/jamaah/provider/jamaah_provider.dart';
// import 'package:chatour/src/komisi/view/komisi_agen_view.dart';
// import 'package:chatour/src/paket/model/paket_detail_model.dart';
// import 'package:chatour/src/paket/model/paket_model.dart';
// import 'package:chatour/src/paket/provider/paket_provider.dart';
// import 'package:chatour/src/profil/provider/profile_provider.dart';
// import 'package:chatour/src/profil/view/contact_profile_view.dart';
// import 'package:chatour/src/sub_model/sub_agen_model.dart';
// import 'package:chatour/src/sub_provider/sub_agen_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// import 'package:intl/intl.dart';
// import 'package:pattern_formatter/pattern_formatter.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';

// import 'package:chatour/src/profil/model/profile_model.dart';
// import 'package:chatour/src/notifikasi/model/notifikasi_model.dart';
// import 'package:chatour/src/home/model/home_model.dart';
// import '../../../common/base/base_state.dart';
// import '../../../common/helper/safe_network_image.dart';
// import '../../../common/page/web_view.dart';
// import '../../../utils/utils.dart';
// import '../../auth/provider/auth_provider.dart';
// import '../../home/provider/home_provider.dart';
// import '../../komisi/view/komisi_sub_agen_view.dart';
// import '../../region/provider/region_provider.dart';
// import 'about_view.dart';
// import 'dokumen_view.dart';
// import 'edit_profile_view.dart';
// import '../../jamaah/model/jamaah_detail_model.dart';
// import '../../jamaah/provider/detail_jamaah_provider.dart';
// import '../../notifikasi/provider/notifikasi_provider.dart';
// import 'package:chatour/src/jamaah/model/riwayat_tabungan_model.dart';
// import 'package:chatour/src/jamaah/provider/riwayat_tabungan_provider.dart';
// import 'package:chatour/src/komisi/model/riwayat_penarikan_komisi_model.dart';
// import 'package:chatour/src/komisi/provider/riwayat_penarikan_komisi_provider.dart';

// class ProfileView extends StatefulWidget {
//   ProfileView(this.jumpToJamaah, this.jumpToSubAgen);
//   final void Function() jumpToJamaah;
//   final void Function() jumpToSubAgen;

//   static String thousandSeparator(int val) {
//     return NumberFormat.currency(locale: "in_ID", symbol: '', decimalDigits: 0)
//         .format(val);
//   }

//   @override
//   State<ProfileView> createState() => _ProfileViewState();
// }

// class _ProfileViewState extends BaseState<ProfileView> {
//   String? roles;

//   @override
//   void initState() {
//     getRoles();
//     super.initState();
//   }

//   getRoles() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     roles = prefs.getString(Constant.kSetPrefRoles);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profile = context.watch<ProfileProvider>().profileModel.data;
//     final sosmedModel = context.watch<ProfileProvider>().sosmedModel.data;

//     final home = context.watch<HomeProvider>();
//     final detail = context.watch<DetailJamaahProvider>();
//     final subAgenP = context.watch<SubAgenProvider>();
//     final jamaahP = context.watch<JamaahProvider>();
//     final paketP = context.watch<PaketProvider>();
//     final notifikasi = context.watch<NotifikasiProvider>();
//     final profileP = context.watch<ProfileProvider>();
//     final riwayatTabunganP = context.watch<RiwayatTabunganProvider>();
//     final riwayatKomisiP = context.watch<RiwayatPenarikanKomisiProvider>();
//     Widget header() {
//       return SafeArea(
//         child: Container(
//           margin: EdgeInsets.only(top: 10),
//           width: double.infinity,
//           height: 56,
//           child: Center(
//             child: Text(
//               'Profil',
//               style: Constant.primaryTextStyle
//                   .copyWith(fontSize: 18, color: Colors.white),
//             ),
//           ),
//         ),
//       );
//     }

//     Widget account() {
//       return Container(
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () async {
//                 var file = await CustomImagePicker.selectImageFromGallery();
//                 if (file != null) {
//                   profileP.profilePic = File(file.path);
//                   await profileP.updateProfile();
//                   await context
//                       .read<ProfileProvider>()
//                       .fetchProfile(context: context);
//                 }
//               },
//               child: CircleAvatar(
//                 radius: 32,
//                 backgroundColor: Colors.white,
//                 child: SafeNetworkImage.circle(
//                   url: '${profile?.photoPath ?? ""}',
//                   radius: 58,
//                   errorBuilder: CircleAvatar(
//                     radius: 30,
//                     backgroundImage: AssetImage('assets/images/avatar.png'),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               profile?.name ?? "",
//               style: Constant.primaryTextStyle.copyWith(
//                 fontWeight: Constant.semibold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 6),
//             Text(
//               profile?.email ?? "",
//               style: Constant.primaryTextStyle
//                   .copyWith(fontSize: 12, color: Colors.white),
//             ),
//             SizedBox(height: 6),
//             Text(
//               '${profile?.address} (${profile?.city})',
//               style: Constant.primaryTextStyle
//                   .copyWith(fontSize: 12, color: Colors.white),
//             )
//           ],
//         ),
//       );
//     }

//     Widget info() {
//       return Container(
//         height: 132,
//         margin: EdgeInsets.symmetric(horizontal: 15),
//         padding: EdgeInsets.only(left: 22, right: 22, top: 22),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 1,
//                   blurRadius: 2)
//             ]),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: roles == "agen" ? 2 : 3,
//               child: InkWell(
//                 onTap: () async {
//                   SharedPreferences prefs =
//                       await SharedPreferences.getInstance();

//                   final roles = prefs.getString(Constant.kSetPrefRoles);
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) {
//                       if (roles == "agen") {
//                         return KomisiAgenView();
//                       }
//                       return KomisiSubAgenView(
//                           adminId: home.homeModel.data?.user?.id ?? 0);
//                     },
//                   ));
//                 },
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 45,
//                       width: 45,
//                       child: Image.asset(
//                         'assets/icons/komisi_profil.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Flexible(
//                         //   child: Text('Rp',
//                         //       style: Constant.primaryTextStyle
//                         //           .copyWith(fontSize: 10)),
//                         // ),
//                         // SizedBox(width: 2),
//                         Flexible(
//                           child: Text(
//                               ProfileView.thousandSeparator(
//                                   profile?.balance ?? 0),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: Constant.primaryTextStyle
//                                   .copyWith(fontWeight: Constant.semibold)),
//                         ),
//                       ],
//                     ),
//                     Text('Komisi')
//                   ],
//                 ),
//               ),
//             ),
//             roles != "agen"
//                 ? Expanded(flex: 1, child: SizedBox())
//                 : Expanded(
//                     flex: 3,
//                     child: InkWell(
//                       onTap: widget.jumpToSubAgen,
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 45,
//                             width: 45,
//                             child: Image.asset(
//                               'assets/icons/subagen_profil.png',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                               ProfileView.thousandSeparator(
//                                   profile?.subagentCount ?? 0),
//                               style: Constant.primaryTextStyle
//                                   .copyWith(fontWeight: Constant.semibold)),
//                           Text('Sub Agen')
//                         ],
//                       ),
//                     ),
//                   ),
//             Expanded(
//               flex: roles == "agen" ? 2 : 3,
//               child: InkWell(
//                 onTap: widget.jumpToJamaah,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 45,
//                       width: 45,
//                       child: Image.asset(
//                         'assets/icons/jamaah_profil.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                         ProfileView.thousandSeparator(
//                             profile?.jamaahCount ?? 0),
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold)),
//                     Text('Jamaah')
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     Widget editProfile() {
//       return Container(
//         color: Colors.white,
//         child: Container(
//           height: 155,
//           margin: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 3),
//           padding: EdgeInsets.only(top: 18, left: 20, right: 20, bottom: 18),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 1,
//                     blurRadius: 2)
//               ]),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () async {
//                   handleTap(() async {
//                     dynamic f = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditProfileView(),
//                         ));
//                     if (f != null) {
//                       //await context.read<ProfileProvider>().fetchBank();
//                       // setState(() {});
//                       //await context.read<RegionProvider>().fetchProvince();

//                       final listProvince =
//                           context.read<RegionProvider>().provinceModel.data;
//                       final listCity =
//                           context.read<RegionProvider>().cityModel.data;
//                       final listDistrict =
//                           context.read<RegionProvider>().districtModel.data;

//                       await context.read<ProfileProvider>().fetchProfile(
//                             context: context,
//                             withLoading: true,
//                             provinceList: listProvince,
//                             cityList: listCity,
//                             districtList: listDistrict,
//                           );
//                     }
//                   });
//                 },
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 20,
//                       width: 20,
//                       child: Image.asset(
//                         'assets/icons/edit_profil_icon.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 18),
//                     Expanded(
//                       child: Text(
//                         'Profil',
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold),
//                       ),
//                     ),
//                     Icon(Icons.arrow_forward_ios, size: 12)
//                   ],
//                 ),
//               ),
//               Divider(thickness: 1, color: Colors.grey.shade200),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ChangePasswordView(email: profile?.email ?? ""),
//                       ));
//                 },
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 20,
//                       width: 20,
//                       child: Image.asset(
//                         'assets/icons/ubah_pass_icon.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 18),
//                     Expanded(
//                       child: Text(
//                         'Ubah Password',
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold),
//                       ),
//                     ),
//                     // Spacer(),
//                     Icon(Icons.arrow_forward_ios, size: 12)
//                   ],
//                 ),
//               ),
//               Divider(thickness: 1, color: Colors.grey.shade200),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => DokumenView()));
//                 },
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 25,
//                       width: 25,
//                       child: Image.asset(
//                         'assets/icons/dokumen.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 15),
//                     Expanded(
//                       child: Text(
//                         'Dokumen',
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold),
//                       ),
//                     ),
//                     // Spacer(),
//                     Icon(Icons.arrow_forward_ios, size: 12)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget tentang() {
//       return Container(
//         color: Colors.white,
//         child: Container(
//           height: 220,
//           margin: EdgeInsets.only(left: 15, right: 15, top: 16, bottom: 16),
//           padding: EdgeInsets.only(top: 18, left: 20, right: 20, bottom: 18),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 1,
//                     blurRadius: 2)
//               ]),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WebViewPage(
//                         "Syarat dan Ketentuan",
//                         "https://${Constant.DOMAIN2}/webview?slug=panduan-pengguna",
//                       ),
//                     ),
//                   );
//                 },
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 20,
//                       width: 20,
//                       child: Image.asset(
//                         'assets/icons/snk.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 18),
//                     Expanded(
//                       child: Text(
//                         'Syarat dan Ketentuan',
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold),
//                       ),
//                     ),
//                     // Spacer(),
//                     Icon(Icons.arrow_forward_ios, size: 12)
//                   ],
//                 ),
//               ),
//               Divider(thickness: 1, color: Colors.grey.shade200),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WebViewPage(
//                         "Kebijakan Privasi",
//                         "https://${Constant.DOMAIN2}/webview?slug=kebijakan-privasi",
//                       ),
//                     ),
//                   );
//                 },
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 20,
//                       width: 20,
//                       child: Image.asset(
//                         'assets/icons/kebijakan_privasi.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 18),
//                     Expanded(
//                       child: Text(
//                         'Kebijakan Privasi',
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold),
//                       ),
//                     ),
//                     // Spacer(),
//                     Icon(Icons.arrow_forward_ios, size: 12)
//                   ],
//                 ),
//               ),
//               Divider(thickness: 1, color: Colors.grey.shade200),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ContactProfileView()));
//                 },
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 20,
//                       width: 20,
//                       child: Image.asset(
//                         'assets/icons/kontak_icon.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 18),
//                     Expanded(
//                       child: Text(
//                         'Kontak',
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold),
//                       ),
//                     ),
//                     // Spacer(),
//                     Icon(Icons.arrow_forward_ios, size: 12)
//                   ],
//                 ),
//               ),
//               Divider(thickness: 1, color: Colors.grey.shade200),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => AboutView()));
//                 },
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 20,
//                       width: 20,
//                       child: Image.asset(
//                         'assets/icons/tentang_icon.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 18),
//                     Expanded(
//                       child: Text(
//                         'Tentang Chatour Travel',
//                         style: Constant.primaryTextStyle
//                             .copyWith(fontWeight: Constant.semibold),
//                       ),
//                     ),
//                     // Spacer(),
//                     Icon(Icons.arrow_forward_ios, size: 12)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget sosmed() {
//       return Container(
//         color: Colors.white,
//         child: Container(
//           color: Colors.white,
//           margin: EdgeInsets.only(top: 24, left: 54, right: 54),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () {
//                   if (sosmedModel?.tiktok != null) {
//                     context
//                         .read<ProfileProvider>()
//                         .goToUrl(sosmedModel?.tiktok ?? "");
//                   }
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   child: Image.asset(
//                     'assets/icons/tiktok.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   if (sosmedModel?.youtube != null) {
//                     context
//                         .read<ProfileProvider>()
//                         .goToUrl(sosmedModel?.youtube ?? "");
//                   }
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   child: Image.asset(
//                     'assets/icons/youtube.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   if (sosmedModel?.instagram != null) {
//                     context
//                         .read<ProfileProvider>()
//                         .goToUrl(sosmedModel?.instagram ?? "");
//                   }
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   child: Image.asset(
//                     'assets/icons/instagram.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   if (sosmedModel?.facebook != null) {
//                     context
//                         .read<ProfileProvider>()
//                         .goToUrl(sosmedModel?.facebook ?? "");
//                   }
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   child: Image.asset(
//                     'assets/icons/facebook.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: RefreshIndicator(
//         color: Constant.primaryColor,
//         onRefresh: () async {
//           await context.read<RegionProvider>().fetchProvince();
//           final listProvince =
//               context.read<RegionProvider>().provinceModel.data;
//           final listCity = context.read<RegionProvider>().cityModel.data;
//           final listDistrict =
//               context.read<RegionProvider>().districtModel.data;

//           await context.read<ProfileProvider>().fetchProfile(
//                 withLoading: true,
//                 context: context,
//                 provinceList: listProvince,
//                 cityList: listCity,
//                 districtList: listDistrict,
//               );
//         },
//         child: ListView(
//           children: [
//             Container(
//               color: Colors.white,
//               height: 398,
//               child: Stack(
//                 children: [
//                   Container(
//                     width: 100.w,
//                     height: 283,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(
//                               'assets/images/BG Home.png',
//                             ),
//                             fit: BoxFit.fitWidth)),
//                   ),
//                   Positioned(top: 10, left: 0, right: 0, child: header()),
//                   Positioned(top: 90, left: 0, right: 0, child: account()),
//                   Positioned(top: 250, left: 0, right: 0, child: info()),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   editProfile(),
//                   tentang(),
//                   sosmed(),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               child: Container(
//                 color: Colors.white,
//                 margin:
//                     EdgeInsets.only(top: 32, left: 12, right: 12, bottom: 12),
//                 child: CustomButton.mainButton(
//                   'Keluar Akun',
//                   () async => await Utils.showYesNoDialog(
//                     context: context,
//                     title: "Konfirmasi",
//                     desc: "Apakah Anda Yakin Ingin Keluar?",
//                     yesCallback: () => handleTap(() async {
//                       Navigator.pop(context);
//                       try {
//                         final result =
//                             await context.read<AuthProvider>().logout();
//                         if (result.success == true) {
//                           home.setHomeModel = HomeModel();
//                           jamaahP.jamaahListModel = JamaahListModel();
//                           jamaahP.jamaahListSubAgenModel =
//                               JamaahListSubAgenModel();

//                           paketP.paketUmrohModel = PaketModel();
//                           paketP.paketHajiModel = PaketModel();
//                           paketP.paketDetailModel = PaketDetailModel();
//                           subAgenP.subagenmodel = SubAgenModel();
//                           detail.jamaahDetailModel = JamaahDetailModel();
//                           notifikasi.notifikasiModel = NotifikasiModel();
//                           profileP.profileModel = ProfileModel();
//                           riwayatKomisiP.riwayat =
//                               RiwayatPenarikanKomisiModel();
//                           riwayatTabunganP.riwayatTabunganModel =
//                               RiwayatTabunganModel();
//                           Navigator.pushReplacementNamed(context, '/login');
//                         } else {
//                           Utils.showFailed(msg: result.message);
//                         }
//                       } catch (e) {
//                         Utils.showFailed(
//                             msg: e.toString().toLowerCase().contains("doctype")
//                                 ? "Maaf, Terjadi Galat!"
//                                 : "$e");
//                       }
//                     }),
//                     noCallback: () => Navigator.pop(context),
//                   ),
//                 ),
//               ),
//             ),
//             Container(color: Colors.white, height: 14)
//           ],
//         ),
//       ),
//     );
//   }
// }
