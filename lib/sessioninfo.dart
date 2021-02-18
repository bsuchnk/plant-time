class SessionInfo {
  final int id;
  final int date;
  final int duration;
  final String category;

  SessionInfo({this.id, this.date, this.duration, this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'duration': duration,
      'category': category,
    };
  }

  factory SessionInfo.fromMap(Map<String, dynamic> json) => new SessionInfo(
        id: json['id'],
        date: json['date'],
        duration: json['duration'],
        category: json['category'],
      );
}
