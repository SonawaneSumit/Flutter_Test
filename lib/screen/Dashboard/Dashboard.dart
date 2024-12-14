// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screen/Profile/ProfileScreen.dart';
import 'package:fluttertest/screen/userList/UserList.dart';
import 'package:fluttertest/utils/Theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var appBarTitle = '';
  final List<String> tabTitles = ['Home', 'Profile'];
  int _selectedIndex = 0;
  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateAppBarTitle() {
    // Ensure that the tab index is within the bounds of tabTitles list
    if (mounted) {
      setState(() {
        if (_selectedIndex >= 0 && _selectedIndex < tabTitles.length) {
          appBarTitle = tabTitles[_selectedIndex];
        }
      });
    }
  }

  final List<Widget> _pages = [UserListScreen(), const ProfileScreen()];

  @override
  void initState() {
    super.initState();
    updateAppBarTitle();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var backgroundColor = Colors.grey[400];
    double height = 56;
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(width, height + 7),
                painter:
                    BottomNavCurvePainter(backgroundColor: backgroundColor!),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NavBarIcon(
                        text: "Home",
                        icon: CupertinoIcons.home,
                        selected: _selectedIndex == 0,
                        onPressed: () {
                          _onNavBarItemTapped(0);
                          updateAppBarTitle();
                        },
                      ),
                      NavBarIcon(
                        text: "Profile",
                        icon: CupertinoIcons.profile_circled,
                        selected: _selectedIndex == 1,
                        onPressed: () {
                          _onNavBarItemTapped(1);
                          updateAppBarTitle();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon(
      {super.key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed,
      this.selectedColor = const Color(0xffFF8527),
      this.defaultColor = Colors.black54});

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: const EdgeInsets.only(top: 10.0),
      icon: CircleAvatar(
        backgroundColor: selected ? Colors.white : Colors.transparent,
        child: Icon(icon,
            size: 22, color: selected ? AppColor.primaryDark2 : Colors.black),
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  BottomNavCurvePainter(
      {this.backgroundColor = Colors.black, this.insetRadius = 0});

  Color backgroundColor;
  double insetRadius;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 12);

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;
    double transitionToInsetCurveWidth = size.width * .05;
    path.quadraticBezierTo(size.width * 0.20, 0,
        insetCurveBeginnningX - transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(
        insetCurveBeginnningX, 0, insetCurveBeginnningX, insetRadius / 2);

    path.arcToPoint(Offset(insetCurveEndX, insetRadius / 2),
        radius: const Radius.circular(10.0), clockwise: false);

    path.quadraticBezierTo(
        insetCurveEndX, 0, insetCurveEndX + transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 12);
    path.lineTo(size.width, size.height + 56);
    path.lineTo(
        0,
        size.height +
            50); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
