import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/delivery_status_enum.dart';
import 'package:gvm_flutter/src/models/driver_status_enum.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/utils.dart';

class DeliveriesFilters extends StatelessWidget {
  final String? searchQuery;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DeliveryStatusEnum? selectedStatus;
  final DriverStatusEnum? selectedDriverStatus;
  final Function(String?) onSearchChanged;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(DeliveryStatusEnum?) onStatusChanged;
  final Function(DriverStatusEnum?) onDriverStatusChanged;
  final VoidCallback onClearFilters;

  const DeliveriesFilters({
    super.key,
    this.searchQuery,
    this.selectedStartDate,
    this.selectedEndDate,
    this.selectedStatus,
    this.selectedDriverStatus,
    required this.onSearchChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onStatusChanged,
    required this.onDriverStatusChanged,
    required this.onClearFilters,
  });

  void _showFilterBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        // Add StatefulBuilder here
        builder: (context, setState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) => FilterBottomSheet(
            scrollController: scrollController,
            selectedStatus: selectedStatus,
            selectedDriverStatus: selectedDriverStatus,
            selectedStartDate: selectedStartDate,
            selectedEndDate: selectedEndDate,
            onStatusChanged: (value) {
              onStatusChanged(value);
            },
            onDriverStatusChanged: (value) {
              onDriverStatusChanged(value);
            },
            onStartDateChanged: onStartDateChanged,
            onEndDateChanged: onEndDateChanged,
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
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchDeliveries,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: onSearchChanged,
                controller: TextEditingController(text: searchQuery),
              ),
              const SizedBox(height: 8),
              // Filter Button
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
                    selectedStartDate: selectedStartDate,
                    selectedEndDate: selectedEndDate,
                    selectedStatus: selectedStatus,
                    selectedDriverStatus: selectedDriverStatus,
                    onClearFilters: onClearFilters,
                    onStartDateChanged: onStartDateChanged,
                    onEndDateChanged: onEndDateChanged,
                    onStatusChanged: onStatusChanged,
                    onDriverStatusChanged: onDriverStatusChanged,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool get _hasActiveFilters =>
      selectedStartDate != null ||
      selectedEndDate != null ||
      selectedStatus != null ||
      selectedDriverStatus != null;
}

class FilterBottomSheet extends StatefulWidget {
  // Changed to StatefulWidget
  final ScrollController scrollController;
  final DeliveryStatusEnum? selectedStatus;
  final DriverStatusEnum? selectedDriverStatus;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Function(DeliveryStatusEnum?) onStatusChanged;
  final Function(DriverStatusEnum?) onDriverStatusChanged;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;

  const FilterBottomSheet({
    super.key,
    required this.scrollController,
    required this.selectedStatus,
    required this.selectedDriverStatus,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onStatusChanged,
    required this.onDriverStatusChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  DeliveryStatusEnum? _selectedStatus;
  DriverStatusEnum? _selectedDriverStatus;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.selectedStatus;
    _selectedDriverStatus = widget.selectedDriverStatus;
    _selectedStartDate = widget.selectedStartDate;
    _selectedEndDate = widget.selectedEndDate;
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
                title: AppLocalizations.of(context).dateRange,
                child: Column(
                  children: [
                    _DatePickerButton(
                      label: AppLocalizations.of(context).startDate,
                      selectedDate: _selectedStartDate,
                      onDateSelected: (date) {
                        setState(() => _selectedStartDate = date);
                        widget.onStartDateChanged(date);
                      },
                    ),
                    const SizedBox(height: 8),
                    _DatePickerButton(
                      label: AppLocalizations.of(context).endDate,
                      selectedDate: _selectedEndDate,
                      onDateSelected: (date) {
                        setState(() => _selectedEndDate = date);
                        widget.onEndDateChanged(date);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _FilterSection(
                title: AppLocalizations.of(context).deliveryStatus,
                child: _StatusSelector<DeliveryStatusEnum>(
                  values: DeliveryStatusEnum.values,
                  selectedValue: _selectedStatus,
                  onChanged: (value) {
                    setState(() => _selectedStatus = value);
                    widget.onStatusChanged(value);
                  },
                  getDisplayName: (status) =>
                      DeliveriesUtils.getStatusName(context, status),
                ),
              ),
              const SizedBox(height: 24),
              _FilterSection(
                title: AppLocalizations.of(context).driverStatus,
                child: _StatusSelector<DriverStatusEnum>(
                  values: DriverStatusEnum.values,
                  selectedValue: _selectedDriverStatus,
                  onChanged: (value) {
                    setState(() => _selectedDriverStatus = value);
                    widget.onDriverStatusChanged(value);
                  },
                  getDisplayName: (status) =>
                      DriverUtils.getStatusName(context, status),
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

class _DatePickerButton extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;

  const _DatePickerButton({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            onDateSelected(picked);
          }
        },
        icon: const Icon(Icons.calendar_today),
        label: Text(
          selectedDate != null
              ? selectedDate!.toLocal().toString().split(' ')[0]
              : label,
        ),
      ),
    );
  }
}

class _StatusSelector<T> extends StatelessWidget {
  final List<T> values;
  final T? selectedValue;
  final Function(T?) onChanged;
  final String Function(T) getDisplayName;

  const _StatusSelector({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onChanged,
    required this.getDisplayName,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          // Changed from FilterChip to ChoiceChip
          label: Text(AppLocalizations.of(context).all),
          selected: selectedValue == null,
          onSelected: (selected) {
            if (selected) {
              onChanged(null);
            }
          },
        ),
        ...values.map((value) => ChoiceChip(
              // Changed from FilterChip to ChoiceChip
              label: Text(getDisplayName(value)),
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
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final DeliveryStatusEnum? selectedStatus;
  final DriverStatusEnum? selectedDriverStatus;
  final VoidCallback onClearFilters;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final Function(DeliveryStatusEnum?) onStatusChanged;
  final Function(DriverStatusEnum?) onDriverStatusChanged;

  const _ActiveFiltersChips({
    this.selectedStartDate,
    this.selectedEndDate,
    this.selectedStatus,
    this.selectedDriverStatus,
    required this.onClearFilters,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onStatusChanged,
    required this.onDriverStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (selectedStartDate != null || selectedEndDate != null)
          Chip(
            label: Text(
              '${selectedStartDate?.toString().split(' ')[0] ?? ''}${selectedStartDate != null ? ' - ' : '${AppLocalizations.of(context).until} '}${selectedEndDate != null ? selectedEndDate?.toString().split(' ')[0] : AppLocalizations.of(context).now}',
            ),
            onDeleted: () {
              onStartDateChanged(null);
              onEndDateChanged(null);
            },
          ),
        if (selectedStatus != null)
          Chip(
            label:
                Text(DeliveriesUtils.getStatusName(context, selectedStatus!)),
            onDeleted: () => onStatusChanged(null),
          ),
        if (selectedDriverStatus != null)
          Chip(
            label:
                Text(DriverUtils.getStatusName(context, selectedDriverStatus!)),
            onDeleted: () => onDriverStatusChanged(null),
          ),
      ],
    );
  }
}
