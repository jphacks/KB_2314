import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'find_symptoms_widget.dart' show FindSymptomsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FindSymptomsModel extends FlutterFlowModel<FindSymptomsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for searchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldController;
  String? Function(BuildContext, String?)? searchFieldControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
