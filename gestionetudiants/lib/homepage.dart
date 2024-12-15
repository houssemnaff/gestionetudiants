import 'package:flutter/material.dart';
import 'package:gestionetudiants/add_edit_student_page.dart';
import 'package:gestionetudiants/database_helper.dart';
import 'package:gestionetudiants/editeretudiant.dart';
import 'package:gestionetudiants/student_details_page.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> filteredStudents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshStudents();
  }

  /// Rafraîchir la liste des étudiants
  void _refreshStudents() async {
    final data = await DatabaseHelper.getStudents();
    setState(() {
      students = data;
      filteredStudents = data; // Initialement, tous les étudiants sont affichés
    });
  }

  /// Rechercher un étudiant par nom ou classe
  void _searchStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudents = students;
      } else {
        filteredStudents = students.where((student) {
          return student['name'].toLowerCase().contains(query.toLowerCase()) ||
              student['class'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  /// Supprimer un étudiant
  void _deleteStudent(int id) async {
    // Show a confirmation dialog
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Confirmer la suppression',
      text: 'Êtes-vous sûr de vouloir supprimer cet étudiant ?',
      confirmBtnText: 'Oui',
      cancelBtnText: 'Non',
      onConfirmBtnTap: () async {
        await DatabaseHelper.deleteStudent(id); // Proceed with deletion
        _refreshStudents();
        Navigator.pop(context); // Close the dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Étudiant supprimé avec succès !')),
        );
      },
      onCancelBtnTap: () {
        Navigator.pop(context); // Close the dialog
      },
    );
  }

  /// Affiche une boîte de dialogue pour la recherche
  void showSearchDialog(BuildContext context) {
    String query = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rechercher un étudiant'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Entrez un nom ou une classe',
            ),
            onChanged: (value) {
              query = value.trim().toLowerCase();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                searchController.clear();
                _searchStudents('');
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _searchStudents(query);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Étudiants'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
        ],
      ),
      body: filteredStudents.isEmpty
          ? Center(child: Text('Aucun étudiant trouvé.'))
          : ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 229, 229), // Set the background color for each item
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Add a black border between items
                        width: 2.0, // Set the border thickness
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(filteredStudents[index]['name']),
                    subtitle: Text(filteredStudents[index]['class']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon for editing
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditStudentPage(
                                  student: filteredStudents[index],
                                ),
                              ),
                            ).then((result) {
                              if (result == true) _refreshStudents(); // Refresh the list if successful
                            });
                          },
                        ),
                        // Icon for deleting
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteStudent(filteredStudents[index]['id']),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to student details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentDetailsPage(
                            student: filteredStudents[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddStudentPage(),
            ),
          ).then((_) => _refreshStudents());
        },
      ),
    );
  }
}
