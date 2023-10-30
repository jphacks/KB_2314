import 'dart:async';

import 'package:flutter/scheduler.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'alarming_model.dart';
export 'alarming_model.dart';

import 'package:health_sleep/subpage/walking/platform_options.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AlarmingWidget extends StatefulWidget {
  AlarmingWidget({Key? key}) : super(key: key);

  @override
  _AlarmingWidgetState createState() => _AlarmingWidgetState();
}

class _AlarmingWidgetState extends State<AlarmingWidget> {
  Soundpool? _pool;
  SoundpoolOptions _soundpoolOptions = SoundpoolOptions();
  int? _alarmSoundStreamId;
  int _cheeringStreamId = -1;

  Soundpool get _soundpool => _pool!;

  double _volume = 1.0;
  double _rate = 1.0;
  late Future<int> _soundId;
  late Future<int> _cheeringId;

  late AlarmingModel _model;
  String now_time = dateTimeFormat('jms', getCurrentTimestamp);
  int index = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void _initPool(SoundpoolOptions soundpoolOptions) {
    _pool?.dispose();
    super.initState();
    if (!kIsWeb) {
      _initPool(_soundpoolOptions);
    }
    setState(() {
      _soundpoolOptions = soundpoolOptions;
      _pool = Soundpool.fromOptions(options: _soundpoolOptions);
      print('pool updated: $_pool');
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AlarmingModel());
    Timer.periodic(Duration(seconds: 1), _onTimer);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var _alarmSound = await _soundId;
      _alarmSoundStreamId = await _soundpool.play(_alarmSound);
    });
  }

  void _onTimer(Timer timer) {
    var new_time = dateTimeFormat('jms', getCurrentTimestamp);
    setState(
      () => now_time = new_time,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 1,
                decoration: BoxDecoration(
                  color: Color(0xFF3B4C52),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '現在時刻',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 32,
                          ),
                    ),
                    Text(
                      now_time,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 64,
                          ),
                    ),
                    Divider(
                      thickness: 1,
                      color: FlutterFlowTheme.of(context).accent4,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed('morning_training');
                            _pauseSound;
                          },
                          text: '筋トレに挑戦！',
                          options: FFButtonOptions(
                            width: 360,
                            height: 140,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: Color(0xFF39D8D8),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 84,
                                  fontWeight: FontWeight.w600,
                                ),
                            elevation: 2,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load("assets/sounds/alarm.mp3");
    return await _soundpool.load(asset);
  }

  Future<void> _playSound() async {
    var _alarmSound = await _soundId;
    _alarmSoundStreamId = await _soundpool.play(_alarmSound);
  }

  Future<void> _pauseSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool.pause(_alarmSoundStreamId!);
    }
  }

  Future<void> _stopSound() async {
    if (_alarmSoundStreamId != null) {
      await _soundpool.stop(_alarmSoundStreamId!);
    }
  }

  Future<void> _playCheering() async {
    var _sound = await _cheeringId;
    _cheeringStreamId = await _soundpool.play(
      _sound,
      rate: _rate,
    );
  }

  Future<void> _updateCheeringRate() async {
    if (_cheeringStreamId > 0) {
      await _soundpool.setRate(
          streamId: _cheeringStreamId, playbackRate: _rate);
    }
  }

  Future<void> _updateVolume(newVolume) async {
    // if (_alarmSound >= 0){
    var _cheeringSound = await _cheeringId;
    _soundpool.setVolume(soundId: _cheeringSound, volume: newVolume);
    // }
  }
}
