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
import 'training_model.dart';
export 'training_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_sleep/model_view/recorder_model_view.dart';
import 'package:health_sleep/model_view/trainer_model_view.dart';

class TrainingWidget extends ConsumerWidget {
  const TrainingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.read(recorderProvider.notifier);
    final recorder = ref.watch(recorderProvider);
    final trainerController = ref.read(trainerProvider.notifier);
    final trainer = ref.watch(trainerProvider);
    var _model = createModel(context, () => TrainingModel());
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final time = ref.watch(timeProvider);
    final times = ref.watch(timesProvider);
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme
              .of(context)
              .brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () =>
      _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme
            .of(context)
            .primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                width: MediaQuery
                    .sizeOf(context)
                    .width * 1.0,
                height: MediaQuery
                    .sizeOf(context)
                    .height * 1.0,
                decoration: BoxDecoration(
                  color: Color(0xFFFF9B0F),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'スクワット',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyMedium
                          .override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 32.0,
                      ),
                    ),
                    /*
                    (recorder.uDir == -1)
                        ? Center(
                            child: Icon(Icons.arrow_circle_down_outlined,
                                color: Colors.lightBlue, size: 100))
                        : (recorder.uDir == 1)
                            ? Center(
                                child: Icon(Icons.arrow_circle_up_outlined,
                                    color: Colors.lightBlue, size: 100))
                            : Center(
                                child: Icon(Icons.arrow_circle_right_outlined,
                                    color: Colors.lightBlue, size: 100)),*/
                    Center(
                      child: time.when(
                          data: (data) =>
                              Text(
                                '${(data / (60 * 60)).floor()}:${((data %
                                    (60 * 60)) / 60).floor()}:${((data %
                                    (60 * 60)) % 60).floor()}',
                                style: TextStyle(
                                    fontSize: 50, color: Colors.white),
                              ),
                          error: (err, _) =>
                              Text(
                                '${(0 / (60 * 60)).floor()}:${((0 % (60 * 60)) /
                                    60).floor()}:${((0 % (60 * 60)) % 60)
                                    .floor()}',
                                style: TextStyle(
                                    fontSize: 50, color: Colors.white),
                              ),
                          loading: () {}),
                      /*Text(
                        '${(recorder.time / (60 * 60)).floor()}:${((recorder.time % (60 * 60)) / 60).floor()}:${((recorder.time % (60 * 60)) % 60).floor()}',
                        style: TextStyle(fontSize: 50, color: Colors.white),
                      ),*/
                    ),
                    /*
                    FlutterFlowTimer(
                      initialTime: _model.timerMilliseconds,
                      getDisplayTime: (value) => StopWatchTimer.getDisplayTime(
                          value,
                          milliSecond: false),
                      controller: _model.timerController,
                      onChanged: (value, displayTime, shouldUpdate) {
                        _model.timerMilliseconds = value;
                        _model.timerValue = displayTime;
                        //if (shouldUpdate) setState(() {});
                      },
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 64.0,
                      ),
                    ),*/
                    times.when(
                        data: (data) =>
                            Text(
                              '${data}',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme
                                  .of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 32.0,
                              ),
                            ),
                        error: (err, _) =>
                            Text('${0}',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 32.0,
                                )),
                        loading: () =>
                            Text('${0}',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme
                                    .of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 32.0,
                                ))),
                    /*
                    Text(
                      '${recorder.times}',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 32.0,
                          ),
                    ),*/
                    /*
                    Text(
                      '${(recorder.time/3600) * 1.05 * 5.0 * 60 * 1000} cal 消費',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 32.0,
                          ),
                    ),*/
                    Divider(
                      thickness: 1.0,
                      color: FlutterFlowTheme
                          .of(context)
                          .accent4,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '音量',
                          textAlign: TextAlign.center,
                          style:
                          FlutterFlowTheme
                              .of(context)
                              .bodyMedium
                              .override(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 32.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              30.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: '-',
                            options: FFButtonOptions(
                              width: 40.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF39D8D8),
                              textStyle: FlutterFlowTheme
                                  .of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                              ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              30.0, 0.0, 0.0, 0.0),
                          child: FFButtonWidget(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            text: '+',
                            options: FFButtonOptions(
                              width: 40.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF39D8D8),
                              textStyle: FlutterFlowTheme
                                  .of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                              ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.0,
                      color: FlutterFlowTheme
                          .of(context)
                          .accent4,
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FFButtonWidget(
                            onPressed: () {
                              trainerController.trainingStart();
                              print('Button pressed ...');
                            },
                            text: 'スタート',
                            options: FFButtonOptions(
                              width: 130.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF39D8D8),
                              textStyle: FlutterFlowTheme
                                  .of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 2.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          FFButtonWidget(

                            onPressed: () async {
                              print('stop button is tapped');
                              await trainerController.trainingStop();
                              context.pushNamed('result');
                            },
                            text: '終了',
                            options: FFButtonOptions(
                              width: 130.0,
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF39D8D8),
                              textStyle: FlutterFlowTheme
                                  .of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 2.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ],
                      ),
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
}