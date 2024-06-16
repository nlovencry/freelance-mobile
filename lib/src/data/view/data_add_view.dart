import 'package:flutter/material.dart';
import 'package:mata/src/tower/provider/tower_provider.dart';
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
    context.read<TowerProvider>().fetchTower(context);
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
                  ...context.read<DataAddProvider>().detailUnit(),
                  ...context.read<DataAddProvider>().shaftForm(),
                  ...context.read<DataAddProvider>().upperForm(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: CustomButton.mainButton('Simpan', () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => ShaftView()));
              }),
            )
          ],
        ),
      ),
    );
  }
}
