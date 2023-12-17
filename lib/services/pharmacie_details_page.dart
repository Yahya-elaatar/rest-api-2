import 'package:flutter/material.dart';
import 'package:flutter_pharmacies_2023/models/pharmacie_model.dart';

class PharmacieDetailsPage extends StatelessWidget {
  final Pharmacie pharmacie;

  PharmacieDetailsPage({required this.pharmacie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacie Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom: ${pharmacie.nom}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Quartier: ${pharmacie.quartier}'),
            SizedBox(height: 8),
            Text('Latitude: ${pharmacie.latitude}'),
            SizedBox(height: 8),
            Text('Longitude: ${pharmacie.longitude}'),
            // Add other details as needed
          ],
        ),
      ),
    );
  }
}
