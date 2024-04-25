import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:mirai_japanese_admin/widgets/user_info_card.dart';

class StudentDetails extends StatefulWidget {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNum;
  final String dateOfBirth;
  final String date;
  const StudentDetails({
    super.key,
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNum,
    required this.dateOfBirth,
    required this.date,
  });

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.firstName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.borderColor,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: screenWidth / 5 - 30,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 45,
                        child: Image.asset(
                          'assets/icons/quizScore.png',
                          color: AppColors.accentColor,
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'widget.completedLessions.length',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 36,
                              color: AppColors.accentColor,
                            ),
                          ),
                          Text(
                            'Lessons\nCompleted',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: AppColors.textGrayColor,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: screenWidth / 5 - 30,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 45,
                        child: Image.asset(
                          'assets/icons/pastPpers.png',
                          color: AppColors.accentColor,
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'widget.completedPastPapers',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 36,
                              color: AppColors.accentColor,
                            ),
                          ),
                          Text(
                            'Past Papers\nCompleted',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: AppColors.textGrayColor,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Student Details',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: AppColors.textBlackColor,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            UserInfoCard(
              phone: 'Full Name',
              info: '${widget.firstName} ${widget.lastName}',
            ),
            UserInfoCard(
              phone: 'Phone Number',
              info: '${widget.phoneNum}',
            ),
            widget.email.isEmpty
                ? SizedBox()
                : UserInfoCard(
                    phone: 'Email',
                    info: '${widget.email}',
                  ),
            UserInfoCard(
              phone: 'Birh Day',
              info: '${widget.dateOfBirth}',
            ),
            UserInfoCard(
              phone: 'Registed In',
              info: '${widget.date}',
            ),
          ],
        ),
      ),
    );
  }
}
