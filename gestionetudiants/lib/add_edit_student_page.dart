import 'package:flutter/material.dart';
import 'package:gestionetudiants/database_helper.dart';
import 'package:quickalert/quickalert.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _class;
  String? _phone;
  String? _address;

  /// Ajoute un nouvel étudiant
  void _addStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Enregistre les valeurs des champs

      final data = {
        'name': _name!.trim(),
        'class': _class!.trim(),
        'phone': _phone?.trim(),  // Optional field
        'address': _address?.trim(),  // Optional field
      };

      await DatabaseHelper.addStudent(data);

      // Show the success alert using QuickAlert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Succès',
        text: 'Étudiant ajouté avec succès !',
        onConfirmBtnTap: () {
          Navigator.pop(context, true); // Return to the previous page
        },
      );
    }
  }

  /// Valide les champs obligatoires
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire.';
    }
    return null;
  }

  /// Valide le numéro de téléphone (facultatif, mais s'il est rempli, il doit être valide)
  String? _validatePhone(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final phoneRegExp = RegExp(r'^\d{8,15}$'); // Ex: 8-15 chiffres
      if (!phoneRegExp.hasMatch(value)) {
        return 'Entrez un numéro de téléphone valide.';
      }
    }
    return null;  // Si vide, c'est valide aussi
  }

  /// Valide l'adresse (facultative)
  String? _validateAddress(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.length < 5) {
        return 'L\'adresse doit contenir au moins 5 caractères.';
      }
    }
    return null;  // Si vide, c'est valide aussi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Étudiant'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nom et Prénom *',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequired,
                  onSaved: (value) => _name = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Classe *',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRequired,
                  onSaved: (value) => _class = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Numéro de Téléphone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,  // Only validate if not empty
                  onSaved: (value) => _phone = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateAddress,  // Only validate if not empty
                  onSaved: (value) => _address = value,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _addStudent,
                  icon: Icon(Icons.save),
                  label: Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
