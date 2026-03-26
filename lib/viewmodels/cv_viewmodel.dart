import 'package:flutter_riverpod/flutter_riverpod.dart';

final cvProvider = StateNotifierProvider<CvNotifier, CvState>((ref) {
  return CvNotifier();
});

class CvState {
  final Set<int> expandedEntries;

  const CvState({this.expandedEntries = const {}});

  CvState copyWith({Set<int>? expandedEntries}) {
    return CvState(expandedEntries: expandedEntries ?? this.expandedEntries);
  }
}

class CvNotifier extends StateNotifier<CvState> {
  CvNotifier() : super(const CvState());

  void toggleEntry(int index) {
    final current = Set<int>.from(state.expandedEntries);
    if (current.contains(index)) {
      current.remove(index);
    } else {
      current.add(index);
    }
    state = state.copyWith(expandedEntries: current);
  }
}
