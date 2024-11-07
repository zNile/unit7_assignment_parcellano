import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CombatStyle {
  final String name;
  final String description;
  final String img;

  CombatStyle({required this.name, required this.description, required this.img});

  factory CombatStyle.fromJson(Map<String, dynamic> json) {
    return CombatStyle(
      name: json['name'],
      description: json['description'],
      img: json['img'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<CombatStyle>> fetchCombatStyles() async {
    final response = await http.get(Uri.parse('https://www.demonslayer-api.com/api/v1/combat-styles'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> combatStyleData = data['content'];
      return combatStyleData.map((json) => CombatStyle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load combat styles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: FutureBuilder(
        future: fetchCombatStyles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final combatStyles = snapshot.data!;
            return ListView.builder(
              itemCount: combatStyles.length,
              itemBuilder: (context, index) {
                final combatStyle = combatStyles[index];
                return ExpansionTile(
                  title: Text(combatStyle.name),
                  leading: CircleAvatar(
                    backgroundImage: combatStyle.img.isEmpty
                        ? null
                        : NetworkImage(combatStyle.img),
                  ),
                  children: [
                    ListTile(
                      title: Text(combatStyle.description),
                      // Add more details as needed
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}