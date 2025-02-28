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
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<PaymentMethodType>(
                                  title: const Text('Credit Card'),
                                  value: PaymentMethodType.creditCard,
                                  groupValue: selectedType,
                                  onChanged: (PaymentMethodType? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedType = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<PaymentMethodType>(
                                  title: const Text('Debit Card'),
                                  value: PaymentMethodType.debitCard,
                                  groupValue: selectedType,
                                  onChanged: (PaymentMethodType? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedType = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
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
