import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/wallet/data/models/wallet.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_event.dart'
    as events;
import 'package:chupachap/features/wallet/presentation/bloc/wallet_state.dart'
    as states;
import 'package:chupachap/features/wallet/presentation/pages/add_funds_screen.dart';
import 'package:chupachap/features/wallet/presentation/pages/add_payment_method_screen.dart';
import 'package:chupachap/features/wallet/presentation/widgets/payment_methods_list.dart';
import 'package:chupachap/features/wallet/presentation/widgets/transaction_history.dart';
import 'package:chupachap/features/wallet/presentation/widgets/wallet_balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, states.WalletState>(
      listener: (context, state) {
        if (state is states.WalletError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is states.FundsAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Added Ksh ${formatMoney(state.amount)} to your wallet'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is states.PaymentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Payment of Ksh ${formatMoney(state.amount)} successful'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is states.PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is states.WalletInitial) {
          context.read<WalletBloc>().add(const events.WalletLoaded());
          return const Center(child: CircularProgressIndicator());
        }

        if (state is states.WalletLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        Wallet? wallet;
        if (state is states.WalletLoaded) {
          wallet = state.wallet;
        } else if (state is states.PaymentMethodAdded) {
          wallet = state.wallet;
        } else if (state is states.PaymentMethodRemoved) {
          wallet = state.wallet;
        } else if (state is states.DefaultPaymentMethodSet) {
          wallet = state.wallet;
        } else if (state is states.FundsAdded) {
          wallet = state.wallet;
        } else if (state is states.PaymentSuccess) {
          wallet = state.wallet;
        }

        if (wallet == null) {
          return const Center(child: Text('Something went wrong'));
        }

        return Scaffold(
          appBar: AppBar(
            title: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFE74C3C),
                  Color(0xFFF39C12),
                ],
              ).createShader(bounds),
              child: Text(
                'Your wallet',
                style: GoogleFonts.acme(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            elevation: 0,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<WalletBloc>().add(const events.WalletLoaded());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletBalanceCard(balance: wallet.balance),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Methods',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add New',),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddPaymentMethodScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    PaymentMethodsList(
                      paymentMethods: wallet.paymentMethods,
                      onSetDefault: (id) {
                        context.read<WalletBloc>().add(
                              events.SetDefaultPaymentMethodEvent(id),
                            );
                      },
                      onRemove: (id) {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Remove Payment Method'),
                            content: const Text(
                                'Are you sure you want to remove this payment method?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  context.read<WalletBloc>().add(
                                        events.RemovePaymentMethodEvent(id),
                                      );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Remove'),
                              ),
                            ],
                          ),
                        );
                      },
                      onAddFunds: (id) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddFundsScreen(paymentMethodId: id),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TransactionHistory(transactions: wallet.transactions),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
