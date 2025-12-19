class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String cpf;
  final DateTime birthDate;
  final String email;
  final String passwordHash; // Senha já hashada

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.cpf,
    required this.birthDate,
    required this.email,
    required this.passwordHash,
  });

  // Nome completo
  String get fullName => '$firstName $lastName';

  // Converter para Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'cpf': cpf,
      'birthDate': birthDate.toIso8601String(),
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  // Criar User a partir de Map (do SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      cpf: map['cpf'] as String,
      birthDate: DateTime.parse(map['birthDate'] as String),
      email: map['email'] as String,
      passwordHash: map['passwordHash'] as String,
    );
  }

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'cpf': cpf,
      'birthDate': birthDate.toIso8601String(),
      'email': email,
      // Não incluir passwordHash no JSON por segurança
    };
  }

  // Criar User a partir de JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      cpf: json['cpf'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
    );
  }

  // Cópia do objeto com campos opcionais
  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? cpf,
    DateTime? birthDate,
    String? email,
    String? passwordHash,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      cpf: cpf ?? this.cpf,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $fullName, email: $email, cpf: $cpf)';
  }
}


