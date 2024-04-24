import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:mirai_japanese_admin/models/question.dart';
import 'package:mirai_japanese_admin/widgets/custom_button.dart';
import 'package:mirai_japanese_admin/widgets/phone_textfeild.dart';
import 'package:mirai_japanese_admin/widgets/textfiled.dart';

class LessonsPage extends StatefulWidget {
  final String lessionNo;
  final String lessonTitle;
  final String imageUrl;
  const LessonsPage(
      {super.key,
      required this.lessionNo,
      required this.lessonTitle,
      required this.imageUrl});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  TextEditingController questionController = TextEditingController();

  final db = FirebaseFirestore.instance;

  bool loading = false;
  bool imageUploaded = false;

  bool selectedQuestionImageUploaded = false;
  bool selectedAnswer1ImageUploaded = false;
  bool selectedAnswer2ImageUploaded = false;
  bool selectedAnswer3ImageUploaded = false;

  String selectedQuestionImage = '';
  String selectedAnswer1Image = '';
  String selectedAnswer2Image = '';
  String selectedAnswer3Image = '';

  Uint8List selectedQuestionImageInBytes = Uint8List(8);
  Uint8List selectedAnswer1ImageInBytes = Uint8List(8);
  Uint8List selectedAnswer2ImageInBytes = Uint8List(8);
  Uint8List selectedAnswer3ImageInBytes = Uint8List(8);

  //Add Lesson
  addQuestionToFirebase(
      Question question, BuildContext context, String questionNo) async {
    setState(() {
      loading = true;
    });
    try {
      db
          .collection("Lessons")
          .doc(questionNo)
          .set(question.toJson())
          .then((value) async {
        setState(() {
          loading = false;
        });
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void addQuestionAlertDialog() {
      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Add New Question",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            content: Container(
              height: screenHeight - 300,
              width: screenWidth / 2,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Required*",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    PhoneTextField(
                      controller: questionController,
                      labelText: 'Question Number',
                      hintText: '1 (Enter only numbers)',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: questionController,
                            labelText: 'Question',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        selectedQuestionImageUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        selectedQuestionImageInBytes),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  try {
                                    FilePickerResult? fileResult =
                                        await FilePicker.platform.pickFiles(
                                      allowedExtensions: ['png', 'jpg'],
                                      type: FileType.custom,
                                    );

                                    if (fileResult != null) {
                                      setState(() {
                                        selectedQuestionImage =
                                            fileResult.files.first.name;
                                        selectedQuestionImageInBytes =
                                            fileResult.files.first.bytes!;
                                        selectedQuestionImageUploaded = true;
                                      });
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add_photo_alternate),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Icon(Icons.voice_chat),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: questionController,
                            labelText: 'Answer 1',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        selectedAnswer1ImageUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        selectedAnswer1ImageInBytes),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  try {
                                    FilePickerResult? fileResult =
                                        await FilePicker.platform.pickFiles(
                                      allowedExtensions: ['png', 'jpg'],
                                      type: FileType.custom,
                                    );

                                    if (fileResult != null) {
                                      setState(() {
                                        selectedAnswer1Image =
                                            fileResult.files.first.name;
                                        selectedAnswer1ImageInBytes =
                                            fileResult.files.first.bytes!;
                                        selectedAnswer1ImageUploaded = true;
                                      });
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add_photo_alternate),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Icon(Icons.voice_chat),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: questionController,
                            labelText: 'Answer 2',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        selectedAnswer2ImageUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        selectedAnswer2ImageInBytes),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  try {
                                    FilePickerResult? fileResult =
                                        await FilePicker.platform.pickFiles(
                                      allowedExtensions: ['png', 'jpg'],
                                      type: FileType.custom,
                                    );

                                    if (fileResult != null) {
                                      setState(() {
                                        selectedAnswer2Image =
                                            fileResult.files.first.name;
                                        selectedAnswer2ImageInBytes =
                                            fileResult.files.first.bytes!;
                                        selectedAnswer2ImageUploaded = true;
                                      });
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add_photo_alternate),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Icon(Icons.voice_chat),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: questionController,
                            labelText: 'Answer 3',
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        selectedAnswer3ImageUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        selectedAnswer3ImageInBytes),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  try {
                                    FilePickerResult? fileResult =
                                        await FilePicker.platform.pickFiles(
                                      allowedExtensions: ['png', 'jpg'],
                                      type: FileType.custom,
                                    );

                                    if (fileResult != null) {
                                      setState(() {
                                        selectedAnswer3Image =
                                            fileResult.files.first.name;
                                        selectedAnswer3ImageInBytes =
                                            fileResult.files.first.bytes!;
                                        selectedAnswer3ImageUploaded = true;
                                      });
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add_photo_alternate),
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Icon(Icons.voice_chat),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedQuestionImageInBytes = Uint8List(0);
                    selectedAnswer1ImageInBytes = Uint8List(0);
                    selectedAnswer2ImageInBytes = Uint8List(0);
                    selectedAnswer3ImageInBytes = Uint8List(0);

                    selectedQuestionImage = '';
                    selectedAnswer1Image = '';
                    selectedAnswer2Image = '';
                    selectedAnswer3Image = '';

                    selectedQuestionImageUploaded = false;
                    selectedAnswer1ImageUploaded = false;
                    selectedAnswer2ImageUploaded = false;
                    selectedAnswer3ImageUploaded = false;
                  });
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.accentColor,
                  ),
                ),
              ),
            ],
          );
        }),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.lessionNo,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.lessonTitle,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Container(
              height: AppBar().preferredSize.height - 10,
              width: AppBar().preferredSize.height - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                ),
              ),
            )
          ],
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
            GestureDetector(
              onTap: () {
                addQuestionAlertDialog();
              },
              child: CustomButton(
                text: 'Add a Question',
                height: 50,
                width: screenWidth / 6,
              ),
            ),
            SizedBox(
              height: 15,
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
                  Container(
                    width: screenWidth / 10 * 1,
                    child: Text(
                      'Question No',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: AppColors.accentColor,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: screenWidth / 10 * 4,
                    child: Center(
                      child: Text(
                        'Question',
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
                  Container(
                    width: screenWidth / 10 * 2,
                    child: Center(
                      child: Text(
                        'Correct Answer',
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
                  Container(
                    width: screenWidth / 10 * 2,
                    child: Center(
                      child: Text(
                        'Actions',
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
          ],
        ),
      ),
    );
  }
}
