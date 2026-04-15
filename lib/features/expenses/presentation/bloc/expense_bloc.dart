import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_room_expenses.dart';
import '../../domain/usecases/create_expense.dart';

// ══════════════════════════════════════════
//  EVENTS
// ══════════════════════════════════════════

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

class LoadExpensesEvent extends ExpenseEvent {
  final String roomId;
  const LoadExpensesEvent(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class RefreshExpensesEvent extends ExpenseEvent {
  final String roomId;
  const RefreshExpensesEvent(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class CreateExpenseEvent extends ExpenseEvent {
  final String roomId;
  final String title;
  final double amount;
  final String? note;
  final List<String> participantUserIds;

  const CreateExpenseEvent({
    required this.roomId,
    required this.title,
    required this.amount,
    this.note,
    required this.participantUserIds,
  });

  @override
  List<Object?> get props => [roomId, title, amount, note, participantUserIds];
}

// ══════════════════════════════════════════
//  STATES
// ══════════════════════════════════════════

abstract class ExpenseState extends Equatable {
  const ExpenseState();
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

class ExpenseLoaded extends ExpenseState {
  final List<Map<String, dynamic>> expenses;
  const ExpenseLoaded(this.expenses);
  @override
  List<Object?> get props => [expenses];
}

class ExpenseCreated extends ExpenseState {
  const ExpenseCreated();
}

class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError(this.message);
  @override
  List<Object?> get props => [message];
}

// ══════════════════════════════════════════
//  BLOC
// ══════════════════════════════════════════

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetRoomExpenses getRoomExpenses;
  final CreateExpense createExpense;

  ExpenseBloc({
    required this.getRoomExpenses,
    required this.createExpense,
  }) : super(const ExpenseInitial()) {
    on<LoadExpensesEvent>(_onLoad);
    on<RefreshExpensesEvent>(_onRefresh);
    on<CreateExpenseEvent>(_onCreate);
  }

  Future<void> _onLoad(LoadExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseLoading());
    final result = await getRoomExpenses(event.roomId);
    if (result.success) {
      emit(ExpenseLoaded(result.expenses));
    } else {
      emit(ExpenseError(result.error ?? 'Failed to load expenses'));
    }
  }

  Future<void> _onRefresh(RefreshExpensesEvent event, Emitter<ExpenseState> emit) async {
    final result = await getRoomExpenses(event.roomId);
    if (result.success) {
      emit(ExpenseLoaded(result.expenses));
    }
  }

  Future<void> _onCreate(CreateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseLoading());
    final result = await createExpense(
      roomId: event.roomId,
      title: event.title,
      amount: event.amount,
      note: event.note,
      participantUserIds: event.participantUserIds,
    );
    if (result.success) {
      emit(const ExpenseCreated());
      final expenses = await getRoomExpenses(event.roomId);
      if (expenses.success) {
        emit(ExpenseLoaded(expenses.expenses));
      }
    } else {
      emit(ExpenseError(result.error ?? 'Failed to create expense'));
    }
  }
}
