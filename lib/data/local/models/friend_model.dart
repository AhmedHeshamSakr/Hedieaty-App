class FriendModel {
  final int id;
  final String name;
  final String phone;

  FriendModel({required this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}
