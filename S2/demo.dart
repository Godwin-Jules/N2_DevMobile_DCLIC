import 'dart:io';

void main() {
  print('DEMONSTRATION DU COURS');

  bool ensoleille = true;
  bool chaud = true;
  bool aparapluie = false;

  if (ensoleille && chaud) print('Il fait beau et chaud dehors !');
  if (ensoleille | aparapluie) {
    print("Soit il  faut beau, soit j'ai un parapluie (ou les deux).");
  }
  if (!aparapluie) print("Je n'ai pas de parapluie");

  Object fruit = "Pomme";
  print(fruit);
  dynamic destiny = 'Destinées';
  print(destiny);
  destiny = 468;
  print(destiny);

  dynamic enums = 45.835;
  print(enums is String);
  print(enums is int);
  print(enums is double);
  print(enums is Object);
  print(enums is bool);
  print("Ma variable est $enums");

  for (var i = 0; i < 10; i++) {
    print("Itérons ensemble : ${i + 1}");
  }

  var dance = "Let's dance together!";
  // var dance = 45;
  print(dance is String); // yield true
  print(dance is int); // yield true

  print("Enter your age: ");
  String? age = stdin.readLineSync()!;
  double dav = double.parse(age);
  int dar = int.parse(age);
  print(age + '45');
  print(dav + 45);
  print(dar + 45);

  List danger = [1, 2, 3, 4, 5];
  for (var item in danger) print(item);

  List nombres = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List nombresPairs = nombres.where((item) => item % 2 == 0).toList();
  print(nombresPairs);
  print(nombresPairs.reduce((value, element) => value + element));

  // Nombre d'années restant
  String nom;
  int age2;
  stdout.write("Veuillez entrer votre nom: ");
  nom = stdin.readLineSync()!;
  stdout.write("Veuillez entrer votre âge: ");
  String input = stdin.readLineSync()!;
  age2 = int.parse(input);

  print("$nom, il vous reste ${100 - age2} ans pour atteindre 100 ans");

  List noms = ['Salma', 'Karim', 'Wahida'];
  for (var name in noms) print('Bonjour $name !');
  noms.forEach((name) => print('$name, bonsoir !'));
  print(noms);
  print(noms.asMap());

  print(noms.reversed);

  Set dare = {"Python", "Java"};
  dare.length;

  File mon_fichier = File("path.txt");
  File mon_fichier2 = File("path2.txt");
  mon_fichier.writeAsString(
    "Everything that you think is good for us, just write it there!",
  );
  mon_fichier2.writeAsStringSync(
    "Just be free for filling this form with all your thoughts, nobody will hurt you!",
  );
  var content2 = mon_fichier2.readAsStringSync();
  print(content2);
  var content = mon_fichier.readAsString();
  print(content);
}
