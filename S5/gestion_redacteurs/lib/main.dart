import 'package:flutter/material.dart';
import 'models/redacteur.dart';
import 'services/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Rédacteurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD81B60),
          primary: const Color(0xFFD81B60),
        ),
        useMaterial3: true,
      ),
      home: const RedacteurHomePage(),
    );
  }
}

class RedacteurHomePage extends StatefulWidget {
  const RedacteurHomePage({super.key});

  @override
  State<RedacteurHomePage> createState() => _RedacteurHomePageState();
}

class _RedacteurHomePageState extends State<RedacteurHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  late Future<List<Redacteur>> _redacteurs;

  @override
  void initState() {
    super.initState();
    _refreshRedacteurs();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _refreshRedacteurs() {
    setState(() {
      _redacteurs = _dbHelper.getAllRedacteurs();
    });
  }

  void _addRedacteur() async {
    if (_formKey.currentState!.validate()) {
      final r = Redacteur(
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        age: 0, // Age not in the form screenshots but required by model
      );

      await _dbHelper.insertRedacteur(r);
      _nomController.clear();
      _prenomController.clear();
      _emailController.clear();
      _refreshRedacteurs();
    }
  }

  void _showEditDialog(Redacteur redacteur) async {
    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Modifier Rédacteur',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: 'Nouveau Nom'),
            ),
            TextField(
              controller: prenomController,
              decoration: const InputDecoration(labelText: 'Nouveau Prénom'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Nouvel Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );

    if (result == true) {
      final updated = Redacteur(
        id: redacteur.id,
        nom: nomController.text,
        prenom: prenomController.text,
        email: emailController.text,
        age: redacteur.age,
      );
      await _dbHelper.updateRedacteur(updated);
      _refreshRedacteurs();
    }
  }

  void _deleteRedacteur(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce rédacteur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Color(0xFFD81B60)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbHelper.deleteRedacteur(id);
      _refreshRedacteurs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final magenta = const Color(0xFFD81B60);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion des rédacteurs',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: magenta,
        leading: const Icon(Icons.menu, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Form Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  TextFormField(
                    controller: _prenomController,
                    decoration: const InputDecoration(labelText: 'Prénom'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _addRedacteur,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Ajouter un Rédacteur',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: magenta,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List Section
          Expanded(
            child: Container(
              color:
                  Colors.grey[200], // Light gray background for the list area
              child: FutureBuilder<List<Redacteur>>(
                future: _redacteurs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun rédacteur trouvé.'));
                  }

                  final redacteurs = snapshot.data!;
                  return ListView.builder(
                    itemCount: redacteurs.length,
                    itemBuilder: (context, index) {
                      final r = redacteurs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(
                            '${r.prenom} ${r.nom}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            r.email,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: magenta),
                                onPressed: () => _showEditDialog(r),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: magenta),
                                onPressed: () => _deleteRedacteur(r.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
