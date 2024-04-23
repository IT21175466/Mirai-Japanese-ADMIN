class Mark {
  final String userID;
  final String paperID;
  final double score;
  final String date;

  Mark({
    required this.userID,
    required this.paperID,
    required this.score,
    required this.date,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      userID: json['UserID'].toString(),
      paperID: json['LessonID'].toString(),
      score: json['Score'],
      date: json['Date'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'LessonID': paperID,
      'Score': score,
      'Date': date,
    };
  }
}
