import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:mirai_japanese_admin/dashboard/student_details_screen.dart';
import 'package:mirai_japanese_admin/widgets/search_textfild.dart';

class StudentsTab extends StatefulWidget {
  const StudentsTab({super.key});

  @override
  State<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Spacer(),
            Text(
              'Students',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await FirebaseAuth.instance.signOut().then((value) => {
                      isLoading = false,
                    });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isLoading
                    ? Text(
                        'Please Wait!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'LogOut',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.borderColor,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                Container(
                  height: 60,
                  width: screenWidth / 3,
                  child: SearchTextField(
                      controller: searchController, labelText: 'Search'),
                ),
              ],
            ),
            Container(
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth / 10 * 3,
                    child: Text(
                      'Name and ID',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: AppColors.accentColor,
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: screenWidth / 10 * 1,
                    child: Center(
                      child: Text(
                        'Birth Day',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: screenWidth / 10 * 1.5,
                    child: Center(
                      child: Text(
                        'Completed Lessons',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: screenWidth / 10 * 1.5,
                    child: Center(
                      child: Text(
                        'Completed PastPapers',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.accentColor,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight - 200,
              width: screenWidth,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Students')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot student = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentDetails(
                                    userID: student['UserID'],
                                    firstName: student['FirstName'],
                                    lastName: student['LastName'],
                                    email: student['Email'],
                                    phoneNum: student['PhoneNumber'],
                                    dateOfBirth: student['DateOfBirth'],
                                    date: student['Registed_Date'],
                                    completedLessons:
                                        student['Completed_Lessons'],
                                    completedPastPapers:
                                        student['Completed_PastPapers'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: screenWidth,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.lowAccentColor,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Spacer(),
                                      Container(
                                        width: screenWidth / 10 * 3,
                                        child: Text(
                                          '${student['FirstName']} ${student['LastName']}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: AppColors.textBlackColor,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${student['PhoneNumber']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: AppColors.textGrayColor,
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    width: screenWidth / 10 * 1,
                                    child: Center(
                                      child: Text(
                                        '${student['DateOfBirth']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: AppColors.textBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: screenWidth / 10 * 1.5,
                                    child: Center(
                                      child: Text(
                                        '${student['Completed_Lessons']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.textBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: screenWidth / 10 * 1.5,
                                    child: Center(
                                      child: Text(
                                        '${student['Completed_PastPapers']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.textBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
