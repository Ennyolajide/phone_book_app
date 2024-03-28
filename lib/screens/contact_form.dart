class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String avatar;

  Contact(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.avatar});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone'],
      avatar: json['avatar'],
    );
  }
}
