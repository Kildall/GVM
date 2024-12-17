import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/dashboard_responses.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:gvm_flutter/src/widgets/home/stat_card.dart';

enum StatsPeriod {
  daily,
  weekly,
  monthly,
}

class CustomerStatsView extends StatefulWidget {
  final DashboardResponse dashboardData;

  const CustomerStatsView({
    super.key,
    required this.dashboardData,
  });

  @override
  _CustomerStatsViewState createState() => _CustomerStatsViewState();
}

class _CustomerStatsViewState extends State<CustomerStatsView>
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
        title: Text(AppLocalizations.of(context).customerStats),
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
    final customerStats = _calculateCustomerStats(filteredSales);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(customerStats),
          SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).topCustomers,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          _buildCustomersList(customerStats),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<CustomerStats> stats) {
    final totalSpent =
        stats.fold<double>(0, (sum, stat) => sum + (stat.totalSpent ?? 0));
    final totalOrders =
        stats.fold<int>(0, (sum, stat) => sum + (stat.totalOrders ?? 0));
    final averageOrderValue = totalSpent / (totalOrders > 0 ? totalOrders : 1);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: AppLocalizations.of(context).totalRevenue,
          value: '\$${totalSpent.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        StatCard(
          title: AppLocalizations.of(context).totalOrders,
          value: totalOrders.toString(),
          icon: Icons.shopping_bag,
          color: Colors.blue,
        ),
        StatCard(
          title: AppLocalizations.of(context).averagePrice,
          value: '\$${averageOrderValue.toStringAsFixed(2)}',
          icon: Icons.analytics,
          color: Colors.purple,
        ),
      ],
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

  List<CustomerStats> _calculateCustomerStats(List<Sale> sales) {
    final customerSalesMap = <String, CustomerStats>{};

    for (final sale in sales) {
      final customerId = sale.customer!.id!;
      final totalAmount = sale.products!.fold<double>(
          0,
          (sum, product) =>
              sum + (product.quantity! * product.product!.price!));

      final existingStats = customerSalesMap[customerId.toString()];
      if (existingStats != null) {
        customerSalesMap[customerId.toString()] = CustomerStats(
          customer: sale.customer!,
          totalOrders: (existingStats.totalOrders ?? 0) + 1,
          totalSpent: (existingStats.totalSpent ?? 0) + totalAmount,
        );
      } else {
        customerSalesMap[customerId.toString()] = CustomerStats(
          customer: sale.customer!,
          totalOrders: 1,
          totalSpent: totalAmount,
        );
      }
    }

    return customerSalesMap.values.toList()
      ..sort((a, b) => (b.totalSpent ?? 0).compareTo(a.totalSpent ?? 0));
  }

  Widget _buildCustomersList(List<CustomerStats> stats) {
    final averageSpent = stats.isEmpty
        ? 0.0
        : stats.fold<double>(0, (sum, stat) => sum + (stat.totalSpent ?? 0)) /
            stats.length;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            final isAboveAverage = (stat.totalSpent ?? 0) > averageSpent;

            return Card(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(stat.customer?.name ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${AppLocalizations.of(context).sales}: ${stat.totalOrders}'),
                        Text(
                          '${AppLocalizations.of(context).averagePrice}: \$${(stat.totalSpent ?? 0 / (stat.totalOrders ?? 1)).toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(stat.totalSpent ?? 0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Icon(
                          isAboveAverage
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: isAboveAverage ? Colors.green : Colors.red,
                          size: 16,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                  if (_shouldShowPurchaseHistory(stat))
                    _buildPurchaseHistory(stat.customer?.id?.toString() ?? ''),
                ],
              ),
            );
          },
        ),
        if (stats.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noCustomerFound,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _shouldShowPurchaseHistory(CustomerStats stat) {
    return widget.dashboardData.stats.mostActiveCustomers
            ?.take(3)
            .any((c) => c.customer?.id == stat.customer?.id) ??
        false;
  }

  Widget _buildPurchaseHistory(String customerId) {
    final customerSales = widget.dashboardData.sales
        .where((sale) => sale.customer!.id!.toString() == customerId)
        .toList()
      ..sort((a, b) => b.startDate!.compareTo(a.startDate!));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Text(
            AppLocalizations.of(context).purchaseHistory,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: customerSales.take(5).length,
            itemBuilder: (context, index) {
              final sale = customerSales[index];
              final total = sale.products!.fold<double>(
                0,
                (sum, product) =>
                    sum + (product.quantity! * product.product!.price!),
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(sale.startDate!),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildSaleStatusChip(sale.status!),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildSaleStatusChip(SaleStatusEnum status) {
    final color = SalesUtils.getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        SalesUtils.getStatusName(context, status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
