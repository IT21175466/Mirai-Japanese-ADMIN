import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:mirai_japanese_admin/tabs/lessons_tab.dart';
import 'package:mirai_japanese_admin/tabs/past_papers_tab.dart';
import 'package:mirai_japanese_admin/tabs/students_tab.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpanded = true;
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    StudentsTab(),
    LessonsTab(),
    PastPapersTab(),
    //SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.lowAccentColor,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: AppBar().preferredSize.height),
              child: NavigationRail(
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  extended: isExpanded,
                  backgroundColor: AppColors.lowAccentColor,
                  unselectedIconTheme: IconThemeData(
                    color: AppColors.accentColor,
                    opacity: 1,
                  ),
                  selectedLabelTextStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  unselectedLabelTextStyle: TextStyle(
                    color: AppColors.accentColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.people),
                      label: Text("Students"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.play_lesson),
                      label: Text("Lessons"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.document_scanner),
                      label: Text("Past Papers"),
                    ),
                    // NavigationRailDestination(
                    //   icon: Icon(Icons.settings),
                    //   label: Text("Settings"),
                    // ),
                  ],
                  selectedIndex: _selectedIndex),
            ),
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
