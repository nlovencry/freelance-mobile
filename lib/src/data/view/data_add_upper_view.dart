import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  void initState() {
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
            Expanded(child: ListView(children: [...p.upperForm(context)])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: CustomButton.mainButton('Selanjutnya', () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => ShaftView()));
              }),
            ),
          ],
        ),
      ),
    );
  }
}
