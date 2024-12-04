import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/delivery_requests.dart';
import 'package:gvm_flutter/src/models/response/employee_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/delivery_read.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/utils.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:intl/intl.dart';

class DeliveryEdit extends StatefulWidget {
  final Delivery delivery;

  const DeliveryEdit({super.key, required this.delivery});

  @override
  _DeliveryEditState createState() => _DeliveryEditState();
}

class _DeliveryEditState extends State<DeliveryEdit> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late int? employeeId;
  late DateTime? startDate;
  late DeliveryStatusEnum? status;
  late DriverStatusEnum? driverStatus;
  late BusinessStatusEnum? businessStatus;

  late Address? selectedAddress;
  List<Employee> employees = [];
  Sale? sale;

  @override
  void initState() {
    super.initState();
    employeeId = widget.delivery.employeeId;
    startDate = widget.delivery.startDate;
    status = widget.delivery.status;
    driverStatus = widget.delivery.driverStatus;
    selectedAddress = widget.delivery.address;
    businessStatus = widget.delivery.businessStatus;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      final employeesResponse = await AuthManager.instance.apiService
          .get<GetEmployeesResponse>('/api/employees',
              fromJson: GetEmployeesResponse.fromJson);
      final saleResponse = await AuthManager.instance.apiService.get<Sale>(
          '/api/sales/${widget.delivery.saleId}',
          fromJson: Sale.fromJson);

      setState(() {
        employees = employeesResponse.data?.employees ?? [];
        sale = saleResponse.data;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateDelivery() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).fixErrors)),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final request = UpdateDeliveryRequest(
        deliveryId: widget.delivery.id!,
        employeeId: employeeId!,
        addressId: selectedAddress!.id!,
        startDate: startDate!,
        status: status!.name,
        businessStatus: businessStatus!,
        driverStatus: driverStatus!,
      );

      final response = await AuthManager.instance.apiService.put(
        '/api/deliveries',
        body: request.toJson(),
        fromJson: (json) => Delivery.fromJson(json),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).success)),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryRead(deliveryId: response.data!.id!),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).anErrorOccurred)),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  bool _hasUnsavedChanges() {
    return employeeId != widget.delivery.employeeId ||
        startDate != widget.delivery.startDate ||
        status != widget.delivery.status ||
        businessStatus != widget.delivery.businessStatus ||
        driverStatus != widget.delivery.driverStatus ||
        selectedAddress?.id != widget.delivery.address?.id;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges()) {
          return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).discardChanges),
                  content: Text(
                      AppLocalizations.of(context).discardChangesDescription),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(AppLocalizations.of(context).cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(AppLocalizations.of(context).discard),
                    ),
                  ],
                ),
              ) ??
              false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editDelivery),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: isLoading ? null : _updateDelivery,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSaleInfoCard(),
                const SizedBox(height: 16),
                _buildBasicInfoCard(),
                const SizedBox(height: 16),
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildAddressCard(),
                if (_hasUnsavedChanges()) ...[
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : _updateDelivery,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(AppLocalizations.of(context).save),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).basicInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).employee,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              value: employeeId,
              items: employees
                  .map((employee) => DropdownMenuItem(
                        value: employee.id,
                        child: Text(employee.name ??
                            AppLocalizations.of(context).unnamedEmployee),
                      ))
                  .toList(),
              validator: (value) => value == null
                  ? AppLocalizations.of(context).fieldRequired
                  : null,
              onChanged: (value) => setState(() => employeeId = value),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => startDate = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).date,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  startDate != null
                      ? DateFormat('yyyy-MM-dd').format(startDate!)
                      : AppLocalizations.of(context).selectDate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).status,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BusinessStatusEnum>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).businessStatus,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.business),
              ),
              value: businessStatus,
              items: BusinessStatusEnum.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child:
                            Text(BusinessUtils.getStatusName(context, status)),
                      ))
                  .toList(),
              validator: (value) => value == null
                  ? AppLocalizations.of(context).fieldRequired
                  : null,
              onChanged: (value) => setState(() => businessStatus = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DriverStatusEnum>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).driverStatus,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              value: driverStatus,
              items: DriverStatusEnum.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(DriverUtils.getStatusName(context, status)),
                      ))
                  .toList(),
              validator: (value) => value == null
                  ? AppLocalizations.of(context).fieldRequired
                  : null,
              onChanged: (value) => setState(() => driverStatus = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    final addresses = sale?.customer?.addresses ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).address,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (addresses.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:
                              Text(AppLocalizations.of(context).selectAddress),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: addresses
                                  .map(
                                    (address) => ListTile(
                                      leading: const Icon(Icons.location_on),
                                      title: Text(address.street1 ?? ''),
                                      subtitle: Text(address.city ?? ''),
                                      onTap: () {
                                        setState(
                                            () => selectedAddress = address);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(AppLocalizations.of(context).cancel),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(AppLocalizations.of(context).change),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedAddress != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(selectedAddress!.street1 ?? ''),
                subtitle: Text(selectedAddress!.city ?? ''),
              )
            else if (addresses.isEmpty)
              Center(
                child: Text(AppLocalizations.of(context).noAddress),
              )
            else
              Center(
                child: Text(AppLocalizations.of(context).selectAddress),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).saleInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (sale != null) ...[
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text(
                    '${AppLocalizations.of(context).sale} #${sale!.id.toString().padLeft(4, '0')}'),
                subtitle: Text(sale!.customer?.name ??
                    AppLocalizations.of(context).noCustomer),
              ),
              if (sale!.startDate != null)
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title:
                      Text(DateFormat('yyyy-MM-dd').format(sale!.startDate!)),
                ),
            ] else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
