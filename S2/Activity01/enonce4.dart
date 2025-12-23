void main() {
  print("+---------------------------------+");
  print("| STRUCTURE DE CONTRÔLE COMPLEXES |");
  print("+---------------------------------+\n");

  List<int> nombres = [2, 6, 9, 15, 18, 47, 33, 24, 12, 56, 69, 68];

  for (var item in nombres) {
    String result = item % 3 == 0
        ? "$item : Multiple de 3"
        : "$item : Non multiple de 3";
    print(result);
  }

  print("");
  for (var item in nombres) {
    switch (item) {
      case < 15:
        print("($item) : Faible");
        break;
      case > 25:
        print("($item) : Élevé");
        break;
      default:
        print("($item) : Moyen");
        break;
    }
  }

  List<int> nombresMultiple = nombres.where((item) => item % 3 == 0).toList();
  List<int> nombresMultipleGrand = nombresMultiple.where((item) => item > 15).toList();

  print("\nMultiple de 3 et supérieur à 15 : $nombresMultipleGrand");
  int somme = nombresMultipleGrand.reduce((value, item) => value + item);
  print("La somme des nombres multiples de 3 et supérieurs à 15 est : $somme");
}
