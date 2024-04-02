import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: const TextField(
            decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white60,
          labelText: 'Search',
          border: OutlineInputBorder(),

          // search icon
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Colors.blueGrey,

          // filter icon
          suffixIcon: Icon(Icons.filter_alt_outlined),
          suffixIconColor: Colors.blueGrey,
        )));
  }
}
