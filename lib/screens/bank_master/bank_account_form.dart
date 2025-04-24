import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../models/bank_accounts.dart';
import '../../provider/theme_provider.dart';
import '../../utils/constants.dart';

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

class BankAccountFormSheet extends StatefulWidget {
  final BankAccount? bankAccount;
  final int? index;

  const BankAccountFormSheet({super.key, this.bankAccount, this.index});

  @override
  State<BankAccountFormSheet> createState() => _BankAccountFormSheetState();
}

class _BankAccountFormSheetState extends State<BankAccountFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bankNameController;
  String? _bankImagePath;

  @override
  void initState() {
    super.initState();
    _bankNameController =
        TextEditingController(text: widget.bankAccount?.bankName ?? '');
    _bankImagePath = widget.bankAccount?.bankImage.isNotEmpty ?? false
        ? widget.bankAccount!.bankImage
        : null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.path.split('/').last;
      final savedImage =
          await File(pickedFile.path).copy('${directory.path}/$fileName');
      setState(() {
        _bankImagePath = savedImage.path;
      });
    }
  }

  Future<void> _saveBankAccount() async {
    if (_formKey.currentState!.validate()) {
      final bankAccount = BankAccount(
        bankName: _bankNameController.text,
        bankImage: _bankImagePath ?? '',
      );
      final box = Hive.box<BankAccount>('bankAccounts');
      if (widget.index != null) {
        await box.putAt(widget.index!, bankAccount); // Update existing
      } else {
        await box.add(bankAccount); // Add new
      }
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(widget.index != null
                  ? 'Bank Account Updated'
                  : 'Bank Account Added')),
        );
      }
    }
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.blueGrey[800]!, Colors.blueGrey[600]!]
              : [kPrimaryColor, kGradientColor2],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.index != null
                      ? 'Edit Bank Account'
                      : 'Add Bank Account',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _bankNameController,
              decoration: InputDecoration(
                labelText: 'Bank Name',
                hintText: 'e.g., Chase Bank',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                labelStyle: TextStyle(color: Colors.white70),
                hintStyle: TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a bank name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _bankImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_bankImagePath!),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: const Icon(Icons.image, color: Colors.white54),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload, size: 20),
                    label: const Text('Pick Bank Logo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor:
                          isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveBankAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor:
                      isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  widget.index != null ? 'Update' : 'Add Account',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
