import 'package:flutter/material.dart';
import 'package:flutter_pharmacies_2023/models/pharmacie_model.dart';
import 'package:flutter_pharmacies_2023/services/pharmacie_service.dart';

import '../services/pharmacie_details_page.dart';

class PharmaciesEcran extends StatefulWidget {
  @override
  _PharmaciesEcranState createState() => _PharmaciesEcranState();
}

class _PharmaciesEcranState extends State<PharmaciesEcran> {
  final PharmacieService pharmacieService = PharmacieService();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _quartierController = TextEditingController();

  Future<List<Pharmacie>> chargerPharmacies() async {
    try {
      final pharmacies = await pharmacieService.chargerPharmacies();
      return pharmacies;
    } catch (e) {
      throw Exception('Erreur de chargement des pharmacies: $e');
    }
  }

  

  void _ajouterPharmacie() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une pharmacie'),
          content: Column(
            children: [
              TextField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom de la pharmacie'),
              ),
              TextField(
                controller: _quartierController,
                decoration: InputDecoration(labelText: 'Quartier'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await pharmacieService.ajouterPharmacie(
                  Pharmacie(
                    nom: _nomController.text,
                    quartier: _quartierController.text,
                    latitude: 0.0,
                    longitude: 0.0,
                  ),
                );

                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _modifierPharmacie(Pharmacie pharmacie) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier la pharmacie'),
          content: Column(
            children: [
              TextField(
                controller: _nomController..text = pharmacie.nom,
                decoration: InputDecoration(labelText: 'Nom de la pharmacie'),
              ),
              TextField(
                controller: _quartierController..text = pharmacie.quartier,
                decoration: InputDecoration(labelText: 'Quartier'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await pharmacieService.modifierPharmacie(
                  pharmacie.copyWith(
                    nom: _nomController.text,
                    quartier: _quartierController.text,
                  ),
                );

                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  void _supprimerPharmacie(Pharmacie pharmacie) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer la pharmacie'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette pharmacie ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await pharmacieService.supprimerPharmacie(pharmacie.id);

                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Supprimer'),
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
        title: Text('Liste des pharmacies'),
      ),
      body: FutureBuilder<List<Pharmacie>>(
        future: chargerPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Aucune pharmacie disponible.'),
            );
          } else {
            final pharmacies = snapshot.data!;
            return ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacie = pharmacies[index];
                return ListTile(
                  title: Text(pharmacie.nom),
                  subtitle: Text(pharmacie.quartier),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PharmacieDetailsPage(pharmacie: pharmacie),
                      ),
                    );
                  },
                  onLongPress: () {
                    _afficherOptionsPharmacie(pharmacie);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterPharmacie,
        tooltip: 'Ajouter une pharmacie',
        child: Icon(Icons.add),
      ),
    );
  }

  void _afficherOptionsPharmacie(Pharmacie pharmacie) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                _modifierPharmacie(pharmacie);
              },
            ),
            ListTile(
              title: Text('Supprimer'),
              onTap: () {
                Navigator.pop(context);
                _supprimerPharmacie(pharmacie);
              },
            ),
          ],
        );
      },
    );
  }
}
