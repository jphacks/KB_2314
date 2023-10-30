import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlarmTimeRecord extends FirestoreRecord {
  AlarmTimeRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "appointmentName" field.
  String? _appointmentName;
  String get appointmentName => _appointmentName ?? '';
  bool hasAppointmentName() => _appointmentName != null;

  // "appointmentDescription" field.
  String? _appointmentDescription;
  String get appointmentDescription => _appointmentDescription ?? '';
  bool hasAppointmentDescription() => _appointmentDescription != null;

  // "appointmentPerson" field.
  DocumentReference? _appointmentPerson;
  DocumentReference? get appointmentPerson => _appointmentPerson;
  bool hasAppointmentPerson() => _appointmentPerson != null;

  // "appointmentTime" field.
  DateTime? _appointmentTime;
  DateTime? get appointmentTime => _appointmentTime;
  bool hasAppointmentTime() => _appointmentTime != null;

  // "appointmentType" field.
  String? _appointmentType;
  String get appointmentType => _appointmentType ?? '';
  bool hasAppointmentType() => _appointmentType != null;

  // "appointmentEmail" field.
  String? _appointmentEmail;
  String get appointmentEmail => _appointmentEmail ?? '';
  bool hasAppointmentEmail() => _appointmentEmail != null;

  void _initializeFields() {
    _appointmentName = snapshotData['appointmentName'] as String?;
    _appointmentDescription = snapshotData['appointmentDescription'] as String?;
    _appointmentPerson =
        snapshotData['appointmentPerson'] as DocumentReference?;
    _appointmentTime = snapshotData['appointmentTime'] as DateTime?;
    _appointmentType = snapshotData['appointmentType'] as String?;
    _appointmentEmail = snapshotData['appointmentEmail'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('alarm_time');

  static Stream<AlarmTimeRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AlarmTimeRecord.fromSnapshot(s));

  static Future<AlarmTimeRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AlarmTimeRecord.fromSnapshot(s));

  static AlarmTimeRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AlarmTimeRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AlarmTimeRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AlarmTimeRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AlarmTimeRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AlarmTimeRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAlarmTimeRecordData({
  String? appointmentName,
  String? appointmentDescription,
  DocumentReference? appointmentPerson,
  DateTime? appointmentTime,
  String? appointmentType,
  String? appointmentEmail,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'appointmentName': appointmentName,
      'appointmentDescription': appointmentDescription,
      'appointmentPerson': appointmentPerson,
      'appointmentTime': appointmentTime,
      'appointmentType': appointmentType,
      'appointmentEmail': appointmentEmail,
    }.withoutNulls,
  );

  return firestoreData;
}

class AlarmTimeRecordDocumentEquality implements Equality<AlarmTimeRecord> {
  const AlarmTimeRecordDocumentEquality();

  @override
  bool equals(AlarmTimeRecord? e1, AlarmTimeRecord? e2) {
    return e1?.appointmentName == e2?.appointmentName &&
        e1?.appointmentDescription == e2?.appointmentDescription &&
        e1?.appointmentPerson == e2?.appointmentPerson &&
        e1?.appointmentTime == e2?.appointmentTime &&
        e1?.appointmentType == e2?.appointmentType &&
        e1?.appointmentEmail == e2?.appointmentEmail;
  }

  @override
  int hash(AlarmTimeRecord? e) => const ListEquality().hash([
        e?.appointmentName,
        e?.appointmentDescription,
        e?.appointmentPerson,
        e?.appointmentTime,
        e?.appointmentType,
        e?.appointmentEmail
      ]);

  @override
  bool isValidKey(Object? o) => o is AlarmTimeRecord;
}
