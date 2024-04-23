import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String questionNumber;
  final String question;
  final String answer1;
  final String answer2;
  final String answer3;
  final String correctAnswer;
  //Images
  final String questionImage;
  final String answer1Image;
  final String answer2Image;
  final String answer3Image;
  //Voice
  final String questionVoice;
  final String answer1Voice;
  final String answer2Voice;
  final String answer3Voice;

  Question({
    required this.questionNumber,
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.correctAnswer,

    //Imags
    required this.questionImage,
    required this.answer1Image,
    required this.answer2Image,
    required this.answer3Image,

    //Voice
    required this.questionVoice,
    required this.answer1Voice,
    required this.answer2Voice,
    required this.answer3Voice,
  });

  factory Question.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Question(
      questionNumber: json['QuestionNo'].toString(),
      question: json['Question'].toString(),
      answer1: json['Answer1'].toString(),
      answer2: json['Answer2'].toString(),
      answer3: json['Answer3'].toString(),
      correctAnswer: json['CorrectAnswer'].toString(),
      questionImage: json['Question_Image'].toString(),
      answer1Image: json['Answer1_Image'].toString(),
      answer2Image: json['Answer2_Image'].toString(),
      answer3Image: json['Answer3_Image'].toString(),
      questionVoice: json['Question_Voice'].toString(),
      answer1Voice: json['Answer1_Voice'].toString(),
      answer2Voice: json['Answer2_Voice'].toString(),
      answer3Voice: json['Answer3_Voice'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'QuestionNo': questionNumber,
      'Question': question,
      'Answer1': answer1,
      'Answer2': answer2,
      'Answer3': answer3,
      'CorrectAnswer': correctAnswer,
      'Question_Image': questionImage,
      'Answer1_Image': answer1Image,
      'Answer2_Image': answer2Image,
      'Answer3_Image': answer3Image,
      'Question_Voice': questionVoice,
      'Answer1_Voice': answer1Voice,
      'Answer2_Voice': answer2Voice,
      'Answer3_Voice': answer3Voice,
    };
  }
}
