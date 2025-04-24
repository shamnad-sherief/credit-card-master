import 'package:hive/hive.dart';

part 'card_model.g.dart';

@HiveType(typeId: 1)
class Card extends HiveObject {
  @HiveField(0)
  final String bankName;

  @HiveField(1)
  final String accountNumber;

  @HiveField(2)
  final String cardNumber;

  @HiveField(3)
  final String accountHolderName;

  @HiveField(4)
  final String cvv;

  @HiveField(5)
  final String expiryDate;

  @HiveField(6)
  final String generationDate;

  @HiveField(7)
  final String paymentFinalDate;

  @HiveField(8)
  String? backgroundImagePath;

  Card({
    required this.bankName,
    required this.accountNumber,
    required this.cardNumber,
    required this.accountHolderName,
    required this.cvv,
    required this.expiryDate,
    required this.generationDate,
    required this.paymentFinalDate,
    this.backgroundImagePath,
  });
}
