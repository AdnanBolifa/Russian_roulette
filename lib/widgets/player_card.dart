import 'package:flutter/material.dart';

class PlayerCard extends StatefulWidget {
  final String playerName;
  final int shotsFired;
  final bool isAlive;
  final bool isSelected;
  final VoidCallback onTap;

  const PlayerCard({
    Key? key,
    required this.playerName,
    required this.shotsFired,
    required this.isAlive,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.isAlive
              ? (widget.isSelected ? Colors.green[300] : Colors.blue[200])
              : Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
          border: widget.isSelected
              ? Border.all(color: Colors.green[800]!, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? Colors.green.withOpacity(0.6)
                  : Colors.black.withOpacity(0.2),
              blurRadius: widget.isSelected ? 10 : 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.playerName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isAlive ? Colors.black : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isAlive
                    ? 'Shots Fired: ${widget.shotsFired} / 6'
                    : 'Eliminated',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle:
                      widget.isAlive ? FontStyle.normal : FontStyle.italic,
                  color: widget.isAlive ? Colors.black : Colors.red[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
