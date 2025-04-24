import 'dart:io';

import 'package:credit_card_master/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../models/bank_accounts.dart';
import '../provider/app_data_provider.dart';
import 'bank_master/bank_account_form.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  void showBankAccountFormSheet(BuildContext context,
      {BankAccount? bankAccount, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BankAccountFormSheet(bankAccount: bankAccount, index: index);
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Bank Account'),
            content: const Text(
                'Are you sure you want to delete this bank account?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<AppDataProvider>(context, listen: false).goBack();
          },
        ),
        title: const Text("Bank Master"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: kPrimaryColor,
                      ),
                      SizedBox(width: 10),
                      Text("Add Tour"),
                    ],
                  ),
                  IconButton(
                    constraints:
                        const BoxConstraints(maxWidth: 40, minWidth: 40),
                    onPressed: () {
                      showBankAccountFormSheet(context);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: Hive.box<BankAccount>('bankAccounts').listenable(),
            builder: (context, Box<BankAccount> box, _) {
              if (box.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No bank accounts added',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Column(
                children: List.generate(
                  box.length,
                  (index) {
                    final bankAccount = box.getAt(index)!;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        // leading: bankAccount.bankImage.isNotEmpty
                        //     ? Image.file(
                        //         File(bankAccount.bankImage),
                        //         width: 40,
                        //         height: 40,
                        //         fit: BoxFit.cover,
                        //       )
                        //     : const Icon(Icons.account_balance),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: bankAccount.bankImage.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(bankAccount.bankImage),
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.account_balance),
                        ),
                        title: Text(bankAccount.bankName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey[700]),
                              onPressed: () {
                                showBankAccountFormSheet(
                                  context,
                                  bankAccount: bankAccount,
                                  index: index,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                if (await _confirmDelete(context)) {
                                  box.deleteAt(index);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
