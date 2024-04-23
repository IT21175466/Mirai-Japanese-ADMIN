import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirai_japanese_admin/models/mark.dart';

class Student {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNum;
  final String dateOfBirth;
  final String date;
  final List<Mark> lessonMarks;
  final List<Mark> pastPaperMarks;
  final int completedLessons;
  final int completedPastPapers;

  Student({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNum,
    required this.date,
    required this.dateOfBirth,
    required this.lessonMarks,
    required this.pastPaperMarks,
    required this.completedLessons,
    required this.completedPastPapers,
  });

  factory Student.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    List<Mark> parsedMarksLessons = [];
    if (json['Lessions_Marks'] != null) {
      var markList = json['Lessions_Marks'] as List;
      parsedMarksLessons = markList.map((mark) => Mark.fromJson(mark)).toList();
    }

    List<Mark> parsedMarksPastPapers = [];
    if (json['PastPapers_Marks'] != null) {
      var markList = json['PastPapers_Marks'] as List;
      parsedMarksPastPapers =
          markList.map((mark) => Mark.fromJson(mark)).toList();
    }

    return Student(
      userID: json['UserID'].toString(),
      firstName: json['FirstName'].toString(),
      lastName: json['LastName'].toString(),
      email: json['Email'].toString(),
      phoneNum: json['PhoneNumber'].toString(),
      dateOfBirth: json['DateOfBirth'].toString(),
      date: json['Registed_Date'],
      lessonMarks: parsedMarksLessons,
      pastPaperMarks: parsedMarksPastPapers,
      completedLessons: json['Completed_Lessons'],
      completedPastPapers: json['Completed_PastPapers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'PhoneNumber': phoneNum,
      'DateOfBirth': dateOfBirth,
      'Registed_Date': date,
      'Lessions_Marks': lessonMarks.map((mark) => mark.toJson()).toList(),
      'PastPapers_Marks': pastPaperMarks.map((mark) => mark.toJson()).toList(),
      'Completed_Lessons': completedLessons,
      'Completed_PastPapers': completedPastPapers,
    };
  }
}
