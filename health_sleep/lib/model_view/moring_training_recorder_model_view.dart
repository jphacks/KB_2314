import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:health_sleep/model/recorder.dart';
import 'dart:async';
import 'package:health_sleep/model/morning_training_recorder.dart';



//Recorderモデルのprovider
final morningRecorderProvider =
StateNotifierProvider<RecorderNotifier, MoringTrainingRecorder>((ref) {
  return RecorderNotifier(ref);
});


final timeProvider =
FutureProvider<double>((ref) async {
  final recorder = ref.watch(morningRecorderProvider);
  return recorder.time;
});


final timesProvider =
FutureProvider<int?>((ref) async {
  final recorder = ref.watch(morningRecorderProvider);
  return recorder.times;
});



// Recorderモデルのmodel-view
class RecorderNotifier extends StateNotifier<MoringTrainingRecorder> {
  RecorderNotifier(this.ref) : super(MoringTrainingRecorder());
  final Ref ref;
  Timer? timer = null;

  Future<void> start() async {
    print('start button is tapped');
    if (this.timer == null) {
      this.timer =
          Timer.periodic(const Duration(milliseconds: m_dt), (timer) async {
            await state.update();
            await ref.refresh(timeProvider);
            await ref.refresh(timesProvider);
          });
    }
  }

  Future<void> stop() async {
    print('stop button is tapped');
    if (this.timer != null) {
      this.timer!.cancel();
      //tate.reset();
      this.timer = null;
    }
  }
}