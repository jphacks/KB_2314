import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
/*
// 生成されるdartファイル
part 'recorder.freezed.dart';*/

/* Recorderモデル
 * 回数や移動距離，ストローク長を測定してトレーニングを記録するモデル
 */
FlutterTts tts = FlutterTts();

const dt = 0.1;
const m_dt = 100;

class Recorder {
  double time = 0.0;
  List velocity = [0.0, 0.0, 0.0];
  List accel = [0.0, 0.0, 0.0];
  List velocity_record = [[0.0, 0.0, 0.0]];
  List trajectory = [[0.0, 0.0, 0.0]];

  Future<void> update(isInit) async {
    if(isInit == true) {
      this.velocity = [0.0, 0.0, 0.0];
      this.trajectory.last = [0.0, 0.0, 0.0];
      this.velocity_record.last = [0.0, 0.0, 0.0];
    }

    var accel_data = await userAccelerometerEvents.elementAt(0);
    this.accel = [
      accel_data.x,
      accel_data.y,
      accel_data.z
    ];

    // 経過時間の計算
    this.time += dt;
    // 速度の計算
    this.velocity = [
      (this.velocity_record.last[0] + accel[0] * dt),
      (this.velocity_record.last[1] + accel[1] * dt),
      (this.velocity_record.last[2] + accel[2] * dt)
    ];
    this.velocity_record.add(this.velocity);

    // 位置の計算
    var pos = [
      (this.trajectory.last[0] + this.velocity[0] * dt),
      (this.trajectory.last[1] + this.velocity[1] * dt),
      (this.trajectory.last[2] + this.velocity[2] * dt)
    ];
    this.trajectory.add(pos);
    }


  void reset() {
    this.accel = [0.0,0.0,0.0];
    this.time = 0.0;
    this.velocity = [0.0, 0.0, 0.0];
    this.trajectory = [[0.0, 0.0, 0.0]];
    this.velocity_record = [[0.0, 0.0, 0.0]];
  }
}