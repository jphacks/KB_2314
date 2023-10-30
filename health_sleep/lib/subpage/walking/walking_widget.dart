import 'package:health_sleep/subpage/walking/platform_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'walking_model.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/foundation.dart';

class WalkingWidget extends StatefulWidget {
  @override
  _WalkingWidgetState createState() => _WalkingWidgetState();
}

class _WalkingWidgetState extends State<WalkingWidget> {
  Soundpool? _pool;
  SoundpoolOptions _soundpoolOptions = SoundpoolOptions();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initPool(_soundpoolOptions);
    }
    Future.delayed(Duration(seconds: 0), () {
      print('5秒後に実行される');
      _initPool(_soundpoolOptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pool == null) {
      return Material(
        child: Center(
          child: ElevatedButton(
            onPressed: () => _initPool(_soundpoolOptions),
            child: Text("Init Soundpool"),
          ),
        ),
      );
    } else {
      return SoundWidget(
        pool: _pool!,
        onOptionsChange: _initPool,
      );
    }
  }

  void _initPool(SoundpoolOptions soundpoolOptions) {
    _pool?.dispose();
    setState(() {
      _soundpoolOptions = soundpoolOptions;
      _pool = Soundpool.fromOptions(options: _soundpoolOptions);
      print('pool updated: $_pool');
    });
  }
}

class SoundWidget extends StatefulWidget {
  final Soundpool pool;
  final ValueSetter<SoundpoolOptions> onOptionsChange;
  SoundWidget({Key? key, required this.pool, required this.onOptionsChange})
      : super(key: key);

  @override
  _SoundWidgetState createState() => _SoundWidgetState();
}

class _SoundWidgetState extends State<SoundWidget> {
  int? _alarmSoundStreamId;
  int _cheeringStreamId = -1;

  Soundpool get _soundpool => widget.pool;

  void initState() {
    super.initState();

    _loadSounds();
    _playSound();
    Future.delayed(Duration(seconds: 0), () {
      print('5秒後に実行される');
      _pauseSound();
    });
  }

  void _loadSounds() {
    _soundId = _loadSound();
  }

  @override
  void didUpdateWidget(SoundWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pool != widget.pool) {
      _loadSounds();
    }
  }

  double _volume = 1.0;
  double _rate = 1.0;
  late Future<int> _soundId;
  late Future<int> _cheeringId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final newOptions = await Navigator.of(context).push<
                        SoundpoolOptions>(
                    MaterialPageRoute(builder: (context) => PlatformOptions()));
                if (newOptions != null) {
                  widget.onOptionsChange(newOptions);
                }
              },
              icon: Icon(
                Icons.access_alarms,
              ))
        ],
      ),
      body: Center(
        child: SizedBox(
          width: kIsWeb ? 450 : double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Rolling dices'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _playSound,
                    child: Text("Play"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _pauseSound,
                    child: Text("Pause"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _stopSound,
                    child: Text("Stop"),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text('Set rate '),
              Row(children: [
                Expanded(
                  child: Slider.adaptive(
                    min: 0.5,
                    max: 2.0,
                    value: _rate,
                    onChanged: (newRate) {
                      setState(() {
                        _rate = newRate;
                      });
                    },
                  ),
                ),
                Text('${_rate.toStringAsFixed(3)}'),
              ]),
              SizedBox(height: 8.0),
              Text('Volume'),
              Slider.adaptive(
                  value: _volume,
                  onChanged: (newVolume) {
                    setState(() {
                      _volume = newVolume;
                    });
                    _updateVolume(newVolume);
                  }),
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

  Future<void> _updateVolume(newVolume) async {
    // if (_alarmSound >= 0){
    var _cheeringSound = await _cheeringId;
    _soundpool.setVolume(soundId: _cheeringSound, volume: newVolume);
    // }
  }
}
