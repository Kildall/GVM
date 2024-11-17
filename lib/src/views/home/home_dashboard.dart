import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/dashboard_responses.dart';
import 'package:gvm_flutter/src/services/api/api_errors.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<DashboardResponse?> _fetchDashboardData() async {
    try {
      final apiService = AuthManager.instance.apiService;
      debugPrint('Fetching dashboard data...');
      final response = await apiService.get<DashboardResponse>('/api/dashboard',
          fromJson: DashboardResponse.fromJson);

      if (response.data != null) {
        return response.data!;
      }
    } on AuthException catch (_) {
      _showMessage('You do not have access to this resource');
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
    return null;
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _dashboardFuture = _fetchDashboardData();
    });
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
              return Center(child: Text('No data available'));
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
          child: Text('Error: $error\nPull down to refresh'),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, DashboardResponse dashboard) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        // Ensure the container takes up at least the full screen height
        // This allows pull-to-refresh to work even when content is short
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(context, dashboard),
              SizedBox(height: 24),
              Text(
                'Latest Sales',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              _buildLatestSales(dashboard),
              SizedBox(height: 32),
              Text(
                'Ongoing Deliveries',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              _buildOngoingDeliveries(dashboard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, DashboardResponse dashboard) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildSummaryCard(
              context,
              'Active Sales',
              dashboard.totalActiveSales.toString(),
              Icons.shopping_cart,
              Colors.blue,
            ),
            _buildSummaryCard(
              context,
              'Active Deliveries',
              dashboard.totalActiveDeliveries.toString(),
              Icons.local_shipping,
              Colors.green,
            ),
            _buildSummaryCard(
              context,
              'Total Sales',
              '\$${dashboard.totalSalesAmount.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.orange,
            ),
          ],
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

  Widget _buildLatestSales(DashboardResponse dashboard) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dashboard.recentSales.length,
      itemBuilder: (context, index) {
        final sale = dashboard.recentSales[index];
        final totalAmount = sale.products!.fold<double>(
            0,
            (sum, product) =>
                sum + product.product!.price! * product.quantity!);
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
                  'Date: ${sale.startDate}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text('Products:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Column(
                  children: sale.products!.map((product) {
                    return Text(
                        '${product.product!.name} (${product.quantity}x) - \$${product.product!.price!.toStringAsFixed(2)}');
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
      itemCount: dashboard.recentDeliveries.length,
      itemBuilder: (context, index) {
        final delivery = dashboard.recentDeliveries[index];
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
                  'Start: ${delivery.startDate}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text('Address: ${delivery.address}'),
                SizedBox(height: 8),
                // Conditional display of delivery person
                if (delivery.employee != null)
                  Text('Delivery Person: ${delivery.employee!.name}'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Separate into delivery and sale statuses
  Widget _buildDeliveryStatusChip(DeliveryStatusEnum status) {
    Color color;
    switch (status) {
      case DeliveryStatusEnum.CREATED:
        color = Colors.blue;
        break;
      case DeliveryStatusEnum.IN_PROGRESS:
      case DeliveryStatusEnum.IN_TRANSIT:
      case DeliveryStatusEnum.ASSIGNED:
        color = Colors.green;
        break;
      case DeliveryStatusEnum.CANCELLED:
      case DeliveryStatusEnum.CONFLICT:
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status.name, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  Widget _buildSaleStatusChip(SaleStatusEnum status) {
    Color color;
    switch (status) {
      case SaleStatusEnum.DELIVERED:
        color = Colors.green;
        break;
      case SaleStatusEnum.IN_PROGRESS:
        color = Colors.orange;
        break;
      case SaleStatusEnum.CANCELLED:
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status.name,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
