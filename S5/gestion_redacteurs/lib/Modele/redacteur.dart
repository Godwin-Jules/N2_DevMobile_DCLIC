class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;

  Redacteur(this.id, this.nom, this.prenom, this.email);

  Redacteur.withoutId(this.nom, this.prenom, this.email);

  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }

  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(map['id'], map['nom'], map['prenom'], map['email']);
  }
}
