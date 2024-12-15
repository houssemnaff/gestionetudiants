import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDetailsPage extends StatelessWidget {
  final Map<String, dynamic> student;

  StudentDetailsPage({required this.student});

  void _makeCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Impossible de lancer $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'Étudiant'),
         backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           Text('Nom: ${student['name']}', 
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

Text('Classe: ${student['class']}', 
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),


Text('Téléphone: ${student['phone']}', 
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    
Text('Adresse: ${student['address']}', 
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),


           ElevatedButton.icon(
  icon: Icon(Icons.call, color: Colors.white),  // Icon color
  label: Text('Appeler', style: TextStyle(fontSize: 18, color: Colors.white)),  // Text styling
  onPressed: () => _makeCall(student['phone']),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green, // background color
    foregroundColor: Colors.white, // text color
    

    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),  // Padding for the button
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),  // Rounded corners
    ),
    elevation: 5,  // Adding elevation for a raised effect
    shadowColor: Colors.black.withOpacity(0.3),  // Shadow color for a better depth effect
  ),
)

          ],
        ),
      ),
    );
  }
}
