import 'package:flutter/material.dart';
import '../../../../../shared/widgets/quick_action_button.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuickActionButton(
            icon: Icons.add,
            label: 'Pengeluaran',
            onTap: () {},
          ),
          const SizedBox(width: 28),
          QuickActionButton(
            icon: Icons.arrow_upward,
            label: 'Pemasukan',
            onTap: () {},
          ),
          const SizedBox(width: 28),
          QuickActionButton(
            icon: Icons.qr_code_scanner,
            label: 'Transfer',
            onTap: () {},
          ),
          const SizedBox(width: 28),
          QuickActionButton(
            icon: Icons.credit_card,
            label: 'Akun',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
