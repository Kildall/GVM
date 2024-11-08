import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/widgets/common/statistic_card.dart';
import 'package:gvm_flutter/src/widgets/common/statistic_card_skeleton.dart';

class ProductsHomeStats extends StatefulWidget {
  const ProductsHomeStats({super.key});

  @override
  State<ProductsHomeStats> createState() => _ProductsHomeStatsState();
}

class _ProductsHomeStatsState extends State<ProductsHomeStats> {
  bool isLoading = true;
  int productCount = 0;
  int lowStockCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final productsResponse = await AuthManager.instance.apiService
          .get<GetProductsResponse>('/api/products',
              fromJson: GetProductsResponse.fromJson);

      final products = productsResponse.data?.products ?? [];
      final lowStock = products.where((p) => (p.quantity ?? 0) < 10).length;

      setState(() {
        isLoading = false;
        productCount = products.length;
        lowStockCount = lowStock;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildStatCards() {
    if (isLoading) {
      return Row(
        children: [
          Expanded(child: const StatisticCardSkeleton()),
          const SizedBox(width: 16),
          Expanded(child: const StatisticCardSkeleton()),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: StatisticCard(
            icon: Icons.inventory_2,
            title: AppLocalizations.of(context).products,
            value: productCount.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatisticCard(
            icon: Icons.warning,
            title: AppLocalizations.of(context).lowStock,
            value: lowStockCount.toString(),
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).statistics,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _buildStatCards(),
      ],
    );
  }
}
