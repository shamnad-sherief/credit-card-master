import 'package:credit_card_master/models/bank_accounts.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'models/card_model.dart';
import 'provider/app_data_provider.dart';
import 'provider/theme_provider.dart';
import 'screens/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(BankAccountAdapter());
  Hive.registerAdapter(CardAdapter());
  await Hive.openBox<BankAccount>('bankAccounts');
  await Hive.openBox<Card>('cards');
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider<AppDataProvider>(
        create: (_) => AppDataProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.getTheme(),
        home: const MainPage(),
      ),
    );
  }
}
