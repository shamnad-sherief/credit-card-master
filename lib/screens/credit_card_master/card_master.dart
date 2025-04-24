import 'package:flutter/material.dart' hide Card;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/card_model.dart';
import '../../provider/app_data_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/constants.dart';
import 'bank_dropdown.dart';
import 'custom_text_form_field.dart';
import 'date_picker_field.dart';
import 'card_validator.dart';
import 'card_preview.dart';

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
  final _validator = CardValidator();
  String? _backgroundImagePath; // To hold the selected image path
  final ImagePicker _picker = ImagePicker();

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
      _backgroundImagePath =
          widget.card!.backgroundImagePath; // Load existing image
    } else {
      final today = DateTime.now();
      _generationDateController.text = _validator.formatDate(today);
      _expiryDateController.text = _validator.formatDate(today);
      _paymentFinalDateController.text =
          _validator.formatDate(today.add(const Duration(days: 30)));
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _backgroundImagePath = image.path; // Update image path
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
        backgroundImagePath: _backgroundImagePath, // Save image path
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
          ValueListenableBuilder(
            valueListenable: _cardNumberController,
            builder: (context, _, __) => ValueListenableBuilder(
              valueListenable: _accountHolderNameController,
              builder: (context, _, __) => ValueListenableBuilder(
                valueListenable: _expiryDateController,
                builder: (context, _, __) => ValueListenableBuilder(
                  valueListenable: _cvvController,
                  builder: (context, _, __) => CardPreview(
                    bankName: _selectedBank,
                    cardNumber: _cardNumberController.text,
                    cardHolderName: _accountHolderNameController.text,
                    expiryDate: _expiryDateController.text,
                    cvv: _cvvController.text,
                    backgroundImagePath:
                        _backgroundImagePath, // Pass image path
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.card != null ? 'Edit Card Details' : 'Card Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          BankDropdown(
            selectedBank: _selectedBank,
            onChanged: (value) => setState(() => _selectedBank = value),
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _accountNumberController,
            labelText: 'Account Number',
            hintText: 'e.g., 1234567890',
            isDarkMode: isDarkMode,
            validator: _validator.validateAccountNumber,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _cardNumberController,
            labelText: 'Card Number',
            hintText: 'e.g., 1234 5678 9012 3456',
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.number,
            inputFormatters: _validator.cardNumberFormatters,
            validator: _validator.validateCardNumber,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _accountHolderNameController,
            labelText: 'Account Holder Name',
            hintText: 'e.g., John Doe',
            isDarkMode: isDarkMode,
            validator: _validator.validateAccountHolderName,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            controller: _cvvController,
            labelText: 'CVV',
            hintText: 'e.g., 123',
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.number,
            maxLength: 3,
            validator: _validator.validateCvv,
          ),
          const SizedBox(height: 16),
          DatePickerField(
            controller: _expiryDateController,
            labelText: 'Expiry Date',
            hintText: 'MMM YYYY, e.g., Dec 2025',
            isDarkMode: isDarkMode,
            initialDate: widget.card?.expiryDate,
            validator: _validator.validateExpiryDate,
          ),
          const SizedBox(height: 16),
          DatePickerField(
            controller: _generationDateController,
            labelText: 'Generation Date',
            hintText: 'MMM YYYY, e.g., Apr 2025',
            isDarkMode: isDarkMode,
            initialDate: widget.card?.generationDate,
            validator: _validator.validateGenerationDate,
          ),
          const SizedBox(height: 16),
          DatePickerField(
            controller: _paymentFinalDateController,
            labelText: 'Payment Final Date',
            hintText: 'MMM YYYY, e.g., May 2025',
            isDarkMode: isDarkMode,
            initialDate: widget.card?.paymentFinalDate,
            validator: (value) => _validator.validatePaymentFinalDate(
                value, _generationDateController.text),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor:
                  isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Pick Background Image',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.blueGrey[900] : kPrimaryColor,
              ),
            ),
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
