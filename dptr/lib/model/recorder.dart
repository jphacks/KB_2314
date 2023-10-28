import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:math';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

// 生成されるdartファイル
part 'recorder.freezed.dart';

/* Recorderモデル
 * 回数や移動距離，ストローク長を測定してトレーニングをサポートするモデル
 */
FlutterTts tts = FlutterTts();
const dt = 0.1;
const m_dt = 100;
@freezed
class Recorder with _$Recorder {
  // withの後には「_$[class name]」の形式で記述
  const Recorder._(); // メソッドを追加する場合はコンストラクタを追加する

  // 2点間の距離を計算する．
  double _calc_distance(List pos1, List pos2) {
    var distance =
    pow(pow(pos1[0] - pos2[0], 2) + pow(pos1[1] - pos2[1], 2) + pow(pos1[2] - pos2[2], 2), 0.5);
    return (distance * 100).floor() / 100;
  }

  // プロパティを指定
  const factory Recorder(
      {@Default(0) int times, // 回数 speedが0になったら1回とカウント
        @Default(0.0) double time, // 経過時間
        @Default(0.0) double distance,
        @Default([
          [0, 0, 0]
        ])
        List trajectory,
        @Default([0.0]) List stroke_record,
        @Default([0.0]) List stroke_time_record,
        @Default([0]) List speed_record,
        @Default([
          [0, 0, 0]
        ])
        List velocity_record,
        @Default([0]) List count_record,
        @Default(false) bool isClose //近づいている時true，
      }) = _Recorder;

// json形式で受け取るためのコードを生成するために記述．今回は使わない．
/*
  factory Recorder.fromJson(Map<String, dynamic> json) =>
      _$recorderFromJson(json);
  */

  Recorder reset() {
    return Recorder();
  }

  Timer start() {
    return Timer.periodic(const Duration(milliseconds: m_dt), (timer) {
      update();
    });
  }

  void stop(Timer timer) {
    timer.cancel();
  }

  Future<Recorder> update() async {
    // 経過時間の計算
    var time = this.time + dt;
    // 加速度をセンサーから取得 m/s^2
    var accel_data = await userAccelerometerEvents.elementAt(0);
    var accel = [
      (accel_data.x * 10).round() / 10,
      (accel_data.y * 10).round() / 10,
      (accel_data.z * 10).round() / 10
    ];
    // 速度の計算
    List vel = [
      (this.velocity_record.last[0] + accel[0] * dt * 10).round() / 10,
      (this.velocity_record.last[1] + accel[1] * dt * 10).round() / 10,
      (this.velocity_record.last[2] + accel[2] * dt * 10).round() / 10

    ];
    var velocity_record_copy = [...this.velocity_record];
    velocity_record_copy.add(vel);
    // 速さの計算
    var speed = pow((pow(vel[0], 2) + pow(vel[1], 2) + pow(vel[2], 2)), 0.5);
    var speed_record_copy = [...this.speed_record];
    speed_record_copy.add(speed);
    // 位置の計算
    var pos = [
      (this.trajectory.last[0] + vel[0] * dt),
      (this.trajectory.last[1] + vel[1] * dt),
      (this.trajectory.last[2] + vel[2] * dt)
    ];
    var trajectory_copy = [...trajectory];
    trajectory_copy.add(pos);

    // 動かした距離の計算
    var distance = this.distance +
        _calc_distance(trajectory_copy[trajectory_copy.length - 1],
            trajectory_copy[trajectory_copy.length - 2]);
    // 回数の計算

    int times = this.times;
    var count_record_copy = [...count_record];
    var stroke_record_copy = [...stroke_record];
    var stroke_time_record_copy = [...stroke_time_record];
    bool isClose = this.isClose;
    if (count_record_copy.last + 5 < trajectory_copy.length) {
      if (_calc_distance(trajectory_copy[count_record_copy.last],
          trajectory_copy[trajectory_copy.length - 1]) +
          0.03 <
          _calc_distance(trajectory_copy[count_record_copy.last],
              trajectory_copy[trajectory_copy.length - 4]) &&
          isClose == false) {
        isClose = true;
      }
      print(isClose);
      if (_calc_distance(trajectory_copy[count_record_copy.last],
          trajectory_copy[trajectory_copy.length - 1]) >
          _calc_distance(trajectory_copy[count_record_copy.last],
              trajectory_copy[trajectory_copy.length - 4]) &&
          isClose == true) {
        times += 1;
        isClose = false;
        count_record_copy.add(trajectory_copy.length - 1);
        var stroke = 0.0;
        for(int i = count_record_copy[count_record_copy.length - 2];i < count_record_copy.last;i++){
          stroke += _calc_distance(trajectory_copy[i], trajectory_copy[i+1]);
        }
        stroke_record_copy.add(stroke);
        stroke_time_record_copy.add((count_record_copy.last - count_record_copy[count_record_copy.length - 2])*0.1);
        speed_record_copy.last = 0;
        velocity_record_copy.last = [0.0, 0.0, 0.0];
        trajectory_copy.last = [0.0, 0.0, 0.0];
        await tts.setLanguage("ja-JP");
        await tts.setVolume(1.0);
        await tts.setPitch(1.0);
        tts.speak(times.toString());
      }
    }
    print(pos);

    return Future<Recorder>.value(copyWith(
        time: time,
        times: times,
        distance: distance,
        trajectory: trajectory_copy,
        stroke_record: stroke_record_copy,
        speed_record: speed_record_copy,
        velocity_record: velocity_record_copy,
        stroke_time_record: stroke_time_record_copy,
        count_record: count_record_copy,
        isClose: isClose));
  }
}
