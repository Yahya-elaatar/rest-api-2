import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pharmacies_2023/models/pharmacie_model.dart';

class PharmacieService {
  final String apiUrl = 'http://localhost:3000/pharmacies';

  Future<List<Pharmacie>> chargerPharmacies() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Pharmacie> pharmacies = data.map((json) => Pharmacie.fromJson(json)).toList();
        return pharmacies;
      } else {
        throw Exception('Failed to load pharmacies');
      }
    } catch (e) {
      throw Exception('Error loading pharmacies: $e');
    }
  }

  Future<void> ajouterPharmacie(Pharmacie nouvellePharmacie) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(nouvellePharmacie.toJson()),
      );

      if (response.statusCode == 201) {
        // Pharmacy added successfully
      } else {
        throw Exception('Failed to add pharmacy');
      }
    } catch (e) {
      throw Exception('Error adding pharmacy: $e');
    }
  }

  Future<void> modifierPharmacie(Pharmacie pharmacieModifiee) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${pharmacieModifiee.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pharmacieModifiee.toJson()),
      );

      if (response.statusCode == 200) {
        // Pharmacy modified successfully
      } else {
        throw Exception('Failed to modify pharmacy');
      }
    } catch (e) {
      throw Exception('Error modifying pharmacy: $e');
    }
  }

  Future<void> supprimerPharmacie(String idPharmacie) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$idPharmacie'),
      );

      if (response.statusCode == 204) {
        // Pharmacy deleted successfully
      } else {
        throw Exception('Failed to delete pharmacy');
      }
    } catch (e) {
      throw Exception('Error deleting pharmacy: $e');
    }
  }
}
