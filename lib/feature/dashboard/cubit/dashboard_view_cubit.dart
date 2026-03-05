import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardViewState extends Equatable {
  final DateTime selectedDate;

  const DashboardViewState({required this.selectedDate});

  @override
  List<Object?> get props => [selectedDate];

  DashboardViewState copyWith({DateTime? selectedDate}) {
    return DashboardViewState(
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class DashboardViewCubit extends Cubit<DashboardViewState> {
  DashboardViewCubit() : super(DashboardViewState(selectedDate: DateTime.now()));

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }
}
