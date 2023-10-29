import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_sleep/model/recorder.dart';
import 'dart:async';



//Recorderモデルのprovider
final recorderProvider =
StateNotifierProvider<RecorderNotifier, Recorder>((ref) {
  return RecorderNotifier(ref);
});


final timeProvider =
FutureProvider<double>((ref) async {
  final recorder = ref.watch(recorderProvider);
  return recorder.time;
});

final udirProvider =
FutureProvider<int>((ref) async {
  final recorder = ref.watch(recorderProvider);
  return recorder.uDir;
});

final timesProvider =
FutureProvider<int?>((ref) async {
  final recorder = ref.watch(recorderProvider);
  return recorder.times;
});



// Recorderモデルのmodel-view
class RecorderNotifier extends StateNotifier<Recorder> {
  RecorderNotifier(this.ref) : super(Recorder());
  final Ref ref;
  Timer? timer = null;

  Future<void> start() async {
    print('start button is tapped');
    if(this.timer == null) {
      this.timer =
          Timer.periodic(const Duration(milliseconds: m_dt), (timer) async {
            await state.update();
            await ref.refresh(timeProvider);
            await ref.refresh(udirProvider);
            await ref.refresh(timesProvider);
          });
    }
  }

  Future<void> stop() async{
    print('stop button is tapped');
    if (this.timer != null) {
        this.timer!.cancel();
        //tate.reset();
        this.timer = null;
    }

  }

  void reset() {
    state.reset();
  }
}