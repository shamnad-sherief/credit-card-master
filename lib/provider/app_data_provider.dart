import 'package:flutter/material.dart' hide Card;

import '../models/card_model.dart';
import '../screens/fourth_page.dart';
import '../screens/home_page.dart';
import '../screens/second_page.dart';
import '../screens/third_page.dart';

class AppDataProvider extends ChangeNotifier {
  int _bottomNavIndex = 0;
  final List<int> _navigationStack = [0]; // Start with Home
  Card? _editCard;
  int? _editIndex;

  List<IconData> iconList = [
    Icons.home,
    Icons.account_balance,
    Icons.credit_card,
    Icons.settings,
  ];

  final List<Widget> pages = [
    const HomePage(),
    const SecondPage(),
    const ThirdPage(),
    const FourthPage(),
  ];

  Card? get editCard => _editCard;
  int? get editIndex => _editIndex;

  int get bottomNavIndex => _bottomNavIndex;
  List<int> get navigationStack =>
      List.unmodifiable(_navigationStack); // Read-only

  void onBottomNavTapped(int index) {
    if (_bottomNavIndex != index) {
      _bottomNavIndex = index;
      // Add to stack only if not revisiting the same page
      if (_navigationStack.contains(index)) {
        _navigationStack.remove(index);
      }

      _navigationStack.add(index); // Add new page to stack
    }
    notifyListeners();
  }

  bool goBack() {
    if (_navigationStack.length > 1 || _bottomNavIndex != 0) {
      if (_bottomNavIndex == 2) {
        clearEditCard(); // Clear edit card when going back from ThirdPage
      }
      debugPrint(_bottomNavIndex.toString());
      debugPrint(_navigationStack.toString());
      _navigationStack.removeLast(); // Remove current page
      _bottomNavIndex = _navigationStack.last; // Set to previous page
      debugPrint(_navigationStack.toString());
      notifyListeners();
      return true;
    }
    return false;
  }

  void navigateToEditCard(int thirdPageIndex, Card card, int index) {
    _editCard = card;
    _editIndex = index;
    onBottomNavTapped(thirdPageIndex); // Navigate to ThirdPage
  }

  void clearEditCard() {
    _editCard = null;
    _editIndex = null;
  }
}
