import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/bank_accounts.dart';
import '../../provider/app_data_provider.dart';
import '../../utils/constants.dart';

class BankDropdown extends StatelessWidget {
  final String? selectedBank;
  final ValueChanged<String?>? onChanged;
  final bool isDarkMode;

  const BankDropdown({
    super.key,
    required this.selectedBank,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: ValueListenableBuilder(
        valueListenable: Hive.box<BankAccount>('bankAccounts').listenable(),
        builder: (context, Box<BankAccount> box, _) {
          if (box.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No banks available. Add a bank to continue.',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<AppDataProvider>(context, listen: false)
                        .onBottomNavTapped(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:
                        isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Add Bank',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
                    ),
                  ),
                ),
              ],
            );
          }
          final banks = box.values.toList();
          return DropdownButtonFormField<String>(
            alignment: AlignmentDirectional.bottomCenter,
            value: selectedBank,
            decoration: InputDecoration(
              labelText: 'Select Bank',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintText: 'Choose a bank',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            dropdownColor: isDarkMode
                ? Colors.blueGrey[700]
                : kPrimaryColor.withOpacity(0.9),
            isExpanded: false,
            items: banks
                .map((bank) => DropdownMenuItem(
                      value: bank.bankName,
                      child: Text(
                        bank.bankName,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
            validator: (value) => value == null ? 'Please select a bank' : null,
          );
        },
      ),
    );
  }
}
