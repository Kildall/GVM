import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/dashboard_responses.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:gvm_flutter/src/widgets/home/stat_card.dart';

enum StatsPeriod { daily, weekly, monthly }

class SalesStatsView extends StatefulWidget {
  final DashboardResponse dashboardData;

  const SalesStatsView({
    super.key,
    required this.dashboardData,
  });

  @override
  _SalesStatsViewState createState() => _SalesStatsViewState();
}

class _SalesStatsViewState extends State<SalesStatsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: StatsPeriod.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getPeriodLabel(BuildContext context, StatsPeriod period) {
    switch (period) {
      case StatsPeriod.daily:
        return AppLocalizations.of(context).daily;
      case StatsPeriod.weekly:
        return AppLocalizations.of(context).weekly;
      case StatsPeriod.monthly:
        return AppLocalizations.of(context).monthly;
    }
  }

  @override
  Widget build(BuildContext context) {
    final periods = StatsPeriod.values;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).salesAndDeliveries),
        bottom: TabBar(
          controller: _tabController,
          tabs: periods
              .map((period) => Tab(text: _getPeriodLabel(context, period)))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: periods.map((period) => _buildPeriodStats(period)).toList(),
      ),
    );
  }

  Widget _buildPeriodStats(StatsPeriod period) {
    final filteredSales =
        _filterSalesByPeriod(widget.dashboardData.sales, period);
    final completionRate = _calculateCompletionRate(filteredSales);
    final totalRevenue = _calculateTotalRevenue(filteredSales);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(
              totalRevenue, completionRate, filteredSales.length),
          SizedBox(height: 24),
          _buildSalesTable(filteredSales),
        ],
      ),
    );
  }

  List<Sale> _filterSalesByPeriod(List<Sale> sales, StatsPeriod period) {
    final now = DateTime.now();
    DateTime cutoff;

    switch (period) {
      case StatsPeriod.daily:
        cutoff = DateTime(now.year, now.month, now.day);
        break;
      case StatsPeriod.weekly:
        cutoff = now.subtract(Duration(days: 7));
        break;
      case StatsPeriod.monthly:
        cutoff = DateTime(now.year, now.month, 1);
        break;
    }

    return sales.where((sale) => sale.startDate!.isAfter(cutoff)).toList();
  }

  // Rest of your code remains the same...
  Widget _buildSummaryCards(double revenue, double completion, int totalSales) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: AppLocalizations.of(context).totalSold,
          value: '\$${revenue.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        StatCard(
          title: AppLocalizations.of(context).completionRate,
          value: '${completion.toStringAsFixed(1)}%',
          icon: Icons.check_circle,
          color: Colors.blue,
        ),
        StatCard(
          title: AppLocalizations.of(context).totalSales,
          value: totalSales.toString(),
          icon: Icons.shopping_cart,
          color: Colors.orange,
        ),
      ],
    );
  }

  double _calculateCompletionRate(List<Sale> sales) {
    if (sales.isEmpty) return 0.0;
    final completed =
        sales.where((s) => s.status == SaleStatusEnum.DELIVERED).length;
    return (completed / sales.length) * 100;
  }

  double _calculateTotalRevenue(List<Sale> sales) {
    return sales.fold(0.0, (sum, sale) {
      return sum +
          sale.products!.fold(
              0.0,
              (sum, product) =>
                  sum + (product.quantity! * product.product!.price!));
    });
  }

  Widget _buildSalesTable(List<Sale> sales) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(AppLocalizations.of(context).customer)),
            DataColumn(label: Text(AppLocalizations.of(context).date)),
            DataColumn(label: Text(AppLocalizations.of(context).total)),
            DataColumn(label: Text(AppLocalizations.of(context).status)),
          ],
          rows: sales.map((sale) {
            final total = sale.products!.fold<double>(
                0,
                (sum, product) =>
                    sum + product.quantity! * product.product!.price!);
            return DataRow(cells: [
              DataCell(Text(sale.customer!.name!)),
              DataCell(Text(sale.startDate!.toString())),
              DataCell(Text('\$${total.toStringAsFixed(2)}')),
              DataCell(_buildSaleStatusChip(sale.status!)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSaleStatusChip(SaleStatusEnum status) {
    final color = SalesUtils.getStatusColor(status);

    return Chip(
      label: Text(
        SalesUtils.getStatusName(context, status),
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
