class Usage {
  String id;
  String name;
  String packageName;

  int start;
  int end;
  String? reason;

  int dateCreated;

  Usage({
    required this.id,
    required this.name,
    required this.packageName,
    required this.start,
    required this.end,
    required this.reason,
    required this.dateCreated,
  });

  factory Usage.fromMap(Map<String, dynamic> map) {
    return Usage(
      id: map['id'],
      name: map['name'],
      packageName: map['packageName'],
      start: map['start'],
      end: map['end'],
      reason: map['reason'],
      dateCreated: map['dateCreated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'packageName': packageName,
      'start': start,
      'end': end,
      'reason': reason,
      'dateCreated': dateCreated,
    };
  }

  @override
  String toString() {
    return 'Usage(id: $id, name: $name, packageName: $packageName, start: $start, end: $end, reason: $reason, dateCreated: $dateCreated)';
  }

  int get duration => end - start;
}
