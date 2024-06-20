import 'package:flutter/material.dart';
import 'package:mata/src/data/view/data_add_upper_view.dart';
import 'package:mata/utils/utils.dart';
import 'package:provider/provider.dart';
import '../provider/data_add_provider.dart';
import '../../shaft/view/shaft_view.dart';
import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_button.dart';

class DataAddView extends StatefulWidget {
  const DataAddView({super.key});

  @override
  State<DataAddView> createState() => _DataAddViewState();
}

class _DataAddViewState extends State<DataAddView> {
  @override
  void initState() {
    final p = context.read<DataAddProvider>();
    p.fetchTower(context);
    p.resetData();
    p.generateAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DataAddProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Tambah Data"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...p.detailUnit(),
                  ...p.shaftForm(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: CustomButton.mainButton('Selanjutnya', () {
                final dataP = context.read<DataAddProvider>();
                FocusManager.instance.primaryFocus?.unfocus();
                String? msg;
                if (dataP.selectedTower == null) msg = 'Harap Pilih PLTA';
                if (dataP.genBearingKoplingC.text.isEmpty)
                  msg = 'Harap Isi Gen Bearing Kopling';
                if (dataP.koplingTurbinC.text.isEmpty)
                  msg = 'Harap Isi Kopling Turbin';
                if (msg != null) {
                  Utils.showFailed(msg: msg);
                  return;
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => DataAddUpperView()));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
