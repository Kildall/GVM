import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/models/response/dashboard/dashboard.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<Dashboard> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _fetchDashboardData();
  }

  Future<Dashboard> _fetchDashboardData() async {
    try {
      final apiService = AuthManager.instance.apiService;
      final response = await apiService.get('/api/dashboard');

      if (response['status']['success']) {
        return Dashboard.fromJson(response['data']);
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
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
        title: Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: FutureBuilder<Dashboard>(
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

  Widget _buildDashboardContent(BuildContext context, Dashboard dashboard) {
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

  Widget _buildSummaryCards(BuildContext context, Dashboard dashboard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.labelSmall),
            SizedBox(height: 4),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestSales(Dashboard dashboard) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dashboard.recentSales.length,
      itemBuilder: (context, index) {
        final sale = dashboard.recentSales[index];
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
                      sale.customerName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(sale.statusDisplay),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Date: ${sale.formattedDate}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  'Total: \$${sale.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text('Products:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Column(
                  children: sale.products.map((product) {
                    return Text(
                        '${product.name} (${product.quantity}x) - \$${product.price.toStringAsFixed(2)}');
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOngoingDeliveries(Dashboard dashboard) {
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
                      delivery.customerName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(delivery.statusDisplay),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Start: ${delivery.formattedDate}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text('Address: ${delivery.address}'),
                SizedBox(height: 8),
                Text('Delivery Person: ${delivery.deliveryPerson}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'COMPLETED':
      case 'DELIVERED':
        color = Colors.green;
        break;
      case 'IN_PROGRESS':
        color = Colors.orange;
        break;
      case 'ASSIGNED':
      case 'PENDING_ASSIGNMENT':
        color = Colors.blue;
        break;
      case 'CANCELED':
      case 'DISPUTED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
