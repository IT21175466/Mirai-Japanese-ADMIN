import 'package:flutter/material.dart';

class PastPapersPage extends StatefulWidget {
  final String lessionNo;
  final String lessonTitle;
  final String imageUrl;
  const PastPapersPage(
      {super.key,
      required this.lessionNo,
      required this.lessonTitle,
      required this.imageUrl});

  @override
  State<PastPapersPage> createState() => _PastPapersPageState();
}

class _PastPapersPageState extends State<PastPapersPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
