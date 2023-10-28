import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dptr/model/recorder.dart';
import 'dart:async';

//Recorderモデルのprovider
final recorderProvider =
StateNotifierProvider.autoDispose<RecorderNotifier, Recorder>((ref) {
  return RecorderNotifier(ref);
});

// Recorderモデルのmodel-view
class RecorderNotifier extends StateNotifier<Recorder> {
  RecorderNotifier(this.ref) : super(Recorder());
  final Ref ref;
  Timer? timer = null;

  Future<void> start() async {
    print('start button is tapped');
    this.timer =
        Timer.periodic(const Duration(milliseconds: m_dt), (timer) async {
          state = await state.update();
        });
  }

  void stop() {
    if (this.timer != null) {
      this.timer!.cancel();
      state = state.reset();
    }
    print('stop button is tapped');
  }
}
