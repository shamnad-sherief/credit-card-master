import 'package:credit_card_master/screens/credit_card_master/card_master.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:provider/provider.dart';

import '../provider/app_data_provider.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appDataProvider = Provider.of<AppDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<AppDataProvider>(context, listen: false).goBack();
          },
        ),
        title: const Text("Credit Card Master"),
        centerTitle: true,
      ),
      body: CardMasterPage(
        card: appDataProvider.editCard,
        index: appDataProvider.editIndex,
      ),
    );
  }
}
