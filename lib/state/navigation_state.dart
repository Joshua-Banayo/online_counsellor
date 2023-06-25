import 'package:flutter_riverpod/flutter_riverpod.dart';

final authIndexProvider = StateProvider<int>((ref) => 0);
final userTypeProvider = StateProvider<String?>((ref) => null);
final userSignUpPageIndexProvider = StateProvider<int>((ref) => 0);
final doctorSignUpPageIndexProvider = StateProvider<int>((ref) => 0);
