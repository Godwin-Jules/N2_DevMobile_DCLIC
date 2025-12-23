void main() {
  print("+-------------------------+");
  print("| MANIPULATION DES LISTES |");
  print("+-------------------------+\n");

  List<String> noms = [
    "Daniel",
    "Denzel",
    "Gabriel",
    "Emmanuel",
    "Felix",
    "Philippe",
  ];

  print("* La liste de présence en majuscules *");
  for (var item in noms) print(item.toUpperCase());

  print("\n* La liste de présence en minuscules *");
  int total = noms.length;
  int index = 0;
  while (index < total) {
    print(noms[index].toLowerCase());
    index++;
  }

  String search = "Alice";
  String result = noms.contains(search) ? "Présente" : "Absente";
  print("\n$result");

  var isEmpty = noms.isEmpty ? "Liste vide" : "Liste non vide";
  print(isEmpty);
}
