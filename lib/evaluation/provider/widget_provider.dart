
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../param/evaluation_param.dart';

final scoreProvider = StateProvider.autoDispose<ScoreModel>((ref) => ScoreModel(
    sincerity: 0, jobPerformance: 0, punctuality: 0, communication: 0));
