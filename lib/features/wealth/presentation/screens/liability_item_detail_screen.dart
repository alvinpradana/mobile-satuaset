import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/success_alert_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/wealth_provider.dart';
import '../widgets/pay_liability_bottom_sheet.dart';
import '../widgets/add_liability_bottom_sheet.dart';

class LiabilityItemDetailScreen extends ConsumerStatefulWidget {
  final String liabilityId;

  const LiabilityItemDetailScreen({
    super.key,
    required this.liabilityId,
  });

  @override
  ConsumerState<LiabilityItemDetailScreen> createState() => _LiabilityItemDetailScreenState();
}

class _LiabilityItemDetailScreenState extends ConsumerState<LiabilityItemDetailScreen> {
  // Mock data for recent payments
  late List<Map<String, dynamic>> recentPayments;

  @override
  void initState() {
    super.initState();
    recentPayments = List.generate(3, (index) {
      return {
        'id': 'payment_$index',
        'date': DateTime.now().subtract(Duration(days: (index + 1) * 30)),
        'amount': 0.0, // Will be populated with monthlyPayment in build
        'type': 'Instalment Payment',
        'accountId': null, // Source account ID if available
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final liabilities = ref.watch(wealthItemsProvider('liabilities'));
    final liability = liabilities.firstWhere((l) => l.id == widget.liabilityId, orElse: () => liabilities.first);

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Mock data for liability details (Ideally this should come from the model)
    final double outstandingBalance = liability.value.abs();
    final double principalAmount = outstandingBalance * 1.35; // Mock principal
    final double paidAmount = principalAmount - outstandingBalance;
    final double progressPercentage = (paidAmount / principalAmount).clamp(0.0, 1.0);
    
    final double monthlyPayment = outstandingBalance * 0.05; // Mock 5% of outstanding
    const double interestRate = 8.5; // Mock 8.5% p.a.
    const int remainingTenure = 48; // Mock 48 months
    final DateTime nextPaymentDate = DateTime.now().add(const Duration(days: 12));
    final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(UIcons.regularRounded.angle_left, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ),
        title: Text(
          liability.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddLiabilityBottomSheet(liabilityToEdit: liability),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Icon(UIcons.regularRounded.pencil, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero
            Column(
              children: [
                const Text(
                  'OUTSTANDING BALANCE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currencyFormatter.format(outstandingBalance),
                  style: const TextStyle(
                    color: AppColors.negative,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                  ),
                ),
                if (liability.institution != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      liability.institution!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 36),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Payment Progress',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(progressPercentage * 100).toStringAsFixed(0)}% Paid Off',
                      style: const TextStyle(
                        color: AppColors.primaryAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progressPercentage,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Paid Amount',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(paidAmount),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Principal',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(principalAmount),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Key Metrics
            const Text(
              'LIABILITY DETAILS',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Monthly Payment', currencyFormatter.format(monthlyPayment)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: AppColors.border, height: 1),
                  ),
                  _buildDetailRow('Interest Rate', '$interestRate% p.a.'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: AppColors.border, height: 1),
                  ),
                  _buildDetailRow('Remaining Term', '$remainingTenure months'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reminder Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.negative.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.negative.withOpacity(0.3), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.negative.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(UIcons.regularRounded.calendar_clock, color: AppColors.negative, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next Payment Due',
                          style: TextStyle(
                            color: AppColors.negative,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormatter.format(nextPaymentDate),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Recent Activity
            const Text(
              'RECENT PAYMENTS',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            ...recentPayments.map((payment) {
              final date = payment['date'] as DateTime;
              final amount = (payment['amount'] as double) > 0 ? payment['amount'] as double : monthlyPayment;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Slidable(
                  key: ValueKey(payment['id']),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      CustomSlidableAction(
                        onPressed: (context) {
                          // Show edit form
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => PayLiabilityBottomSheet(
                              liability: liability,
                              paymentToEdit: {
                                ...payment,
                                'amount': amount,
                              },
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primaryAccent.withOpacity(0.3), width: 1),
                          ),
                          child: Icon(UIcons.regularRounded.pencil, color: AppColors.primaryAccent, size: 18),
                        ),
                      ),
                      CustomSlidableAction(
                        onPressed: (context) {
                          // Show delete confirmation
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.surface,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Delete Payment', style: TextStyle(color: AppColors.textPrimary)),
                              content: const Text('Are you sure you want to delete this payment record?', style: TextStyle(color: AppColors.textSecondary)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close confirm
                                    setState(() {
                                      recentPayments.removeWhere((p) => p['id'] == payment['id']);
                                    });
                                    SuccessAlertDialog.show(
                                      context,
                                      title: 'Payment Deleted',
                                      message: 'Payment record has been deleted.',
                                    );
                                  },
                                  child: const Text('Delete', style: TextStyle(color: AppColors.negative, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.negative.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.negative.withOpacity(0.3), width: 1),
                          ),
                          child: Icon(UIcons.regularRounded.trash, color: AppColors.negative, size: 18),
                        ),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _showPaymentDetail(context, payment, amount, dateFormatter, currencyFormatter);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.positive, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payment['type'],
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dateFormatter.format(date),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            currencyFormatter.format(amount),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => PayLiabilityBottomSheet(liability: liability),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Record Payment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showPaymentDetail(BuildContext context, Map<String, dynamic> payment, double amount, DateFormat dateFormatter, NumberFormat currencyFormatter) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment Detail',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(UIcons.regularRounded.cross_small, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Type', payment['type']),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: AppColors.border, height: 1),
                    ),
                    _buildDetailRow('Amount', currencyFormatter.format(amount)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: AppColors.border, height: 1),
                    ),
                    _buildDetailRow('Date', dateFormatter.format(payment['date'] as DateTime)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: AppColors.border, height: 1),
                    ),
                    _buildDetailRow('Status', 'Completed'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
