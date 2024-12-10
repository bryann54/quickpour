
import 'package:chupachap/features/farmer/data/models/farmer_model.dart';

abstract class FarmerState {}

class FarmerInitial extends FarmerState {}

class FarmerLoading extends FarmerState {}

class FarmerLoaded extends FarmerState {
  final List<Farmer> farmers;

  FarmerLoaded(this.farmers);
}

class FarmerError extends FarmerState {
  final String message;

  FarmerError(this.message);
}
