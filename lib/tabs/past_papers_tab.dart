import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mirai_japanese_admin/constaints/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;
import 'package:mirai_japanese_admin/dashboard/pastpapers_page.dart';
import 'package:mirai_japanese_admin/models/lesson.dart';
import 'package:mirai_japanese_admin/widgets/custom_button.dart';
import 'package:mirai_japanese_admin/widgets/phone_textfeild.dart';
import 'package:mirai_japanese_admin/widgets/textfiled.dart';

class PastPapersTab extends StatefulWidget {
  const PastPapersTab({super.key});

  @override
  State<PastPapersTab> createState() => _PastPapersTabState();
}

class _PastPapersTabState extends State<PastPapersTab> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController questionNoController = TextEditingController();

  //Lesson
  final TextEditingController lessonNoController = TextEditingController();
  final TextEditingController lessonTitleController = TextEditingController();

  final db = FirebaseFirestore.instance;

  bool loading = false;
  bool imageUploaded = false;

  String selectedFile = '';
  Uint8List selectedImageInBytes = Uint8List(8);

  Future uploadToFirebase(String lessonID) async {
    String imageUrl = '';
    try {
      setState(() {
        loading = true;
      });
      firabase_storage.UploadTask uploadTask;

      firabase_storage.Reference ref = firabase_storage.FirebaseStorage.instance
          .ref()
          .child('pastpaper_images/${lessonID}');

      final metadata =
          firabase_storage.SettableMetadata(contentType: 'image/png');

      uploadTask = ref.putData(selectedImageInBytes, metadata);

      await uploadTask.whenComplete(() => null);
      imageUrl = await ref.getDownloadURL();

      print('Download Link: ${imageUrl}');

      final les = Lesson(
        lessionNo: lessonNoController.text.trim(),
        lessonTitle: lessonTitleController.text,
        imageUrl: imageUrl,
      );

      addPastPaperToFirebase(les, context, lessonNoController.text.trim());
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }
  }

  addPastPaperToFirebase(
      Lesson lesson, BuildContext context, String lessonNo) async {
    setState(() {
      loading = true;
    });
    try {
      db
          .collection("PastPapers")
          .doc(lessonNo)
          .set(lesson.toJson())
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
    }
  }

  addPastPaperToFirebaseWithoutImage(
      Lesson lesson, BuildContext context, String lessonNo) async {
    setState(() {
      loading = true;
    });
    try {
      db
          .collection("PastPapers")
          .doc(lessonNo)
          .set(lesson.toJson())
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

  editPastPaper(Lesson lesson, BuildContext context, String lessonNo) async {
    setState(() {
      loading = true;
    });
    try {
      db
          .collection("PastPapers")
          .doc(lessonNo)
          .update(lesson.toJson())
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
    }
  }

  deletePastPaperFirebase(
      BuildContext context, String lessonNo, String imageUrl) async {
    setState(() {
      loading = true;
    });
    try {
      db.collection("PastPapers").doc(lessonNo).delete().then((value) async {
        setState(() {
          loading = false;
        });
      });

      if (imageUrl ==
          'https://firebasestorage.googleapis.com/v0/b/mirai-japanese-n5.appspot.com/o/past_paper_images%2F5521505_2833674.jpg?alt=media&token=80f45559-7f25-45d3-8701-77fa97b0aea4') {
        print('Default Image Cannot Delete');
      } else {
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void addPastPaperAlertDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Add New Past Paper",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            content: Container(
              width: screenWidth / 4,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhoneTextField(
                      controller: lessonNoController,
                      labelText: 'Paper Number',
                      hintText: '123XX (Enter only numbers)',
                    ),
                    CustomTextField(
                      controller: lessonTitleController,
                      labelText: 'Paper Title',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Paper Image (Optional)",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    imageUploaded
                        ? Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: MemoryImage(selectedImageInBytes),
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
                                    selectedFile = fileResult.files.first.name;
                                    selectedImageInBytes =
                                        fileResult.files.first.bytes!;
                                    imageUploaded = true;
                                  });
                                }
                                print(selectedFile);
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add_photo_alternate,
                                  size: 35,
                                ),
                              ),
                            ),
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
                    lessonNoController.clear();
                    lessonTitleController.clear();
                    imageUploaded = false;
                    selectedFile = '';
                  });
                  Navigator.of(context).pop();
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
                onPressed: () async {
                  if (lessonNoController.text.isEmpty ||
                      lessonTitleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please Enter Details"),
                      ),
                    );
                  } else {
                    try {
                      setState(() {
                        loading = true;
                      });

                      if (imageUploaded == true) {
                        await uploadToFirebase(
                            lessonNoController.text.toString());
                      } else {
                        final les = Lesson(
                          lessionNo: lessonNoController.text.trim(),
                          lessonTitle: lessonTitleController.text,
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/mirai-japanese-n5.appspot.com/o/past_paper_images%2F5521505_2833674.jpg?alt=media&token=80f45559-7f25-45d3-8701-77fa97b0aea4',
                        );

                        await addPastPaperToFirebaseWithoutImage(
                            les, context, lessonNoController.text.trim());
                      }
                    } catch (e) {
                      print(e);
                    } finally {
                      setState(() {
                        lessonNoController.clear();
                        lessonTitleController.clear();
                        imageUploaded = false;
                      });
                    }
                  }
                },
                child: loading
                    ? CircularProgressIndicator()
                    : Text(
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

    void editPastPaperAlertDialog(BuildContext context, String imageUrl) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            "Edit Past Paper",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: Container(
            width: screenWidth / 4,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhoneTextField(
                    controller: lessonNoController,
                    labelText: 'Paper Number',
                    hintText: '123XX (Enter only numbers)',
                  ),
                  CustomTextField(
                    controller: lessonTitleController,
                    labelText: 'Paper Title',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Paper Image (Optional)",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: NetworkImage(imageUrl))),
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
                  lessonNoController.clear();
                  lessonTitleController.clear();
                });
                Navigator.of(context).pop();
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
              onPressed: () async {
                if (lessonNoController.text.isEmpty ||
                    lessonTitleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please Enter Details"),
                    ),
                  );
                } else {
                  try {
                    final les = Lesson(
                      lessionNo: lessonNoController.text.trim(),
                      lessonTitle: lessonTitleController.text,
                      imageUrl: imageUrl,
                    );

                    editPastPaper(
                      les,
                      context,
                      lessonNoController.text.toString(),
                    );
                  } catch (e) {
                    print(e);
                  } finally {
                    setState(() {
                      lessonNoController.clear();
                      lessonTitleController.clear();
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.accentColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    void deletePastPaper(
        BuildContext context, String title, String no, String image) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            "Delete Past Paper",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: Container(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paper No: ${no}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Paper Title: ${title}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
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
                deletePastPaperFirebase(context, no, image);
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
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                addPastPaperAlertDialog(context);
              },
              child: CustomButton(
                text: 'Add a Past Paper',
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
                  SizedBox(
                    width: screenWidth / 10 * 1,
                    child: Text(
                      'Paper No',
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
                    width: screenWidth / 10 * 2,
                    child: Center(
                      child: Text(
                        'Paper Title',
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
                    width: screenWidth / 10 * 2,
                    child: Center(
                      child: Text(
                        'Image',
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
            Container(
              height: screenHeight - 200,
              width: screenWidth,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('PastPapers')
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PastPapersPage(
                                    lessionNo: docs[index]['LessonNo'],
                                    lessonTitle: docs[index]['LessonTitle'],
                                    imageUrl:
                                        docs[index]['Image_Url'].toString(),
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
                                  Spacer(),
                                  Container(
                                    width: screenWidth / 10 * 1,
                                    child: Text(
                                      docs[index]['LessonNo'],
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
                                    width: screenWidth / 10 * 2,
                                    child: Center(
                                      child: Text(
                                        docs[index]['LessonTitle'],
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
                                    width: screenWidth / 10 * 2,
                                    child: Center(
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          //color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Image.network(docs[index]
                                                ['Image_Url']
                                            .toString()),
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
                                              setState(() {
                                                lessonNoController.text =
                                                    docs[index]['LessonNo'];

                                                lessonTitleController.text =
                                                    docs[index]['LessonTitle'];
                                              });
                                              editPastPaperAlertDialog(
                                                context,
                                                docs[index]['Image_Url'],
                                              );
                                            },
                                            child: Icon(Icons.edit),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              deletePastPaper(
                                                context,
                                                docs[index]['LessonTitle'],
                                                docs[index]['LessonNo'],
                                                docs[index]['Image_Url'],
                                              );
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
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
