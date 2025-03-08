import 'package:bloc/bloc.dart';
import 'package:chupachap/features/wallet/data/repositories/wallet_repository.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_event.dart'
    as events;
import 'package:chupachap/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:chupachap/features/wallet/presentation/bloc/wallet_state.dart'
    as states;
import 'package:chupachap/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<events.WalletEvent, states.WalletState> {
  final WalletRepository _walletRepository;

  WalletBloc({required WalletRepository walletRepository})
      : _walletRepository = walletRepository,
        super(states.WalletInitial()) {
    on<events.WalletLoaded>(_onWalletLoaded);
    on<events.AddPaymentMethodEvent>(_onAddPaymentMethod);
    on<events.RemovePaymentMethodEvent>(_onRemovePaymentMethod);
    on<events.SetDefaultPaymentMethodEvent>(_onSetDefaultPaymentMethod);
    on<events.AddFundsEvent>(_onAddFunds);
    on<events.MakePaymentEvent>(_onMakePayment);
    on<ProcessOrderPaymentEvent>(_onProcessOrderPayment);
  }

  Future<void> _onWalletLoaded(
    events.WalletLoaded event,
    Emitter<states.WalletState> emit,
  ) async {
    emit(states.WalletLoading());
    try {
      final wallet = await _walletRepository.getWallet();
      emit(states.WalletLoaded(wallet));
    } catch (e) {
      emit(states.WalletError('Failed to load wallet: ${e.toString()}'));
    }
  }

  Future<void> _onProcessOrderPayment(
    ProcessOrderPaymentEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    try {
      final success = await _walletRepository.processOrderPayment(
        amount: event.amount,
        description: event.description,
        paymentMethod: event.paymentMethod,
        useWalletBalance: event.useWalletBalance,
      );

      if (success) {
        final wallet = await _walletRepository.getWallet();
        emit(states.OrderPaymentSuccess(
            wallet, event.amount, event.paymentMethod));
      } else {
        emit(const states.OrderPaymentFailure('Payment processing failed'));
      }
    } catch (e) {
      emit(WalletError('Order payment failed: ${e.toString()}'));
    }
  }

  Future<void> _onAddPaymentMethod(
    events.AddPaymentMethodEvent event,
    Emitter<states.WalletState> emit,
  ) async {
    emit(states.WalletLoading());
    try {
      await _walletRepository.addPaymentMethod(event.paymentMethod);
      final wallet = await _walletRepository.getWallet();
      emit(states.PaymentMethodAdded(wallet));
    } catch (e) {
      emit(states.WalletError('Failed to add payment method: ${e.toString()}'));
    }
  }

  Future<void> _onRemovePaymentMethod(
    events.RemovePaymentMethodEvent event,
    Emitter<states.WalletState> emit,
  ) async {
    emit(states.WalletLoading());
    try {
      await _walletRepository.removePaymentMethod(event.paymentMethodId);
      final wallet = await _walletRepository.getWallet();
      emit(states.PaymentMethodRemoved(wallet));
    } catch (e) {
      emit(states.WalletError(
          'Failed to remove payment method: ${e.toString()}'));
    }
  }

  Future<void> _onSetDefaultPaymentMethod(
    events.SetDefaultPaymentMethodEvent event,
    Emitter<states.WalletState> emit,
  ) async {
    emit(states.WalletLoading());
    try {
      await _walletRepository.setDefaultPaymentMethod(event.paymentMethodId);
      final wallet = await _walletRepository.getWallet();
      emit(states.DefaultPaymentMethodSet(wallet));
    } catch (e) {
      emit(states.WalletError(
          'Failed to set default payment method: ${e.toString()}'));
    }
  }

  Future<void> _onAddFunds(
    events.AddFundsEvent event,
    Emitter<states.WalletState> emit,
  ) async {
    emit(states.WalletLoading());
    try {
      await _walletRepository.addFunds(event.amount, event.paymentMethodId);
      final wallet = await _walletRepository.getWallet();
      emit(states.FundsAdded(wallet, event.amount));
    } catch (e) {
      emit(states.WalletError('Failed to add funds: ${e.toString()}'));
    }
  }

  Future<void> _onMakePayment(
    events.MakePaymentEvent event,
    Emitter<states.WalletState> emit,
  ) async {
    emit(states.WalletLoading());
    try {
      final success = await _walletRepository.makePayment(
        event.amount,
        event.description,
      );
      if (success) {
        final wallet = await _walletRepository.getWallet();
        emit(states.PaymentSuccess(wallet, event.amount));
      } else {
        emit(const states.PaymentFailure('Insufficient funds'));
      }
    } catch (e) {
      emit(states.WalletError('Payment failed: ${e.toString()}'));
    }
  }
}
