import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';

class PastPapersTab extends StatefulWidget {
  const PastPapersTab({super.key});

  @override
  State<PastPapersTab> createState() => _PastPapersTabState();
}

class _PastPapersTabState extends State<PastPapersTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Past Papers',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.borderColor,
      ),
    );
  }
}
