import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const CustomSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: 'Search by city or location',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
