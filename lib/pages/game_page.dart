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
  List<int> bulletPositions = []; // Store bullet position for each player
  bool gameStarted = false;
  bool gameOver = false;
  String? selectedPlayer; // Track selected player for taking the shot

  @override
  void initState() {
    super.initState();
    playerControllers = List.generate(4, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startGame() {
    setState(() {
      if (playerNames.isEmpty) {
        playerNames =
            playerControllers.map((controller) => controller.text).toList();
      }
      shotsFired = List.generate(playerNames.length, (_) => 0);
      alivePlayers = List.generate(playerNames.length, (_) => true);
      bulletPositions = List.generate(
          playerNames.length,
          (_) =>
              Random().nextInt(6) +
              1); // Random bullet position between 1 and 6
      selectedPlayer = playerNames.isNotEmpty ? playerNames[0] : null;
      gameStarted = true;
      gameOver = false;
    });
  }

  // Function to check if only one player is alive
  bool checkIfGameOver() {
    int aliveCount = alivePlayers.where((player) => player).toList().length;
    return aliveCount <= 1;
  }

  // Handle pulling the trigger (game logic)
  void _pullTrigger() {
    if (selectedPlayer != null) {
      setState(() {
        int playerIndex = playerNames.indexOf(selectedPlayer!);
        shotsFired[playerIndex]++;

        // Check if this player's shot hits the bullet
        if (shotsFired[playerIndex] == bulletPositions[playerIndex]) {
          alivePlayers[playerIndex] = false; // The player dies
        }

        // Check if there's only one player left
        if (checkIfGameOver()) {
          gameOver = true;
        }
      });
    }
  }

  void resetGame() {
    setState(() {
      shotsFired = List.generate(playerNames.length, (_) => 0);
      alivePlayers = List.generate(playerNames.length, (_) => true);
      bulletPositions =
          List.generate(playerNames.length, (_) => Random().nextInt(6) + 1);
      gameStarted = true;
      gameOver = false;
      selectedPlayer = playerNames.isNotEmpty ? playerNames[0] : null;
    });
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
                  const Text(
                    'Enter Player Names:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  for (int i = 0; i < 4; i++)
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
                  if (!gameOver) ...[
                    // Player selection dropdown
                    const Text(
                      "Select Player to Take Shot:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    DropdownButton<String>(
                      value: (selectedPlayer != null &&
                              alivePlayers[
                                  playerNames.indexOf(selectedPlayer!)])
                          ? selectedPlayer
                          : playerNames
                              .asMap()
                              .entries
                              .firstWhere(
                                (entry) => alivePlayers[entry.key],
                                orElse: () => const MapEntry(-1,
                                    ''), // Fallback to an empty string if no alive players
                              )
                              .value,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPlayer = newValue;
                        });
                      },
                      items: playerNames
                          .asMap()
                          .entries
                          .where((entry) => alivePlayers[entry.key])
                          .map<DropdownMenuItem<String>>((entry) {
                        String player = entry.value;
                        return DropdownMenuItem<String>(
                          value: player,
                          child: Text(
                            player,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                  ],
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
                      onPressed: resetGame,
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
