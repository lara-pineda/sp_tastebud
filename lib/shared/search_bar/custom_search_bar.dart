import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        onSubmitted: widget.onSubmitted,
        style:
            TextStyle(fontSize: 13, color: Colors.black87, fontFamily: 'Inter'),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white60,
          labelText: 'Search',
          border: OutlineInputBorder(),

          // search icon
          prefixIcon: Icon(Icons.search),
          prefixIconColor: Colors.blueGrey,

          // clear search bar icon
          suffixIconColor: Colors.blueGrey,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              widget.onSubmitted('');
            },
          ),
        ),
      ),
    );
  }
}
