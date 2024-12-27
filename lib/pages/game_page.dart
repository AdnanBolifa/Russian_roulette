import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/player_card.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<TextEditingController> playerControllers = [];
  List<String> playerNames = [];
  List<int> shotsFired = [];
  List<bool> alivePlayers = [];
  bool gameStarted = false;
  bool gameOver = false;
  String? selectedPlayer; // Track selected player for taking the shot

  // Initialize player controllers
  @override
  void initState() {
    super.initState();
    playerControllers = List.generate(4, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose controllers when no longer needed
    for (var controller in playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Start the game with the entered names
  void startGame() {
    setState(() {
      playerNames =
          playerControllers.map((controller) => controller.text).toList();
      shotsFired = List.generate(playerNames.length, (_) => 0);
      alivePlayers = List.generate(playerNames.length, (_) => true);
      selectedPlayer = playerNames.isNotEmpty
          ? playerNames[0]
          : null; // Set the initial selected player
      gameStarted = true;
      gameOver = false;
    });
  }

  // Handle pulling the trigger (game logic)
  void _pullTrigger() {
    if (selectedPlayer != null) {
      // Game logic for selected player here
      setState(() {
        // Increment the shots fired and mark the player as dead if needed
        int playerIndex = playerNames.indexOf(selectedPlayer!);
        shotsFired[playerIndex]++;
        if (shotsFired[playerIndex] >= 6) {
          alivePlayers[playerIndex] = false;
          gameOver = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!gameStarted) ...[
                  // If the game hasn't started, show text fields for name entry
                  const Text(
                    'Enter Player Names:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Create text fields for each player to enter their name
                  for (int i = 0;
                      i < 4;
                      i++) // You can change the number of players
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: playerControllers[i],
                        decoration: InputDecoration(
                          labelText: 'Player ${i + 1} Name',
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Start Game'),
                  ),
                ] else ...[
                  // Once the game has started, display the game board
                  const Text(
                    "Game Started!",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Player selection dropdown
                  if (!gameOver) ...[
                    const Text(
                      "Select Player to Take Shot:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    DropdownButton<String>(
                      value: selectedPlayer,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPlayer = newValue;
                        });
                      },
                      items: playerNames
                          .map<DropdownMenuItem<String>>((String player) {
                        return DropdownMenuItem<String>(
                          value: player,
                          child: Text(player,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Display the game cards for each player
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: playerNames.length,
                    itemBuilder: (context, index) {
                      return PlayerCard(
                        playerName: playerNames[index],
                        shotsFired: shotsFired[index],
                        isAlive: alivePlayers[index],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  if (!gameOver)
                    ElevatedButton(
                      onPressed: _pullTrigger,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Pull Trigger',
                          style: TextStyle(fontSize: 18)),
                    ),
                  if (gameOver)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          gameStarted = false;
                          gameOver = false;
                          playerControllers = List.generate(
                              4, (_) => TextEditingController());
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Restart Game'),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
