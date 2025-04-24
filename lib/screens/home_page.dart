import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/card_model.dart' as card_model;
import '../../provider/theme_provider.dart';
import '../../provider/app_data_provider.dart';
import '../../utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _maskCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  void _deleteCard(BuildContext context, Box<card_model.Card> box, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card'),
        content: const Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              box.deleteAt(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Card Deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CredHub - Credit Card Manager"),
        centerTitle: true,
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<card_model.Card>('cards').listenable(),
          builder: (context, Box<card_model.Card> box, _) {
            if (box.isEmpty) {
              return Center(
                child: Text(
                  'No cards added',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white70 : Colors.grey[800],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final card = box.getAt(index)!;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: isDarkMode
                      ? Colors.blueGrey[800]
                      : Colors.white.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      card.bankName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          _maskCardNumber(card.cardNumber),
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isDarkMode ? Colors.white70 : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.accountHolderName,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDarkMode ? Colors.white60 : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Expires: ${card.expiryDate}',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDarkMode ? Colors.white60 : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: isDarkMode
                                ? kPrimaryColor.withOpacity(0.8)
                                : kPrimaryColor,
                            size: 24,
                          ),
                          onPressed: () {
                            Provider.of<AppDataProvider>(context, listen: false)
                                .navigateToEditCard(2, card, index);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: isDarkMode
                                ? Colors.red.withOpacity(0.8)
                                : Colors.red,
                            size: 24,
                          ),
                          onPressed: () => _deleteCard(context, box, index),
                        ),
                        Icon(
                          Icons.credit_card,
                          color: isDarkMode
                              ? kPrimaryColor.withOpacity(0.8)
                              : kPrimaryColor,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
