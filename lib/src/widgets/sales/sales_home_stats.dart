import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/sale_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/widgets/common/statistic_card.dart';
import 'package:gvm_flutter/src/widgets/common/statistic_card_skeleton.dart';

class SalesHomeStats extends StatefulWidget {
  const SalesHomeStats({super.key});

  @override
  State<SalesHomeStats> createState() => _SalesHomeStatsState();
}

class _SalesHomeStatsState extends State<SalesHomeStats> {
  bool isLoading = true;
  int saleCount = 0;
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final salesResponse = await AuthManager.instance.apiService
          .get<GetSalesResponse>('/api/sales',
              fromJson: GetSalesResponse.fromJson);

      final sales = salesResponse.data?.sales ?? [];
      final pending =
          sales.where((s) => s.status == SaleStatusEnum.IN_PROGRESS).length;

      setState(() {
        isLoading = false;
        saleCount = sales.length;
        pendingCount = pending;
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
            icon: Icons.shopping_cart,
            title: AppLocalizations.of(context).sales,
            value: saleCount.toString(),
            color: Colors.lightGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatisticCard(
            icon: Icons.pending_actions,
            title: AppLocalizations.of(context).pending,
            value: pendingCount.toString(),
            color: Colors.cyan,
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
