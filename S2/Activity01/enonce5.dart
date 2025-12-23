import 'dart:io';

void main() {
  print("+-----------------------------------------------------+");
  print("| PROGRAMME DE CALCUL DE L'INDICE DE MASSE CORPORELLE |");
  print("+-----------------------------------------------------+\n\n");

  print("Bienvenue dans l'application de calcul d'IMC");
  stdout.write("Veuillez saisir votre poids (en Kg) : ");
  dynamic poids = stdin.readLineSync()!;

  stdout.write("Veuillez saisir votre taille (en mètes) : ");
  dynamic taille = stdin.readLineSync()!;

  try {
    poids = double.parse(poids);
    taille = double.parse(taille);

    double user_imc = poids / (taille * taille);
    if (user_imc < 18.5) {
      print(
        "IMC = ${user_imc.toStringAsFixed(2)}. Vous êtes en \"Sous-poids\".",
      );
    } else if (user_imc >= 18.5 && user_imc < 25) {
      print(
        "IMC = ${user_imc.toStringAsFixed(2)}. Vous avez un \"Poids normal\".",
      );
    } else if (user_imc >= 25 && user_imc < 30) {
      print("IMC = ${user_imc.toStringAsFixed(2)}. Vous êtes au \"Surpoids\".");
    } else if (user_imc >= 3) {
      print(
        "IMC = ${user_imc.toStringAsFixed(2)}. Vous souffrez d'\"Obésité\"",
      );
    }
  } catch (e) {
    print("Erreur : entrez les bonnes valeurs.\n$e");
  }
}
