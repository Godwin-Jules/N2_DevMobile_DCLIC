import 'dart:math';
import 'dart:io';

void main() {
  print("+----------------------------------------------------+");
  print("| PROGRAMME DE CALCUL DE LA RACINE CARRE D'UN NOMBRE |");
  print("+----------------------------------------------------+\n");

  stdout.write("Veuillez saisir un nombre : ");
  String? user_input = stdin.readLineSync()!;

  try {
    double number = double.parse(user_input);
    double square = sqrt(number);

    print("La racine carré de $number est ${square.toStringAsFixed(2)}.");
  } catch (e) {
    print("Erreur : Veuillez saisir un nombre correct !\n$e");
  }
}
