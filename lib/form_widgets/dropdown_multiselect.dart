import 'package:flutter/material.dart';

class DropdownListWithListView extends StatefulWidget {
  final List<String> options;
  final String title;

  DropdownListWithListView({required this.options, required this.title});

  @override
  _DropdownListWithListViewState createState() =>
      _DropdownListWithListViewState();
}

class _DropdownListWithListViewState extends State<DropdownListWithListView> {
  List<String> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: widget.title,
            border: OutlineInputBorder(),
          ),
          items: widget.options
              .map((option) => DropdownMenuItem(
            value: option,
            child: Text(option),
          ))
              .toList(),
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                _selectedOptions.add(value);
              });
            }
          },
        ),
        SizedBox(height: 10),
        Text('Selected options:'),
        SizedBox(height: 5),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _selectedOptions.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Text(_selectedOptions[index]),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      _selectedOptions.removeAt(index);
                    });
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
