import 'package:flutter/material.dart';
import 'package:mata/common/base/base_state.dart';
import 'package:provider/provider.dart';
import '../../../utils/utils.dart';
import '../provider/data_add_provider.dart';
import '../../shaft/view/shaft_view.dart';
import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_button.dart';

class DataAddTurbineView extends StatefulWidget {
  const DataAddTurbineView({super.key});

  @override
  State<DataAddTurbineView> createState() => _DataAddTurbineViewState();
}

class _DataAddTurbineViewState extends BaseState<DataAddTurbineView> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<DataAddProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Tambah Data Turbine"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Expanded(child: ListView(children: [...p.turbineForm(context)])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: CustomButton.mainButton('Selanjutnya', () async {
                final dataP = context.read<DataAddProvider>();
                FocusManager.instance.primaryFocus?.unfocus();
                String? msg;
                for (int i = 0; i < dataP.dataTurbineC.length; i++) {
                  for (int j = 0; j < dataP.dataTurbineC[i].length; j++) {
                    if (dataP.dataTurbineC[i][j].text.isEmpty) {
                      msg = 'Harap isi data yang kosong';
                      break;
                    }
                  }
                  if (msg != null) break;
                }
                if (msg != null) {
                  Utils.showFailed(msg: msg);
                  return;
                } else {
                  await Utils.showYesNoDialog(
                    context: context,
                    title: "Konfirmasi",
                    desc: "Apakah Data Anda Sudah Benar?",
                    yesCallback: () => handleTap(() async {
                      Navigator.pop(context);
                      try {
                        final response = await p.createTurbines();
                        if (response.Success == true) {
                          Utils.showSuccess(msg: response.Message ?? "Sukses");
                          await Future.delayed(Duration(seconds: 2));
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => ShaftView()));
                        } else {
                          Utils.showFailed(msg: response.Message ?? "Error");
                        }
                      } catch (e) {
                        Utils.showFailed(
                            msg: e.toString().toLowerCase().contains("doctype")
                                ? "Maaf, Terjadi Galat!"
                                : "$e");
                      }
                    }),
                    noCallback: () => Navigator.pop(context),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
