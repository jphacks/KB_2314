import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'NTSQL.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class NoteCard extends StatefulWidget {
  const NoteCard(
      {Key? key,
      required this.word,
      required this.hour,
      required this.minu,
      required this.day,
      required this.cat,
      required this.Nid,
      required this.getData})
      : super(key: key);

  final VoidCallback getData;
  final NTDatabase word;
  final NTDatabase hour;
  final NTDatabase minu;
  final NTDatabase day;
  final NTDatabase cat;
  final NTDatabase Nid;

  @override
  State<NoteCard> createState() => _NoteCard();
}

class _NoteCard extends State<NoteCard> {
  bool? switchValue;
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        closedBuilder: (context, openBuilder) {
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: FlutterFlowTheme.of(context).primaryBackground,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '12:00',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 32,
                        ),
                  ),
                  Switch(
                    value: switchValue ??= true,
                    onChanged: (newValue) async {
                      setState(() => switchValue = newValue);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.word.cat!.toString(),
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Lexend Deca',
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                  ),
                ],
              ),
            ]),
          );
        },
        openBuilder: (context, openBuilder) => NoteDetails(
              word: widget.word,
              getData: widget.getData,
              hour: widget.hour,
              minu: widget.minu,
              day: widget.day,
              cat: widget.cat,
              Nid: widget.Nid,
            ));
  }
}

class NoteDetails extends StatefulWidget {
  const NoteDetails(
      {Key? key,
      required this.word,
      required this.hour,
      required this.minu,
      required this.day,
      required this.cat,
      required this.Nid,
      required this.getData})
      : super(key: key);

  final VoidCallback getData;
  final NTDatabase word;
  final NTDatabase hour;
  final NTDatabase minu;
  final NTDatabase day;
  final NTDatabase cat;
  final NTDatabase Nid;

  @override
  State<NoteDetails> createState() => _NoteDetails();
}

class _NoteDetails extends State<NoteDetails>
    with SingleTickerProviderStateMixin {
  bool _saveVisibility = false;
  String _input = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.word.word!;
  }

  void _saveChanges(String input) async {
    widget.word.word = _input;
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.update(widget.word);
    widget.getData();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Theme.of(context).primaryIconTheme.color,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Visibility(
            visible: _saveVisibility,
            maintainState: true,
            child: TextButton(
              onPressed: () {
                _saveChanges(_input);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          expands: true,
          decoration: null,
          autofocus: true,
          cursorHeight: 28,
          onChanged: (String text) {
            _input = text;
            if (text != '' && text != widget.word.word) {
              setState(() {
                _saveVisibility = true;
              });
            } else {
              setState(() {
                _saveVisibility = false;
              });
            }
          },
        ),
      ),
    );
  }
}
