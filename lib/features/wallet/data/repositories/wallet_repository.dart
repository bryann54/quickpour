import 'dart:convert';
import 'package:chupachap/features/wallet/data/models/payment_method.dart';
import 'package:chupachap/features/wallet/data/models/transaction.dart';
import 'package:chupachap/features/wallet/data/models/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletRepository {
  static const String _walletKey = 'wallet_data';

  Future<Wallet> getWallet() async {
    final prefs = await SharedPreferences.getInstance();
    final walletJson = prefs.getString(_walletKey);

    if (walletJson != null) {
      return Wallet.fromJson(jsonDecode(walletJson));
    }

    return Wallet.initial();
  }

  Future<void> saveWallet(Wallet wallet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_walletKey, jsonEncode(wallet.toJson()));
  }

  Future<void> addPaymentMethod(PaymentMethod paymentMethod) async {
    final wallet = await getWallet();

    // If this is the first payment method or marked as default,
    // make sure it's set as default and others are not
    final List<PaymentMethod> updatedPaymentMethods = [];

    if (paymentMethod.isDefault || wallet.paymentMethods.isEmpty) {
      for (final pm in wallet.paymentMethods) {
        updatedPaymentMethods.add(pm.copyWith(isDefault: false));
      }
      updatedPaymentMethods.add(paymentMethod.copyWith(isDefault: true));
    } else {
      updatedPaymentMethods.addAll(wallet.paymentMethods);
      updatedPaymentMethods.add(paymentMethod);
    }

    final updatedWallet =
        wallet.copyWith(paymentMethods: updatedPaymentMethods);
    await saveWallet(updatedWallet);
  }

  Future<void> removePaymentMethod(String paymentMethodId) async {
    final wallet = await getWallet();

    final updatedPaymentMethods =
        wallet.paymentMethods.where((pm) => pm.id != paymentMethodId).toList();

    // If we removed the default payment method and there are others left,
    // make the first one the default
    if (updatedPaymentMethods.isNotEmpty &&
        !updatedPaymentMethods.any((pm) => pm.isDefault)) {
      updatedPaymentMethods[0] =
          updatedPaymentMethods[0].copyWith(isDefault: true);
    }

    final updatedWallet =
        wallet.copyWith(paymentMethods: updatedPaymentMethods);
    await saveWallet(updatedWallet);
  }

  Future<void> setDefaultPaymentMethod(String paymentMethodId) async {
    final wallet = await getWallet();

    final updatedPaymentMethods = wallet.paymentMethods.map((pm) {
      return pm.copyWith(isDefault: pm.id == paymentMethodId);
    }).toList();

    final updatedWallet =
        wallet.copyWith(paymentMethods: updatedPaymentMethods);
    await saveWallet(updatedWallet);
  }

  Future<void> addFunds(double amount, String paymentMethodId) async {
    final wallet = await getWallet();

    final transaction = Transaction.create(
      amount: amount,
      type: TransactionType.deposit,
      description: 'Added funds to wallet',
      paymentMethodId: paymentMethodId,
    );

    final updatedTransactions = List<Transaction>.from(wallet.transactions)
      ..add(transaction);

    final updatedWallet = wallet.copyWith(
      balance: wallet.balance + amount,
      transactions: updatedTransactions,
    );

    await saveWallet(updatedWallet);
  }

  Future<bool> makePayment(double amount, String description) async {
    final wallet = await getWallet();

    if (wallet.balance < amount) {
      return false; // Insufficient funds
    }

    final transaction = Transaction.create(
      amount: amount,
      type: TransactionType.payment,
      description: description,
    );

    final updatedTransactions = List<Transaction>.from(wallet.transactions)
      ..add(transaction);

    final updatedWallet = wallet.copyWith(
      balance: wallet.balance - amount,
      transactions: updatedTransactions,
    );

    await saveWallet(updatedWallet);
    return true;
  }

  // Create a new method in your WalletRepository class
  Future<bool> processOrderPayment({
    required double amount,
    required String description,
    required PaymentMethod paymentMethod,
    bool useWalletBalance = false,
  }) async {
    // Case 1: Using wallet balance
    if (useWalletBalance) {
      return await makePayment(amount, description);
    }

    // Case 2: Using payment card
    if (paymentMethod.type == PaymentMethodType.values) {
      try {
        // Process card payment logic here
        // This would typically involve an API call to a payment processor

        // For now, we'll simulate a successful card payment
        final transaction = Transaction.create(
          amount: amount,
          type: TransactionType.payment,
          description: description,
          paymentMethodId: paymentMethod.id,
        );

        // Record the transaction in the wallet
        final wallet = await getWallet();
        final updatedTransactions = List<Transaction>.from(wallet.transactions)
          ..add(transaction);

        final updatedWallet = wallet.copyWith(
          transactions: updatedTransactions,
        );

        await saveWallet(updatedWallet);
        return true;
      } catch (e) {
        return false;
      }
    }

    return false;
  }
}
