import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts tts = FlutterTts();

const dt = 0.1;
const m_dt = 100;

/* Trainerモデル
 * トレーニングをサポートするモデル
 */
class Trainer {
  int times = 0;
  int uDir = 0; //-1はした，0は止まってる，1は上
  bool isFirst = true;
  bool doInstruct = false;
  List stroke_record = [0.0];
  List count_record = [0];

  double _calc_distance(List pos1, List pos2) {
    var distance = pow(
        pow(pos1[0] - pos2[0], 2) +
            pow(pos1[1] - pos2[1], 2) +
            pow(pos1[2] - pos2[2], 2),
        0.5);
    return distance.toDouble();
  }

  //　トレーニングの指示と回数と運動のストロークを計測する．
  Future<void> instruct(accel, trajectory,velocity_record) async {
    print(accel);
    doInstruct = true;
    // 読み上げ機能の設定
    await tts.setLanguage("ja-JP");
    await tts.setVolume(1.0);
    await tts.setPitch(1.0);
    // 回数の計算とトレーニングガイド
    if (isFirst == true) {
      tts.speak('スクワットをはじめましょう．しじどおりにしてください.');
      tts.speak('スマホをすいちょくにもち，こしをしたにおろして，とめてください');
      isFirst = false;
      uDir = -1;
    }
    if (uDir == -1 && accel[1] < 0.1 && accel[1] > -0.1 && velocity_record.last[velocity_record.length-5] > 0.1) {
      uDir = 0;
      for (int i = 1; i <= 5; i++) {
        tts.speak('${i}');
        await new Future.delayed(new Duration(seconds: 3));
      }
      tts.speak('こしをあげてください．');
      uDir = 1;
    }
    if (uDir == 1 && accel[1] < 0.1 && accel[1] > -0.1 && velocity_record.last[velocity_record.length-5] < 0.1) {
      uDir = 0;
      this.times += 1;
      tts.speak('${this.times}回');
      count_record.add(trajectory.length - 1);
      // ストロークの計算
      var stroke = 0.0;
      for (int i = count_record[count_record.length - 2];
          i < count_record.last;
          i++) {
        stroke += _calc_distance(trajectory[i], trajectory[i + 1]);
      }
      this.stroke_record.add(stroke);
      await new Future.delayed(new Duration(seconds: 3));
      tts.speak('こしをさげてください．');
      uDir = -1;
    }
    doInstruct = false;
  }

  void reset() {
    this.times = 0;
    this.uDir = 0;
    this.stroke_record = [0.0];
    this.count_record = [0];
    this.isFirst = true;
  }
}
