import 'package:flutter/material.dart';
import 'package:mata/src/data/view/data_add_clutch_view.dart';
import 'package:provider/provider.dart';
import '../../../utils/utils.dart';
import '../provider/data_add_provider.dart';
import '../../shaft/view/shaft_view.dart';
import '../../../common/component/custom_appbar.dart';
import '../../../common/component/custom_button.dart';

class DataAddUpperView extends StatefulWidget {
  const DataAddUpperView({super.key});

  @override
  State<DataAddUpperView> createState() => _DataAddUpperViewState();
}

class _DataAddUpperViewState extends State<DataAddUpperView> {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<DataAddProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(context, "Tambah Data Upper"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Expanded(child: ListView(children: [...p.upperForm(context)])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: CustomButton.mainButton('Selanjutnya', () {
                final dataP = context.read<DataAddProvider>();
                FocusManager.instance.primaryFocus?.unfocus();
                String? msg;
                for (int i = 0; i < dataP.dataUpperC.length; i++) {
                  for (int j = 0; j < dataP.dataUpperC[i].length; j++) {
                    if (dataP.dataUpperC[i][j].text.isEmpty) {
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => DataAddClutchView()));
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
