import 'package:flutter/material.dart';
import '../../../../../shared/widgets/quick_action_button.dart';
import 'package:uicons/uicons.dart';

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
            icon: UIcons.solidRounded.plus,
            label: 'Pengeluaran',
            onTap: () {},
          ),
          const SizedBox(width: 28),
          QuickActionButton(
            icon: UIcons.solidRounded.arrow_up,
            label: 'Pemasukan',
            onTap: () {},
          ),
          const SizedBox(width: 28),
          QuickActionButton(
            icon: UIcons.solidRounded.expand,
            label: 'Transfer',
            onTap: () {},
          ),
          const SizedBox(width: 28),
          QuickActionButton(
            icon: UIcons.solidRounded.credit_card,
            label: 'Akun',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
