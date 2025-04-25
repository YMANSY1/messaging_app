class User {
  User({
    BigInt? id,
    String? username,
    String? email,
    String? passwordHash,
    DateTime? createdAt,
    bool? isOnline,
  }) {
    _id = id;
    _username = username;
    _email = email;
    _passwordHash = passwordHash;
    _createdAt = createdAt;
    _isOnline = isOnline;
  }

  User.fromJson(dynamic json) {
    _id = json['id'] != null
        ? BigInt.tryParse(json['id'].toString())
        : null; // Safely parse as BigInt
    _username = json['username'];
    _email = json['email'];
    _passwordHash = json['passwordHash'];
    _createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    _isOnline = json['isOnline'];
  }

  BigInt? _id;
  String? _username;
  String? _email;
  String? _passwordHash;
  DateTime? _createdAt;
  bool? _isOnline;

  User copyWith({
    BigInt? id,
    String? username,
    String? email,
    String? passwordHash,
    DateTime? createdAt,
    bool? isOnline,
  }) =>
      User(
        id: id ?? _id,
        username: username ?? _username,
        email: email ?? _email,
        passwordHash: passwordHash ?? _passwordHash,
        createdAt: createdAt ?? _createdAt,
        isOnline: isOnline ?? _isOnline,
      );

  BigInt? get id => _id;
  String? get username => _username;
  String? get email => _email;
  String? get passwordHash => _passwordHash;
  DateTime? get createdAt => _createdAt;
  bool? get isOnline => _isOnline;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['email'] = _email;
    map['passwordHash'] = _passwordHash;
    map['createdAt'] = _createdAt?.toIso8601String();
    map['isOnline'] = _isOnline;
    return map;
  }
}
