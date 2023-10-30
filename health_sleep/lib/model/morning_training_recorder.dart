
import 'dart:math';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';


/* MoringTrainingRecorderモデル
 * 朝の運動の回数や移動距離，ストローク長を測定してトレーニングをサポートするモデル
 */
FlutterTts tts = FlutterTts();
const dt = 0.1;
const m_dt = 100;

class MoringTrainingRecorder {
  int times = 5;
  double time = 0.0;
  int uDir = 0; //-1はした，0は止まってる，1は上
  List velocity = [0.0, 0.0, 0.0];
  bool isClose = false;
  List trajectory = [[0.0, 0.0, 0.0]];
  List count_record = [0];

  double _calc_distance(List pos1, List pos2) {
    var distance =
    pow(pow(pos1[0] - pos2[0], 2) + pow(pos1[1] - pos2[1], 2) +
        pow(pos1[2] - pos2[2], 2), 0.5);
    return (distance * 100).floor() / 100;
  }

  Future<void> update() async {
    var accel_data = await userAccelerometerEvents.elementAt(0);
    var accel = [
      (accel_data.x * 10).round() / 10,
      (accel_data.y * 10).round() / 10,
      (accel_data.z * 10).round() / 10
    ];

    // 経過時間の計算
    this.time += dt;
    // 速度の計算
    this.velocity = [
      (this.velocity[0] + accel[0] * dt * 10).round() / 10,
      (this.velocity[1] + accel[1] * dt * 10).round() / 10,
      (this.velocity[2] + accel[2] * dt * 10).round() / 10
    ];

    if (this.velocity[1] < 0.1) {
      this.uDir = -1;
    } else if (this.velocity[1] > 0.1) {
      this.uDir = 1;
    } else {
      this.uDir = 0;
    }

    // 位置の計算
    var pos = [
      (this.trajectory.last[0] + this.velocity[0] * dt),
      (this.trajectory.last[1] + this.velocity[1] * dt),
      (this.trajectory.last[2] + this.velocity[2] * dt)
    ];
    this.trajectory.add(pos);
    print(pos);

    if (count_record.last + 5 < trajectory.length) {
      if (_calc_distance(trajectory[count_record.last],
          trajectory[trajectory.length - 1]) +
          0.03 <
          _calc_distance(trajectory[count_record.last],
              trajectory[trajectory.length - 4]) &&
          isClose == false) {
        isClose = true;
      }
      print(isClose);
      if (_calc_distance(trajectory[count_record.last],
          trajectory[trajectory.length - 1]) >
          _calc_distance(trajectory[count_record.last],
              trajectory[trajectory.length - 4]) &&
          isClose == true) {
        this.times -= 1;
        isClose = false;
        count_record.add(trajectory.length - 1);
        this.velocity = [0.0, 0.0, 0.0];
        this.trajectory.last = [0.0, 0.0, 0.0];
        await tts.setLanguage("ja-JP");
        await tts.setVolume(1.0);
        await tts.setPitch(1.0);
        if(this.times > 0) {
          tts.speak('あと${this.times.toString()}回');
        }else{
          tts.speak('トレーニングは終了です．きょうもいちにち頑張りましょう．');
        }
      }

    }
    print(this.times);
  }

  void reset() {
    this.times = 0;
    this.time = 0.0;
    this.uDir = 0;
    this.velocity = [0.0, 0.0, 0.0];
    this.isClose = false;
    this.trajectory = [[0.0, 0.0, 0.0]];
    this.count_record = [0];
  }
}