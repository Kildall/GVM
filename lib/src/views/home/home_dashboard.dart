import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/dashboard_responses.dart';
import 'package:gvm_flutter/src/services/api/api_errors.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/home/stats/customer_stats_view.dart';
import 'package:gvm_flutter/src/views/home/stats/product_stats_view.dart';
import 'package:gvm_flutter/src/views/home/stats/sale_stats_view.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/utils.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late Future<DashboardResponse?> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _fetchDashboardData();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<DashboardResponse?> _fetchDashboardData() async {
    try {
      final apiService = AuthManager.instance.apiService;
      final response = await apiService.get<DashboardResponse>(
        '/api/dashboard',
        fromJson: DashboardResponse.fromJson,
      );

      return response.data;
    } on AuthException catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).noAccess);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching dashboard data: ${e.toString()}');
      if (mounted) {
        _showMessage(AppLocalizations.of(context).anErrorOccurred);
      }
      rethrow;
    }
  }

  Future<void> _refreshDashboard() async {
    try {
      setState(() {
        _dashboardFuture = _fetchDashboardData();
      });
    } catch (e) {
      if (mounted) {
        _showMessage('Error refreshing: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).homeDashboardTitle),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: FutureBuilder<DashboardResponse?>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildErrorView(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return _buildDashboardContent(context, snapshot.data!);
            } else {
              return Center(child: Text(AppLocalizations.of(context).noData));
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(AppLocalizations.of(context).refresh),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, DashboardResponse dashboard) {
    // Calculate completion rate from available data
    final completionRate = _calculateCompletionRate(dashboard.sales);

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNavigationButtons(context, dashboard),
              SizedBox(height: 24),
              _buildSummaryCards(context, dashboard, completionRate),
              SizedBox(height: 24),
              if (dashboard.stats.topSellingProducts?.isNotEmpty ?? false) ...[
                Text(
                  AppLocalizations.of(context).topProducts,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                _buildTopProducts(dashboard.stats.topSellingProducts ?? []),
              ],
              if (dashboard.stats.mostActiveCustomers?.isNotEmpty ?? false) ...[
                SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context).topCustomers,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                _buildTopCustomers(dashboard.stats.mostActiveCustomers ?? []),
              ],
              if (dashboard.sales.isNotEmpty) ...[
                SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context).latestSales,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                _buildLatestSales(dashboard),
              ],
              if (dashboard.deliveries.isNotEmpty) ...[
                SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context).ongoingDeliveries,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                _buildOngoingDeliveries(dashboard),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(
      BuildContext context, DashboardResponse dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            AppLocalizations.of(context).detailedStats,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 160, // Fixed height for all cards
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildStatsButton(
                title: AppLocalizations.of(context).salesAndDeliveries,
                icon: Icons.query_stats,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SalesStatsView(dashboardData: dashboard),
                  ),
                ),
              ),
              SizedBox(width: 16),
              _buildStatsButton(
                title: AppLocalizations.of(context).productStats,
                icon: Icons.inventory_2,
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductStatsView(dashboardData: dashboard),
                  ),
                ),
              ),
              SizedBox(width: 16),
              _buildStatsButton(
                title: AppLocalizations.of(context).customerStats,
                icon: Icons.people,
                color: Colors.purple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomerStatsView(dashboardData: dashboard),
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200, // Fixed width for all cards
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateCompletionRate(List<Sale> sales) {
    if (sales.isEmpty) return 0.0;

    final completedSales =
        sales.where((sale) => sale.status == SaleStatusEnum.DELIVERED).length;

    return (completedSales / sales.length) * 100;
  }

  Widget _buildSummaryCards(BuildContext context, DashboardResponse dashboard,
      double completionRate) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return Column(
          children: [
            GridView.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildSummaryCard(
                  context,
                  AppLocalizations.of(context).activeSales,
                  dashboard.stats.totalActiveSales.toString(),
                  Icons.shopping_cart,
                  Colors.blue,
                ),
                _buildSummaryCard(
                  context,
                  AppLocalizations.of(context).activeDeliveries,
                  dashboard.stats.totalActiveDeliveries.toString(),
                  Icons.local_shipping,
                  Colors.green,
                ),
                _buildSummaryCard(
                  context,
                  AppLocalizations.of(context).totalSales,
                  '\$${(dashboard.stats.totalSalesAmount ?? 0).toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.orange,
                ),
                _buildSummaryCard(
                  context,
                  AppLocalizations.of(context).completionRate,
                  '${completionRate.toStringAsFixed(1)}%',
                  Icons.check_circle,
                  _getCompletionRateColor(completionRate),
                ),
                _buildSummaryCard(
                  context,
                  AppLocalizations.of(context).totalProducts,
                  dashboard.stats.totalProducts.toString(),
                  Icons.inventory,
                  Colors.purple,
                ),
                _buildSummaryCard(
                  context,
                  AppLocalizations.of(context).lowStock,
                  dashboard.stats.lowStockProducts.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Color _getCompletionRateColor(double rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 75) return Colors.orange;
    return Colors.red;
  }

  Widget _buildTopProducts(List<ProductStats> products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: Text('#${index + 1}'),
            ),
            title: Text(product.product?.name ?? ''),
            subtitle: Text(
              '${AppLocalizations.of(context).totalSold}: ${product.totalQuantitySold}',
            ),
            trailing: Text(
              '\$${(product.totalRevenue ?? 0).toStringAsFixed(2)}',
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

  Widget _buildTopCustomers(List<CustomerStats> customers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Text('#${index + 1}'),
            ),
            title: Text(customer.customer?.name ?? ''),
            subtitle: Text(
              '${AppLocalizations.of(context).totalOrders}: ${customer.totalOrders}',
            ),
            trailing: Text(
              '\$${(customer.totalSpent ?? 0).toStringAsFixed(2)}',
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

  Widget _buildLatestSales(DashboardResponse dashboard) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dashboard.sales.length,
      itemBuilder: (context, index) {
        final sale = dashboard.sales[index];
        final totalAmount = sale.products!.fold<double>(
          0,
          (sum, product) => sum + product.product!.price! * product.quantity!,
        );

        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sale.customer!.name!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildSaleStatusChip(sale.status!),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context).date}: ${sale.startDate}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context).total}: \$${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text('${AppLocalizations.of(context).products}:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Column(
                  children: sale.products!.map((product) {
                    return Text(
                      '${product.product!.name} (${product.quantity}x) - \$${product.product!.price!.toStringAsFixed(2)}',
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOngoingDeliveries(DashboardResponse dashboard) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dashboard.deliveries.length,
      itemBuilder: (context, index) {
        final delivery = dashboard.deliveries[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      delivery.sale!.customer!.name!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildDeliveryStatusChip(delivery.status!),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context).date}: ${delivery.startDate!.toLocal().toString()}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  '${AppLocalizations.of(context).address}: ${delivery.address!.street1}, ${delivery.address!.city} ${delivery.address!.postalCode}, ${delivery.address!.state}',
                ),
                if (delivery.employee != null) ...[
                  SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context).employee}: ${delivery.employee!.name}',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            AutoSizeText(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: color),
              maxLines: 1,
              minFontSize: 12,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryStatusChip(DeliveryStatusEnum status) {
    final color = DeliveriesUtils.getStatusColor(status);
    return Chip(
      label: Text(status.name, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  Widget _buildSaleStatusChip(SaleStatusEnum status) {
    final color = SalesUtils.getStatusColor(status);

    return Chip(
      label: Text(
        status.name,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
