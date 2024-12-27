import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String playerName;
  final int shotsFired;
  final bool isAlive;

  const PlayerCard(
      {super.key,
      required this.playerName,
      required this.shotsFired,
      required this.isAlive});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isAlive ? Colors.green : Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add a person icon here
          const Icon(
            Icons.person,
            size: 40, // Adjust size as needed
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            playerName,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Shots Fired: $shotsFired',
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          isAlive
              ? const Text(
                  'Alive',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                )
              : const Text(
                  'Dead',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
        ],
      ),
    );
  }
}
