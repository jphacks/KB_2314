import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_sleep/model/recorder.dart';
import 'package:health_sleep/model/trainer.dart';
import 'dart:async';
import 'recorder_model_view.dart';
const m_dt = 100;

//Trainerモデルのprovider
final trainerProvider =
StateNotifierProvider<TrainerNotifier, Trainer>((ref) {
  return TrainerNotifier(ref);
});



final timesProvider =
FutureProvider<int?>((ref) async {
  final trainer = ref.watch(trainerProvider);
  return trainer.times;
});



// Recorderモデルのmodel-view
class TrainerNotifier extends StateNotifier<Trainer> {
  TrainerNotifier(this.ref) : super(Trainer());
  final Ref ref;
  Timer? timer = null;

  Future<void> trainingStart() async {
    final recorderController = ref.read(recorderProvider.notifier);
    final recorder = ref.watch(recorderProvider);
    if(this.timer == null) {
      this.timer =
          Timer.periodic(const Duration(milliseconds: m_dt), (timer) async {

            if(state.doInstruct == false){
              state.instruct(recorder.accel, recorder.trajectory, recorder.velocity);
              recorderController.update(true);
            }else{
              recorderController.update(false);
            }
            ref.refresh(timesProvider);
          });
    }
  }

  Future<void> trainingStop() async{
    if (this.timer != null) {
      this.timer!.cancel();
      this.timer = null;
    }
  }

  void reset() {
    state.reset();
  }
}