import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String lessionNo;
  final String lessonTitle;
  final String imageUrl;

  Lesson({
    required this.lessionNo,
    required this.lessonTitle,
    required this.imageUrl,
  });

  factory Lesson.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Lesson(
      lessionNo: json['LessonNo'].toString(),
      lessonTitle: json['LessonTitle'].toString(),
      imageUrl: json['Image_Url'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LessonNo': lessionNo,
      'LessonTitle': lessonTitle,
      'Image_Url': imageUrl,
    };
  }
}
