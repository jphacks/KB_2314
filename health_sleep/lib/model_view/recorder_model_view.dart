import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_sleep/model/recorder.dart';
import 'dart:async';

//Recorderモデルのprovider
final recorderProvider =
    StateNotifierProvider<RecorderNotifier, Recorder>((ref) {
  return RecorderNotifier(ref);
});

final timeProvider = FutureProvider<double>((ref) async {
  final recorder = ref.watch(recorderProvider);
  return recorder.time;
});
/*
final timesProvider =
FutureProvider<int?>((ref) async {
  final recorder = ref.watch(recorderProvider);
  return recorder.times;
});*/

// Recorderモデルのmodel-view
class RecorderNotifier extends StateNotifier<Recorder> {
  RecorderNotifier(this.ref) : super(Recorder());
  final Ref ref;
  Timer? timer = null;

  Future<void> update(isReset) async {
    state.update(isReset);
    ref.refresh(timeProvider);
  }

  void reset() {
    state.reset();
  }
}
