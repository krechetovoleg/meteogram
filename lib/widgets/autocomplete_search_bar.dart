import 'package:flutter/material.dart';
import 'package:meteogram/models/city_search_model.dart';
import 'package:meteogram/utils/debouncer.dart';
import 'package:meteogram/services/city_search_servises.dart';

class AutocompleteSearchBar extends StatefulWidget {
  final Function() onSuggestionSelected;

  const AutocompleteSearchBar({super.key, required this.onSuggestionSelected});

  @override
  State<AutocompleteSearchBar> createState() => _AutocompleteSearchBarState();
}

class _AutocompleteSearchBarState extends State<AutocompleteSearchBar> {
  String? _currentQuery;
  late final List<Widget> _lastOptions = <Widget>[];
  late final Debounceable<List<CiySearch>?, String> _debounceable;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
