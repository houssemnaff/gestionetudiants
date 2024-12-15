import 'package:flutter/material.dart';
import 'package:gestionetudiants/database_helper.dart';

class EditStudentPage extends StatefulWidget {
  final Map<String, dynamic> student;

  EditStudentPage({required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController classController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialiser les champs avec les données existantes de l'étudiant
    nameController.text = widget.student['name'];
    classController.text = widget.student['class'];
    phoneController.text = widget.student['phone'];
    addressController.text = widget.student['address'];
  }

  /// Met à jour l'étudiant
  void _updateStudent() async {
    if (nameController.text.isEmpty || classController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs obligatoires.')),
      );
      return;
    }

    final data = {
      'name': nameController.text.trim(),
      'class': classController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
    };

    await DatabaseHelper.updateStudent(widget.student['id'], data);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Étudiant modifié avec succès !')),
    );

    Navigator.pop(context, true); // Retourner à la page précédente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Étudiant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nom et Prénom *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: classController,
                decoration: InputDecoration(
                  labelText: 'Classe *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Numéro de Téléphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _updateStudent,
                icon: Icon(Icons.save),
                label: Text('Modifier'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
