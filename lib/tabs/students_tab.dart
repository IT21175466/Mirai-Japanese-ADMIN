import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:mirai_japanese_admin/dashboard/student_details_screen.dart';
import 'package:mirai_japanese_admin/models/student.dart';
import 'package:mirai_japanese_admin/widgets/search_textfild.dart';

class StudentsTab extends StatefulWidget {
  const StudentsTab({super.key});

  @override
  State<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Students',
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
              child: FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection('Students').get(),
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
                      List<Student> students = snapshot.data!.docs
                          .map((doc) => Student.fromJson(doc))
                          .toList();

                      return ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentDetails(
                                    userID: student.userID,
                                    firstName: student.firstName,
                                    lastName: student.lastName,
                                    email: student.email,
                                    phoneNum: student.phoneNum,
                                    dateOfBirth: student.dateOfBirth,
                                    date: student.date,
                                    lessonMarks: student.lessonMarks,
                                    pastPaperMarks: student.pastPaperMarks,
                                    completedLessons: student.completedLessons,
                                    completedPastPapers:
                                        student.completedPastPapers,
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
                                          '${student.firstName} ${student.lastName}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: AppColors.textBlackColor,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${student.phoneNum}',
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
                                        '${student.dateOfBirth}',
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
                                        '${student.completedLessons}',
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
                                        '${student.completedPastPapers}',
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
