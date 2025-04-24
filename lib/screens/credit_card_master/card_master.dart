import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/bank_accounts.dart';
import '../../models/card_model.dart';
import '../../provider/app_data_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/constants.dart';

class CardMasterPage extends StatefulWidget {
  final Card? card;
  final int? index;

  const CardMasterPage({super.key, this.card, this.index});

  @override
  State<CardMasterPage> createState() => _CardMasterPageState();
}

class _CardMasterPageState extends State<CardMasterPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _generationDateController = TextEditingController();
  final _paymentFinalDateController = TextEditingController();
  String? _selectedBank;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedExpiryDate = DateTime.now();
  DateTime _selectedPaymentFinalDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _selectedBank = widget.card!.bankName;
      _accountNumberController.text = widget.card!.accountNumber;
      _cardNumberController.text = widget.card!.cardNumber;
      _accountHolderNameController.text = widget.card!.accountHolderName;
      _cvvController.text = widget.card!.cvv;
      _expiryDateController.text = widget.card!.expiryDate;
      _generationDateController.text = widget.card!.generationDate;
      _paymentFinalDateController.text = widget.card!.paymentFinalDate;
      try {
        _selectedExpiryDate =
            DateFormat('MMM yyyy').parseStrict(widget.card!.expiryDate);
        _selectedDate =
            DateFormat('MMM yyyy').parseStrict(widget.card!.generationDate);
        _selectedPaymentFinalDate =
            DateFormat('MMM yyyy').parseStrict(widget.card!.paymentFinalDate);
      } catch (e) {
        _selectedExpiryDate = DateTime.now();
        _selectedDate = DateTime.now();
        _selectedPaymentFinalDate = DateTime.now();
      }
    } else {
      final today = DateTime.now();
      _generationDateController.text = DateFormat('MMM yyyy').format(today);
      _expiryDateController.text = DateFormat('MMM yyyy').format(today);
      _paymentFinalDateController.text =
          DateFormat('MMM yyyy').format(today.add(const Duration(days: 30)));
    }
  }

  bool _validateLuhn(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cardNumber.length != 16) return false;
    int sum = 0;
    bool isEven = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      if (isEven) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      isEven = !isEven;
    }
    return sum % 10 == 0;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: Colors.grey,
              onSurface: Colors.blue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _generationDateController.text =
            DateFormat('MMM yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: Colors.grey,
              onSurface: Colors.blue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedExpiryDate) {
      setState(() {
        _selectedExpiryDate = pickedDate;
        _expiryDateController.text = DateFormat('MMM yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectPaymentFinalDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedPaymentFinalDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: Colors.grey,
              onSurface: Colors.blue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedPaymentFinalDate) {
      setState(() {
        _selectedPaymentFinalDate = pickedDate;
        _paymentFinalDateController.text =
            DateFormat('MMM yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final card = Card(
        bankName: _selectedBank!,
        accountNumber: _accountNumberController.text,
        cardNumber: _cardNumberController.text,
        accountHolderName: _accountHolderNameController.text,
        cvv: _cvvController.text,
        expiryDate: _expiryDateController.text,
        generationDate: _generationDateController.text,
        paymentFinalDate: _paymentFinalDateController.text,
      );
      final box = Hive.box<Card>('cards');
      if (widget.index != null) {
        await box.putAt(widget.index!, card);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Card Updated'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Provider.of<AppDataProvider>(context, listen: false).clearEditCard();
        }
      } else {
        await box.add(card);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Card Added'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
      Provider.of<AppDataProvider>(context, listen: false).onBottomNavTapped(0);
    }
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _cardNumberController.dispose();
    _accountHolderNameController.dispose();
    _cvvController.dispose();
    _expiryDateController.dispose();
    _generationDateController.dispose();
    _paymentFinalDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode();

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.card != null ? 'Edit Card Details' : 'Card Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<BankAccount>('bankAccounts').listenable(),
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
                              .onBottomNavTapped(
                                  1); // Navigate to bank creation page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'Add Bank',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.blueGrey[900]
                                : kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                final banks = box.values.toList();
                return DropdownButtonFormField<String>(
                  alignment: AlignmentDirectional.bottomCenter,
                  value: _selectedBank,
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
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBank = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a bank' : null,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accountNumberController,
            decoration: InputDecoration(
              labelText: 'Account Number',
              hintText: 'e.g., 1234567890',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            validator: (value) =>
                value!.isEmpty ? 'Please enter account number' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNumberController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: 'e.g., 1234 5678 9012 3456',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Please enter card number';
              if (!_validateLuhn(value)) return 'Invalid card number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accountHolderNameController,
            decoration: InputDecoration(
              labelText: 'Account Holder Name',
              hintText: 'e.g., John Doe',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please enter account holder name';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                return 'Only letters and spaces allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cvvController,
            decoration: InputDecoration(
              labelText: 'CVV',
              hintText: 'e.g., 123',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            keyboardType: TextInputType.number,
            maxLength: 3,
            validator: (value) {
              if (value!.isEmpty) return 'Please enter CVV';
              if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                return 'CVV must be 3 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _expiryDateController,
            readOnly: true,
            onTap: () => _selectExpiryDate(context),
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              hintText: 'MMM YYYY, e.g., Dec 2025',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please select an expiry date';
              if (!RegExp(
                      r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}$')
                  .hasMatch(value)) {
                return 'Format must be MMM YYYY';
              }
              try {
                final date = DateFormat('MMM yyyy').parseStrict(value);
                final now = DateTime.now();
                if (date.isBefore(DateTime(now.year, now.month, 1))) {
                  return 'Card is expired';
                }
              } catch (e) {
                return 'Invalid date format';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _generationDateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              labelText: 'Generation Date',
              hintText: 'MMM YYYY, e.g., Apr 2025',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please select a generation date';
              if (!RegExp(
                      r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}$')
                  .hasMatch(value)) {
                return 'Format must be MMM YYYY';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _paymentFinalDateController,
            readOnly: true,
            onTap: () => _selectPaymentFinalDate(context),
            decoration: InputDecoration(
              labelText: 'Payment Final Date',
              hintText: 'MMM YYYY, e.g., May 2025',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[800],
              ),
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white54 : Colors.grey[600],
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
            ),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please select a payment final date';
              if (!RegExp(
                      r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}$')
                  .hasMatch(value)) {
                return 'Format must be MMM YYYY';
              }
              try {
                final genDate = DateFormat('MMM yyyy')
                    .parseStrict(_generationDateController.text);
                final payDate = DateFormat('MMM yyyy').parseStrict(value);
                if (payDate.isBefore(genDate) ||
                    (payDate.year == genDate.year &&
                        payDate.month == genDate.month)) {
                  return 'Must be after generation date';
                }
              } catch (e) {
                return 'Invalid date format';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _saveCard,
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
                widget.card != null ? 'Update Card' : 'Add Card',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
