import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:credit_card_master/provider/app_data_provider.dart';
import 'package:credit_card_master/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        final result =
            Provider.of<AppDataProvider>(context, listen: false).goBack();
        if (!result) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            Theme.of(context).canvasColor, // Adjusted for theme mode
        body: Consumer<AppDataProvider>(builder: (context, provider, child) {
          return Center(
            child: provider.pages[provider.bottomNavIndex],
          );
        }),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [kPrimaryColor, kGradientColor2, kGradientColor3],
            ),
            boxShadow: const [
              BoxShadow(
                color: kPrimaryColor,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(32),
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            focusElevation: 1,
            elevation: 0,
            splashColor: Colors.transparent,
            hoverElevation: 0,
            highlightElevation: 0,
            onPressed: () {
              // navigate to the add page
              Provider.of<AppDataProvider>(context, listen: false)
                  .clearEditCard();
              Provider.of<AppDataProvider>(context, listen: false)
                  .onBottomNavTapped(2);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar:
            Consumer<AppDataProvider>(builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.only(
              bottom: 5,
            ),
            color: Colors.transparent,
            child: AnimatedBottomNavigationBar.builder(
              backgroundColor: bottomNavTheme.backgroundColor,
              itemCount: provider.iconList.length,
              tabBuilder: (int index, bool isActive) {
                return Icon(
                  provider.iconList[index],
                  size: 28,
                  color: isActive ? kPrimaryColor : Colors.grey,
                );
              },
              activeIndex: provider.bottomNavIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.verySmoothEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
              onTap: provider.onBottomNavTapped,
            ),
          );
        }),
      ),
    );
  }
}
