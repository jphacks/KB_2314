// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SquatStruct extends FFFirebaseStruct {
  SquatStruct({
    int? squatNumber,
    int? squatLast,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _squatNumber = squatNumber,
        _squatLast = squatLast,
        super(firestoreUtilData);

  // "squat_number" field.
  int? _squatNumber;
  int get squatNumber => _squatNumber ?? 0;
  set squatNumber(int? val) => _squatNumber = val;
  void incrementSquatNumber(int amount) => _squatNumber = squatNumber + amount;
  bool hasSquatNumber() => _squatNumber != null;

  // "squat_last" field.
  int? _squatLast;
  int get squatLast => _squatLast ?? 0;
  set squatLast(int? val) => _squatLast = val;
  void incrementSquatLast(int amount) => _squatLast = squatLast + amount;
  bool hasSquatLast() => _squatLast != null;

  static SquatStruct fromMap(Map<String, dynamic> data) => SquatStruct(
        squatNumber: castToType<int>(data['squat_number']),
        squatLast: castToType<int>(data['squat_last']),
      );

  static SquatStruct? maybeFromMap(dynamic data) =>
      data is Map<String, dynamic> ? SquatStruct.fromMap(data) : null;

  Map<String, dynamic> toMap() => {
        'squat_number': _squatNumber,
        'squat_last': _squatLast,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'squat_number': serializeParam(
          _squatNumber,
          ParamType.int,
        ),
        'squat_last': serializeParam(
          _squatLast,
          ParamType.int,
        ),
      }.withoutNulls;

  static SquatStruct fromSerializableMap(Map<String, dynamic> data) =>
      SquatStruct(
        squatNumber: deserializeParam(
          data['squat_number'],
          ParamType.int,
          false,
        ),
        squatLast: deserializeParam(
          data['squat_last'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'SquatStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SquatStruct &&
        squatNumber == other.squatNumber &&
        squatLast == other.squatLast;
  }

  @override
  int get hashCode => const ListEquality().hash([squatNumber, squatLast]);
}

SquatStruct createSquatStruct({
  int? squatNumber,
  int? squatLast,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SquatStruct(
      squatNumber: squatNumber,
      squatLast: squatLast,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SquatStruct? updateSquatStruct(
  SquatStruct? squat, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    squat
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSquatStructData(
  Map<String, dynamic> firestoreData,
  SquatStruct? squat,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (squat == null) {
    return;
  }
  if (squat.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && squat.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final squatData = getSquatFirestoreData(squat, forFieldValue);
  final nestedData = squatData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = squat.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSquatFirestoreData(
  SquatStruct? squat, [
  bool forFieldValue = false,
]) {
  if (squat == null) {
    return {};
  }
  final firestoreData = mapToFirestore(squat.toMap());

  // Add any Firestore field values
  squat.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSquatListFirestoreData(
  List<SquatStruct>? squats,
) =>
    squats?.map((e) => getSquatFirestoreData(e, true)).toList() ?? [];
