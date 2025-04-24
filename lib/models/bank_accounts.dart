import 'package:hive/hive.dart';

part 'bank_accounts.g.dart';

@HiveType(typeId: 0)
class BankAccount extends HiveObject {
  @HiveField(0)
  final String bankName;

  @HiveField(1)
  final String bankImage;

  BankAccount({
    required this.bankName,
    required this.bankImage,
  });
}
