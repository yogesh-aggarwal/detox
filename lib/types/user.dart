class User {
  String id;
  String name;
  String email;
  String dp;
  String? phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.dp,
    required this.phoneNumber,
  });

  String get initials {
    String initials = '';
    List<String> names = name.split(' ');
    int numNames = names.length;
    if (numNames > 1) {
      initials += '${names[0][0]}${names[numNames - 1][0]}';
    } else {
      initials += names[0][0];
    }
    return initials;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dp': dp,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      dp: map['dp'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
