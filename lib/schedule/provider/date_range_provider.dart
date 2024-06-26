import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateRange {
  final DateTime? startDate;
  final DateTime? endDate;

  DateRange({
    this.startDate,
    this.endDate,
  });

  DateRange copyWith({DateTime? startDate, DateTime? endDate}) {
    return DateRange(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

final dateRangeProvider =
    StateNotifierProvider.autoDispose<DateRangeStateNotifier, DateRange>(
        (ref) => DateRangeStateNotifier());

class DateRangeStateNotifier extends StateNotifier<DateRange> {
  DateRangeStateNotifier() : super(DateRange());

  bool isValidate() {
    // log("state.startDate!.difference(state.endDate!) == const Duration() =${state.startDate!.difference(state.endDate!) == const Duration()}");
    if (state.startDate != null &&
        state.endDate != null &&
        (state.startDate!.isAfter(state.endDate!) ||
            state.startDate!.difference(state.endDate!) == const Duration())) {
      return false;
    }
    return true;
  }
  bool isSaveValidate(){
    if(state.startDate == null || state.endDate == null){
      return false;
    }
    return true;
  }

  bool integrationValid(){
    return isValidate() && isSaveValidate();
  }

  void updateDate({DateTime? startDate, DateTime? endDate}) {
    state = state.copyWith(
        startDate: startDate ?? state.startDate,
        endDate: endDate ?? state.endDate);
  }
}
