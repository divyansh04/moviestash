import 'package:flutter/material.dart';

class RemoveBookmarkButton extends StatelessWidget {
  const RemoveBookmarkButton({required this.onBookmarkRemoved, super.key});

  final VoidCallback? onBookmarkRemoved;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: onBookmarkRemoved,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
