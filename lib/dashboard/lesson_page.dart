import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:mirai_japanese_admin/models/question.dart';
import 'package:mirai_japanese_admin/widgets/custom_button.dart';
import 'package:mirai_japanese_admin/widgets/phone_textfeild.dart';
import 'package:mirai_japanese_admin/widgets/textfiled.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController questionNoController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController correctAnswerController = TextEditingController();

  final db = FirebaseFirestore.instance;

  var uuid = Uuid();

  bool loading = false;
  bool imageUploaded = false;

  //Images
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

  //Audio
  bool selectedQuestionAudioUploaded = false;
  bool selectedAnswer1AudioUploaded = false;
  bool selectedAnswer2AudioUploaded = false;
  bool selectedAnswer3AudioUploaded = false;

  String selectedQuestionAudio = '';
  String selectedAnswer1Audio = '';
  String selectedAnswer2Audio = '';
  String selectedAnswer3Audio = '';

  Uint8List selectedQuestionAudioInBytes = Uint8List(8);
  Uint8List selectedAnswer1AudioInBytes = Uint8List(8);
  Uint8List selectedAnswer2AudioInBytes = Uint8List(8);
  Uint8List selectedAnswer3AudioInBytes = Uint8List(8);

  deleteLessonFirebaseFunction(BuildContext context, Question question) async {
    setState(() {
      loading = true;
    });
    try {
      db
          .collection("Lessons")
          .doc(widget.lessionNo)
          .collection("Questions")
          .doc(question.questionNumber)
          .delete()
          .then((value) async {
        setState(() {
          loading = false;
        });
      });

      if (question.questionImage.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.questionImage)
            .delete();
      }

      if (question.answer1Image.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.answer1Image)
            .delete();
      }

      if (question.answer2Image.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.answer2Image)
            .delete();
      }

      if (question.answer3Image.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.answer3Image)
            .delete();
      }

      //Voice
      if (question.questionVoice.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.questionVoice)
            .delete();
      }

      if (question.answer1Voice.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.answer1Voice)
            .delete();
      }
      if (question.answer2Voice.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.answer2Voice)
            .delete();
      }
      if (question.answer3Voice.isNotEmpty) {
        await FirebaseStorage.instance
            .refFromURL(question.answer3Voice)
            .delete();
      }
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
    }
  }

  Future uploadQuestionToFirebase(String lessonID, String questionNo) async {
    setState(() {
      loading = true;
    });
    String audioQuestionUrl = '';
    String audioAnswer1Url = '';
    String audioAnswer2Url = '';
    String audioAnswer3Url = '';

    String imageQuestionUrl = '';
    String imageAnswer1Url = '';
    String imageAnswer2Url = '';
    String imageAnswer3Url = '';

    try {
      if (selectedQuestionAudioUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_audios/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'audio/mpeg');

          uploadTask = ref.putData(selectedQuestionAudioInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          audioQuestionUrl = await ref.getDownloadURL();

          print('Download Link: ${audioQuestionUrl}');
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      if (selectedAnswer2AudioUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_audios/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'audio/mpeg');

          uploadTask = ref.putData(selectedAnswer1AudioInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          audioAnswer1Url = await ref.getDownloadURL();

          print('Download Link: ${audioAnswer1Url}');
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      if (selectedAnswer2AudioUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_audios/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'audio/mpeg');

          uploadTask = ref.putData(selectedAnswer2AudioInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          audioAnswer2Url = await ref.getDownloadURL();

          print('Download Link: ${audioAnswer2Url}');
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      if (selectedAnswer3AudioUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_audios/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'audio/mpeg');

          uploadTask = ref.putData(selectedAnswer3AudioInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          audioAnswer3Url = await ref.getDownloadURL();

          print('Download Link: ${audioAnswer3Url}');
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      //Images
      if (selectedQuestionImageUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_images/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'image/png');

          uploadTask = ref.putData(selectedQuestionImageInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          imageQuestionUrl = await ref.getDownloadURL();
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      if (selectedAnswer1ImageUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_images/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'image/png');

          uploadTask = ref.putData(selectedAnswer1ImageInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          imageAnswer1Url = await ref.getDownloadURL();
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      if (selectedAnswer2ImageUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_images/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'image/png');

          uploadTask = ref.putData(selectedAnswer2ImageInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          imageAnswer2Url = await ref.getDownloadURL();
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      if (selectedAnswer3ImageUploaded == true) {
        try {
          setState(() {
            loading = true;
          });
          firabase_storage.UploadTask uploadTask;

          firabase_storage.Reference ref =
              firabase_storage.FirebaseStorage.instance.ref().child(
                  'lesson_question_images/${uuid.v4()}${DateTime.now().microsecondsSinceEpoch.toString()}');

          final metadata =
              firabase_storage.SettableMetadata(contentType: 'image/png');

          uploadTask = ref.putData(selectedAnswer3ImageInBytes, metadata);

          await uploadTask.whenComplete(() => null);
          imageAnswer3Url = await ref.getDownloadURL();
        } catch (e) {
          print(e);
        } finally {
          setState(() {
            loading = false;
          });
        }
      }

      final questionUpload = Question(
        questionNumber: questionNoController.text,
        question: questionController.text,
        answer1: answer1Controller.text,
        answer2: answer2Controller.text,
        answer3: answer3Controller.text,
        correctAnswer: correctAnswerController.text,
        questionImage: imageQuestionUrl,
        answer1Image: imageAnswer1Url,
        answer2Image: imageAnswer2Url,
        answer3Image: imageAnswer3Url,
        questionVoice: audioQuestionUrl,
        answer1Voice: audioAnswer1Url,
        answer2Voice: audioAnswer2Url,
        answer3Voice: audioAnswer3Url,
      );

      await addQuestionToFirebase(
        questionUpload,
        context,
        widget.lessionNo,
      );
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });

      Navigator.pop(context);
    }
  }

  //Add Lesson
  addQuestionToFirebase(
      Question question, BuildContext context, String lessonNo) async {
    setState(() {
      loading = true;
    });
    try {
      db
          .collection("Lessons")
          .doc(lessonNo)
          .collection("Questions")
          .doc(questionNoController.text.toString())
          .set(question.toJson())
          .then((value) async {});
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

        questionNoController.clear();
        answer1Controller.clear();
        answer2Controller.clear();
        answer3Controller.clear();
        correctAnswerController.clear();

        //Audio
        selectedQuestionAudioUploaded = false;
        selectedAnswer1AudioUploaded = false;
        selectedAnswer2AudioUploaded = false;
        selectedAnswer3AudioUploaded = false;

        selectedQuestionAudio = '';
        selectedAnswer1Audio = '';
        selectedAnswer2Audio = '';
        selectedAnswer3Audio = '';
      });
    }
  }

  //Delete
  void deleteQuestionAlert(BuildContext context, Question question) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Delete Lesson",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        content: Container(
          height: 180,
          child: Text(
            'Do you want to delete question : ${question.questionNumber}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppColors.accentColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              deleteLessonFirebaseFunction(context, question);
              Navigator.of(context).pop();
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
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
                      controller: questionNoController,
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
                        selectedQuestionAudioUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.green,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult? audioResult =
                                      await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['mp3', 'm4a'],
                                    type: FileType.custom,
                                  );

                                  if (audioResult != null) {
                                    setState(() {
                                      selectedQuestionAudio =
                                          audioResult.files.first.name;
                                      selectedQuestionAudioInBytes =
                                          audioResult.files.first.bytes!;
                                      selectedQuestionAudioUploaded = true;
                                    });
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
                                    child: Icon(Icons.voice_chat),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: answer1Controller,
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
                        selectedAnswer1AudioUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.green,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult? audioResult =
                                      await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['mp3', 'm4a'],
                                    type: FileType.custom,
                                  );

                                  if (audioResult != null) {
                                    setState(() {
                                      selectedAnswer1Audio =
                                          audioResult.files.first.name;
                                      selectedAnswer1AudioInBytes =
                                          audioResult.files.first.bytes!;
                                      selectedAnswer1AudioUploaded = true;
                                    });
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
                                    child: Icon(Icons.voice_chat),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: answer2Controller,
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
                        selectedAnswer2AudioUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.green,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult? audioResult =
                                      await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['mp3', 'm4a'],
                                    type: FileType.custom,
                                  );

                                  if (audioResult != null) {
                                    setState(() {
                                      selectedAnswer2Audio =
                                          audioResult.files.first.name;
                                      selectedAnswer2AudioInBytes =
                                          audioResult.files.first.bytes!;
                                      selectedAnswer2AudioUploaded = true;
                                    });
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
                                    child: Icon(Icons.voice_chat),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: answer3Controller,
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
                        selectedAnswer3AudioUploaded
                            ? Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.green,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult? audioResult =
                                      await FilePicker.platform.pickFiles(
                                    allowedExtensions: ['mp3', 'm4a'],
                                    type: FileType.custom,
                                  );

                                  if (audioResult != null) {
                                    setState(() {
                                      selectedAnswer3Audio =
                                          audioResult.files.first.name;
                                      selectedAnswer3AudioInBytes =
                                          audioResult.files.first.bytes!;
                                      selectedAnswer3AudioUploaded = true;
                                    });
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
                                    child: Icon(Icons.voice_chat),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    CustomTextField(
                      controller: correctAnswerController,
                      labelText: 'Correct Answer',
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

                    questionNoController.clear();
                    answer1Controller.clear();
                    answer2Controller.clear();
                    answer3Controller.clear();
                    correctAnswerController.clear();

                    //Audio
                    selectedQuestionAudioUploaded = false;
                    selectedAnswer1AudioUploaded = false;
                    selectedAnswer2AudioUploaded = false;
                    selectedAnswer3AudioUploaded = false;

                    selectedQuestionAudio = '';
                    selectedAnswer1Audio = '';
                    selectedAnswer2Audio = '';
                    selectedAnswer3Audio = '';
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
              loading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if (questionNoController.text.isEmpty ||
                            questionController.text.isEmpty ||
                            answer1Controller.text.isEmpty ||
                            answer2Controller.text.isEmpty ||
                            answer3Controller.text.isEmpty ||
                            correctAnswerController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Enter Details"),
                            ),
                          );
                        } else {
                          try {
                            if (correctAnswerController.text ==
                                    answer1Controller.text ||
                                correctAnswerController.text ==
                                    answer2Controller.text ||
                                correctAnswerController.text ==
                                    answer3Controller.text) {
                              await uploadQuestionToFirebase(
                                widget.lessionNo,
                                questionNoController.text.toString(),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please Check Answer"),
                                ),
                              );
                            }
                          } catch (e) {
                            print(e);
                          } finally {
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

                              questionNoController.clear();
                              answer1Controller.clear();
                              answer2Controller.clear();
                              answer3Controller.clear();
                              correctAnswerController.clear();

                              //Audio
                              selectedQuestionAudioUploaded = false;
                              selectedAnswer1AudioUploaded = false;
                              selectedAnswer2AudioUploaded = false;
                              selectedAnswer3AudioUploaded = false;

                              selectedQuestionAudio = '';
                              selectedAnswer1Audio = '';
                              selectedAnswer2Audio = '';
                              selectedAnswer3Audio = '';
                            });
                          }
                        }
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
            ),
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
                  Spacer(),
                  Container(
                    width: screenWidth / 10 * 2,
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
                ],
              ),
            ),
            Container(
              height: screenHeight - 200,
              width: screenWidth,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Lessons')
                      .doc(widget.lessionNo)
                      .collection("Questions")
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
                      var docs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return Container(
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
                                Spacer(),
                                Container(
                                  width: screenWidth / 10 * 1,
                                  child: Text(
                                    docs[index]['QuestionNo'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: AppColors.textBlackColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: screenWidth / 10 * 4,
                                  child: Text(
                                    docs[index]['Question'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: AppColors.textBlackColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: screenWidth / 10 * 2,
                                  child: Text(
                                    docs[index]['CorrectAnswer'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: AppColors.textBlackColor,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: screenWidth / 10 * 2,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            // setState(() {
                                            //   lessonNoController.text =
                                            //       docs[index]['LessonNo'];

                                            //   lessonTitleController.text =
                                            //       docs[index]['LessonTitle'];
                                            // });
                                            // editLessonAlertDialog(
                                            //   context,
                                            //   docs[index]['Image_Url'],
                                            // );
                                          },
                                          child: Icon(Icons.edit),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            // deleteLesson(
                                            //   context,
                                            //   docs[index]['LessonTitle'],
                                            //   docs[index]['LessonNo'],
                                            //   docs[index]['Image_Url'],
                                            // );
                                            final deleteQuestion = Question(
                                              questionNumber: docs[index]
                                                  ['QuestionNo'],
                                              question: docs[index]['Question'],
                                              answer1: docs[index]['Answer1'],
                                              answer2: docs[index]['Answer2'],
                                              answer3: docs[index]['Answer3'],
                                              correctAnswer: docs[index]
                                                  ['CorrectAnswer'],
                                              questionImage: docs[index]
                                                  ['Question_Image'],
                                              answer1Image: docs[index]
                                                  ['Answer1_Image'],
                                              answer2Image: docs[index]
                                                  ['Answer2_Image'],
                                              answer3Image: docs[index]
                                                  ['Answer3_Image'],
                                              questionVoice: docs[index]
                                                  ['Question_Voice'],
                                              answer1Voice: docs[index]
                                                  ['Answer1_Voice'],
                                              answer2Voice: docs[index]
                                                  ['Answer2_Voice'],
                                              answer3Voice: docs[index]
                                                  ['Answer3_Voice'],
                                            );

                                            deleteQuestionAlert(
                                                context, deleteQuestion);
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'View Details',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: AppColors.accentColor,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
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
