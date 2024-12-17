import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/dashboard_responses.dart';
import 'package:gvm_flutter/src/widgets/home/stat_card.dart';

enum StatsPeriod {
  daily,
  weekly,
  monthly,
}

class ProductStatsView extends StatefulWidget {
  final DashboardResponse dashboardData;

  const ProductStatsView({
    super.key,
    required this.dashboardData,
  });

  @override
  _ProductStatsViewState createState() => _ProductStatsViewState();
}

class _ProductStatsViewState extends State<ProductStatsView>
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
        title: Text(AppLocalizations.of(context).productStats),
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
    final productStats = _calculateProductStats(filteredSales);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(productStats),
          SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).topSellingProducts,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          _buildProductsList(productStats),
          SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).lowStock,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          _buildLowStockProducts(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<ProductStats> stats) {
    final totalRevenue =
        stats.fold<double>(0, (sum, stat) => sum + (stat.totalRevenue ?? 0));
    final totalQuantity =
        stats.fold<int>(0, (sum, stat) => sum + (stat.totalQuantitySold ?? 0));
    final averagePrice = totalRevenue / (totalQuantity > 0 ? totalQuantity : 1);

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
          value: '\$${totalRevenue.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        StatCard(
          title: AppLocalizations.of(context).totalQuantity,
          value: totalQuantity.toString(),
          icon: Icons.inventory,
          color: Colors.blue,
        ),
        StatCard(
          title: AppLocalizations.of(context).averagePrice,
          value: '\$${averagePrice.toStringAsFixed(2)}',
          icon: Icons.price_check,
          color: Colors.orange,
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

  List<ProductStats> _calculateProductStats(List<Sale> sales) {
    final productSalesMap = <String, ProductStats>{};

    for (final sale in sales) {
      for (final productSale in sale.products!) {
        final productId = productSale.product!.id!;
        final existingStats = productSalesMap[productId.toString()];

        if (existingStats != null) {
          productSalesMap[productId.toString()] = ProductStats(
            product: productSale.product!,
            totalQuantitySold:
                (existingStats.totalQuantitySold ?? 0) + productSale.quantity!,
            totalRevenue: (existingStats.totalRevenue ?? 0) +
                (productSale.quantity! * productSale.product!.price!),
          );
        } else {
          productSalesMap[productId.toString()] = ProductStats(
            product: productSale.product!,
            totalQuantitySold: productSale.quantity!,
            totalRevenue: productSale.quantity! * productSale.product!.price!,
          );
        }
      }
    }

    return productSalesMap.values.toList()
      ..sort((a, b) => (b.totalRevenue ?? 0).compareTo(a.totalRevenue ?? 0));
  }

  Widget _buildProductsList(List<ProductStats> stats) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text('${index + 1}'),
            ),
            title: Text(stat.product?.name ?? ''),
            subtitle: Text(
                '${AppLocalizations.of(context).quantity}: ${stat.totalQuantitySold}'),
            trailing: Text(
              '\$${(stat.totalRevenue ?? 0).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLowStockProducts() {
    final lowStockProducts =
        widget.dashboardData.products.where((p) => p.quantity! <= 10).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: lowStockProducts.length,
      itemBuilder: (context, index) {
        final product = lowStockProducts[index];
        return Card(
          child: ListTile(
            leading: Icon(
              Icons.warning,
              color: Colors.orange,
            ),
            title: Text(product.name ?? ''),
            subtitle: Text(
                '${AppLocalizations.of(context).currentStock}: ${product.quantity}'),
            trailing: Text(
              '\$${product.price!.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
