class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;
  int age;

  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email, 'age': age};
  }

  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
      age: map['age'],
    );
  }
}
