import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/wallet/data/models/payment_method.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isDefaultCard = false;
  PaymentMethodType selectedType = PaymentMethodType.creditCard;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Method'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: AppColors.brandPrimary,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      onCreditCardModelChange: onCreditCardModelChange,
                      obscureCvv: true,
                      obscureNumber: true,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardNumberValidator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        return null;
                      },
                      expiryDateValidator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        return null;
                      },
                      cvvValidator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        return null;
                      },
                      cardHolderValidator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card holder name';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Card Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedType =
                                            PaymentMethodType.creditCard;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: selectedType ==
                                                PaymentMethodType.creditCard
                                            ? AppColors.brandPrimary
                                                .withValues(alpha: 0.1)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedType ==
                                                  PaymentMethodType.creditCard
                                              ? AppColors.brandPrimary
                                              : Colors.grey.shade300,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selectedType ==
                                                        PaymentMethodType
                                                            .creditCard
                                                    ? AppColors.brandPrimary
                                                    : Colors.grey.shade400,
                                                width: 2,
                                              ),
                                            ),
                                            child: selectedType ==
                                                    PaymentMethodType.creditCard
                                                ? Center(
                                                    child: Container(
                                                      width: 12,
                                                      height: 12,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .brandPrimary,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Credit Card',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: selectedType ==
                                                      PaymentMethodType
                                                          .creditCard
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: selectedType ==
                                                      PaymentMethodType
                                                          .creditCard
                                                  ? AppColors.brandPrimary
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedType =
                                            PaymentMethodType.debitCard;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: selectedType ==
                                                PaymentMethodType.debitCard
                                            ? AppColors.brandPrimary
                                                .withValues(alpha: 0.1)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedType ==
                                                  PaymentMethodType.debitCard
                                              ? AppColors.brandPrimary
                                              : Colors.grey.shade300,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: selectedType ==
                                                        PaymentMethodType
                                                            .debitCard
                                                    ? AppColors.brandPrimary
                                                    : Colors.grey.shade400,
                                                width: 2,
                                              ),
                                            ),
                                            child: selectedType ==
                                                    PaymentMethodType.debitCard
                                                ? Center(
                                                    child: Container(
                                                      width: 12,
                                                      height: 12,
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .brandPrimary,
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Debit Card',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: selectedType ==
                                                      PaymentMethodType
                                                          .debitCard
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                              color: selectedType ==
                                                      PaymentMethodType
                                                          .debitCard
                                                  ? AppColors.brandPrimary
                                                  : Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CheckboxListTile(
                            title: const Text('Set as default payment method'),
                            value: isDefaultCard,
                            onChanged: (bool? value) {
                              if (value != null) {
                                setState(() {
                                  isDefaultCard = value;
                                });
                              }
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  _addPaymentMethod();
                                }
                              },
                              child: const Text(
                                'Add Payment Method',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void _addPaymentMethod() {
    final paymentMethod = PaymentMethod.create(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      type: selectedType,
      isDefault: isDefaultCard,
    );

    context.read<WalletBloc>().add(AddPaymentMethodEvent(paymentMethod));
    Navigator.pop(context);
  }
}
