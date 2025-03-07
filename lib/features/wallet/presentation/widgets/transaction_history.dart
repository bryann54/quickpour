import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/wallet/data/models/transaction.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionHistory({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        List<Transaction> currentTransactions = transactions;
        if (state is WalletLoaded) {
          currentTransactions = state.wallet.transactions;
        }

        if (currentTransactions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        // Sort transactions by date, newest first
        final sortedTransactions = List<Transaction>.from(currentTransactions)
          ..sort((a, b) => b.date.compareTo(a.date));

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedTransactions.length,
          itemBuilder: (context, index) {
            final transaction = sortedTransactions[index];
            final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

            IconData iconData;
            Color iconColor;

            switch (transaction.type) {
              case TransactionType.deposit:
                iconData = Icons.arrow_downward;
                iconColor = Colors.green;
                break;
              case TransactionType.withdrawal:
                iconData = Icons.arrow_upward;
                iconColor = Colors.orange;
                break;
              case TransactionType.payment:
                iconData = Icons.shopping_bag;
                iconColor = Colors.red;
                break;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        iconData,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(transaction.date),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      transaction.type == TransactionType.deposit
                          ? '+Ksh ${formatMoney(transaction.amount)}'
                          : '- Ksh ${formatMoney(transaction.amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction.type == TransactionType.deposit
                            ? Colors.green
                            : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
