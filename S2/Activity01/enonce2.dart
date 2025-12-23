void main() {
  print("+---------------------------+");
  print("| OPERATIONS SUR LES LISTES |");
  print("+---------------------------+\n");

  List<int> nombres = [2, 6, 9, 15, 18, 47, 32, 23, 12, 56, 89, 68];
  int somme = nombres.reduce((value, item) => value + item);
  int maximum = 0;
  for (int item in nombres) {
    if (item > maximum) maximum = item;
  }

  print("Liste : $nombres");
  print("Somme de tous les éléments : $somme");
  print("Le plus grand nombre de la liste est : $maximum");
}
