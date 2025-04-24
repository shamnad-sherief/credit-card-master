import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui'; // For BackdropFilter

class CardPreview extends StatelessWidget {
  final String? bankName;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final String? backgroundImagePath; // New parameter for image path

  const CardPreview({
    super.key,
    this.bankName,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    this.backgroundImagePath,
  });

  String _maskCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cardNumber.length < 4) return cardNumber.padRight(16, 'X');
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  String _formatExpiryDate(String expiry) {
    if (expiry.isEmpty ||
        !RegExp(r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d{4}$')
            .hasMatch(expiry)) {
      return 'XX/XX';
    }
    try {
      final date = DateFormat('MMM yyyy').parseStrict(expiry);
      return DateFormat('MM/yy').format(date);
    } catch (e) {
      return 'XX/XX';
    }
  }

  TextStyle _textStyle(
      {double fontSize = 16, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: fontWeight,
      shadows: const [
        Shadow(
          color: Colors.black87,
          blurRadius: 3,
          offset: Offset(1, 1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: backgroundImagePath != null
              ? DecorationImage(
                  image: FileImage(File(backgroundImagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
          gradient: backgroundImagePath == null
              ? LinearGradient(
                  colors: [Colors.green[100]!, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background blurred circles (optional with image)
            if (backgroundImagePath == null) ...[
              Positioned(
                top: 20,
                left: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 80,
                right: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            // Card content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bank Name and Remarks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bankName ?? 'BANK NAME',
                        style: _textStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Remarks',
                        style: _textStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Card Number
                  Text(
                    _maskCardNumber(cardNumber),
                    style: _textStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Card Holder, Expiry, and CVV
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Holder',
                            style: _textStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cardHolderName.isEmpty
                                ? 'John Doe'
                                : cardHolderName,
                            style: _textStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Expiry: ',
                                style: _textStyle(fontSize: 12),
                              ),
                              Text(
                                _formatExpiryDate(expiryDate),
                                style: _textStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'CVV: ',
                                style: _textStyle(fontSize: 12),
                              ),
                              Text(
                                cvv.isEmpty ? 'XXX' : cvv,
                                style: _textStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
