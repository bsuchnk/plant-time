class SessionInfo {
  final int date;
  final int duration;
  final String category;
  final int plant;

  SessionInfo({this.date, this.duration, this.category, this.plant});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'duration': duration,
      'category': category,
      'plant': plant,
    };
  }

  factory SessionInfo.fromMap(Map<String, dynamic> json) => new SessionInfo(
        date: json['date'],
        duration: json['duration'],
        category: json['category'],
        plant: json['plant'],
      );
}
