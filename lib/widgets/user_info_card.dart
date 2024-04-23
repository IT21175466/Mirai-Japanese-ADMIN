import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';

class UserInfoCard extends StatelessWidget {
  final String phone;
  final String info;
  const UserInfoCard({
    super.key,
    required this.phone,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phone,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.textGrayColor,
                ),
              ),
              Text(
                info,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppColors.textBlackColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
