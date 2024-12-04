import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressesFilters extends StatelessWidget {
  final String? searchQuery;
  final String? selectedCity;
  final String? selectedState;
  final bool? selectedEnabled;
  final Function(String?) onSearchChanged;
  final Function(String?) onCityChanged;
  final Function(String?) onStateChanged;
  final Function(bool?) onEnabledChanged;
  final VoidCallback onClearFilters;
  final List<String> cities;
  final List<String> states;

  const AddressesFilters({
    super.key,
    this.searchQuery,
    this.selectedCity,
    this.selectedState,
    this.selectedEnabled,
    required this.onSearchChanged,
    required this.onCityChanged,
    required this.onStateChanged,
    required this.onEnabledChanged,
    required this.onClearFilters,
    required this.cities,
    required this.states,
  });

  void _showFilterBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) => FilterBottomSheet(
            scrollController: scrollController,
            selectedCity: selectedCity,
            selectedState: selectedState,
            selectedEnabled: selectedEnabled,
            onCityChanged: onCityChanged,
            onStateChanged: onStateChanged,
            onEnabledChanged: onEnabledChanged,
            cities: cities,
            states: states,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchAddresses,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: onSearchChanged,
                controller: TextEditingController(text: searchQuery),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showFilterBottomSheet(context),
                  icon: const Icon(Icons.filter_list),
                  label: Text(AppLocalizations.of(context).filters),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              if (_hasActiveFilters)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _ActiveFiltersChips(
                    selectedCity: selectedCity,
                    selectedState: selectedState,
                    selectedEnabled: selectedEnabled,
                    onCityChanged: onCityChanged,
                    onStateChanged: onStateChanged,
                    onEnabledChanged: onEnabledChanged,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool get _hasActiveFilters =>
      selectedCity != null || selectedState != null || selectedEnabled != null;
}

class FilterBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final String? selectedCity;
  final String? selectedState;
  final bool? selectedEnabled;
  final Function(String?) onCityChanged;
  final Function(String?) onStateChanged;
  final Function(bool?) onEnabledChanged;
  final List<String> cities;
  final List<String> states;

  const FilterBottomSheet({
    super.key,
    required this.scrollController,
    required this.selectedCity,
    required this.selectedState,
    required this.selectedEnabled,
    required this.onCityChanged,
    required this.onStateChanged,
    required this.onEnabledChanged,
    required this.cities,
    required this.states,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedCity;
  String? _selectedState;
  bool? _selectedEnabled;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _selectedState = widget.selectedState;
    _selectedEnabled = widget.selectedEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                AppLocalizations.of(context).filters,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              _FilterSection(
                title: AppLocalizations.of(context).city,
                child: _LocationSelector(
                  values: widget.cities,
                  selectedValue: _selectedCity,
                  onChanged: (value) {
                    setState(() => _selectedCity = value);
                    widget.onCityChanged(value);
                  },
                ),
              ),
              const SizedBox(height: 24),
              _FilterSection(
                title: AppLocalizations.of(context).state,
                child: _LocationSelector(
                  values: widget.states,
                  selectedValue: _selectedState,
                  onChanged: (value) {
                    setState(() => _selectedState = value);
                    widget.onStateChanged(value);
                  },
                ),
              ),
              const SizedBox(height: 24),
              _FilterSection(
                title: AppLocalizations.of(context).status,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context).all),
                      selected: _selectedEnabled == null,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedEnabled = null);
                          widget.onEnabledChanged(null);
                        }
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context).enabled),
                      selected: _selectedEnabled == true,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedEnabled = true);
                          widget.onEnabledChanged(true);
                        }
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context).disabled),
                      selected: _selectedEnabled == false,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedEnabled = false);
                          widget.onEnabledChanged(false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _LocationSelector extends StatelessWidget {
  final List<String> values;
  final String? selectedValue;
  final Function(String?) onChanged;

  const _LocationSelector({
    required this.values,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: Text(AppLocalizations.of(context).all),
          selected: selectedValue == null,
          onSelected: (selected) {
            if (selected) {
              onChanged(null);
            }
          },
        ),
        ...values.map((value) => ChoiceChip(
              label: Text(value),
              selected: selectedValue == value,
              onSelected: (selected) {
                if (selected) {
                  onChanged(value);
                }
              },
            )),
      ],
    );
  }
}

class _ActiveFiltersChips extends StatelessWidget {
  final String? selectedCity;
  final String? selectedState;
  final bool? selectedEnabled;
  final Function(String?) onCityChanged;
  final Function(String?) onStateChanged;
  final Function(bool?) onEnabledChanged;

  const _ActiveFiltersChips({
    this.selectedCity,
    this.selectedState,
    this.selectedEnabled,
    required this.onCityChanged,
    required this.onStateChanged,
    required this.onEnabledChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (selectedCity != null)
          Chip(
            label: Text(selectedCity!),
            onDeleted: () => onCityChanged(null),
          ),
        if (selectedState != null)
          Chip(
            label: Text(selectedState!),
            onDeleted: () => onStateChanged(null),
          ),
        if (selectedEnabled != null)
          Chip(
            label: Text(selectedEnabled == true
                ? AppLocalizations.of(context).enabled
                : AppLocalizations.of(context).disabled),
            onDeleted: () => onEnabledChanged(null),
          ),
      ],
    );
  }
}
