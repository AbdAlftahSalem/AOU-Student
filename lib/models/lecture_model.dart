class LectureModel {
  List<Subjects>? subjects;

  LectureModel({this.subjects});

  LectureModel.fromJson(Map<String, dynamic> json) {
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subjects != null) {
      data['subjects'] = subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  String? time;
  String? subject;

  Subjects({this.time, this.subject});

  Subjects.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    subject = json['subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['subject'] = subject;
    return data;
  }
}
