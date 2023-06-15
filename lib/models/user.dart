class User {
  final String headOffice;
  final String name;
  int authority;

  User({
    required this.headOffice,
    required this.name,
    required this.authority,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      headOffice: json['headOffice'],
      name: json['name'],
      authority: json['authority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headOffice': headOffice,
      'name': name,
      'authority': authority,
    };
  }
}