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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const RedacteurListPage(),
    );
  }
}

class RedacteurListPage extends StatefulWidget {
  const RedacteurListPage({super.key});

  @override
  State<RedacteurListPage> createState() => _RedacteurListPageState();
}

class _RedacteurListPageState extends State<RedacteurListPage> {
  final DBHelper _dbHelper = DBHelper();
  late Future<List<Redacteur>> _redacteurs;

  @override
  void initState() {
    super.initState();
    _refreshRedacteurs();
  }

  void _refreshRedacteurs() {
    setState(() {
      _redacteurs = _dbHelper.getAllRedacteurs();
    });
  }

  void _showForm(Redacteur? redacteur) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => RedacteurForm(redacteur: redacteur),
    );

    if (result == true) {
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
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Rédacteurs'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Redacteur>>(
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
              return ListTile(
                title: Text('${r.prenom} ${r.nom}'),
                subtitle: Text('${r.email} - ${r.age} ans'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showForm(r),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRedacteur(r.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RedacteurForm extends StatefulWidget {
  final Redacteur? redacteur;
  const RedacteurForm({super.key, this.redacteur});

  @override
  State<RedacteurForm> createState() => _RedacteurFormState();
}

class _RedacteurFormState extends State<RedacteurForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.redacteur != null) {
      _nomController.text = widget.redacteur!.nom;
      _prenomController.text = widget.redacteur!.prenom;
      _emailController.text = widget.redacteur!.email;
      _ageController.text = widget.redacteur!.age.toString();
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final r = Redacteur(
        id: widget.redacteur?.id,
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        age: int.parse(_ageController.text),
      );

      if (widget.redacteur == null) {
        await _dbHelper.insertRedacteur(r);
      } else {
        await _dbHelper.updateRedacteur(r);
      }

      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.redacteur == null
                  ? 'Ajouter un Rédacteur'
                  : 'Modifier le Rédacteur',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
              validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
            ),
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || !v.contains('@') ? 'Email invalide' : null,
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Âge'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  v == null || int.tryParse(v) == null ? 'Âge invalide' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Text(
                widget.redacteur == null ? 'Ajouter' : 'Mettre à jour',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
