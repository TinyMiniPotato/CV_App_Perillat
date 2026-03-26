import 'package:flutter_riverpod/flutter_riverpod.dart';

final switchProvider = StateProvider<bool>((ref) => false);
final sliderProvider = StateProvider<double>((ref) => 50);
final checkboxProvider = StateProvider<bool>((ref) => false);
final radioProvider = StateProvider<int>((ref) => 1);
