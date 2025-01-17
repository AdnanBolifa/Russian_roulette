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
  List<int> bulletPositions = [];
  bool gameStarted = false;
  bool gameOver = false;
  String? selectedPlayer;

  List<String> roundCards = ['Ace', 'Queen', 'King'];
  String currentRoundCard = 'Ace';

  bool isButtonPressed = false; // Animation state

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
      bulletPositions =
          List.generate(playerNames.length, (_) => Random().nextInt(6) + 1);
      selectedPlayer = playerNames.isNotEmpty ? playerNames[0] : null;
      gameStarted = true;
      gameOver = false;
      currentRoundCard = roundCards[Random().nextInt(roundCards.length)];
    });
  }

  bool checkIfGameOver() {
    int aliveCount = alivePlayers.where((player) => player).toList().length;
    return aliveCount <= 1;
  }

  String? _getNextAlivePlayer(int currentIndex) {
    for (int i = 1; i <= playerNames.length; i++) {
      int nextIndex = (currentIndex + i) % playerNames.length;
      if (alivePlayers[nextIndex]) {
        return playerNames[nextIndex];
      }
    }
    return null; // This should never happen since game over is checked before.
  }

  void _pullTrigger() {
    if (selectedPlayer != null) {
      setState(() {
        int playerIndex = playerNames.indexOf(selectedPlayer!);
        shotsFired[playerIndex]++;

        // Check if this player's shot hits the bullet
        if (shotsFired[playerIndex] == bulletPositions[playerIndex]) {
          alivePlayers[playerIndex] = false; // The player dies

          // Automatically select the next alive player only if the current player is eliminated
          selectedPlayer = _getNextAlivePlayer(playerIndex);
        }

        // Select a new round card ensuring it's not the same as the previous one
        String newCard;
        do {
          newCard = roundCards[Random().nextInt(roundCards.length)];
        } while (newCard == currentRoundCard);

        currentRoundCard = newCard;

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
      currentRoundCard = roundCards[Random().nextInt(roundCards.length)];
    });
  }

  void _selectPlayer(String playerName) {
    if (alivePlayers[playerNames.indexOf(playerName)]) {
      setState(() {
        selectedPlayer = playerName;
      });
    }
  }

  Widget animatedButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isButtonPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isButtonPressed = false;
        });
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(isButtonPressed ? 0.95 : 1.0), // Add scale animation
        padding: EdgeInsets.symmetric(
          vertical: isButtonPressed ? 10 : 12,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isButtonPressed ? Colors.blue[900] : Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isButtonPressed
                  ? Colors.black.withOpacity(0.1)
                  : Colors.black.withOpacity(0.3),
              blurRadius:
                  isButtonPressed ? 6 : 12, // More shadow when not pressed
              offset: Offset(2, isButtonPressed ? 2 : 6), // Elevation effect
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isButtonPressed ? 20 : 18, // Slight font size change
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    animatedButton(
                      label: 'Start Game',
                      onTap: startGame,
                    ),
                  ] else ...[
                    if (!gameOver) ...[
                      Text(
                        'Current Round: $currentRoundCard',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Tap a Player Card to Select:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: playerNames.length,
                      itemBuilder: (context, index) {
                        return PlayerCard(
                          playerName: playerNames[index],
                          shotsFired: shotsFired[index],
                          isAlive: alivePlayers[index],
                          isSelected: playerNames[index] == selectedPlayer,
                          onTap: () => _selectPlayer(playerNames[index]),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    if (!gameOver)
                      animatedButton(
                        label: 'Pull Trigger',
                        onTap: _pullTrigger,
                      ),
                    if (gameOver)
                      animatedButton(
                        label: 'Reset Game',
                        onTap: resetGame,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
