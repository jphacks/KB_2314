import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlarmRecord extends FirestoreRecord {
  AlarmRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  bool hasTime() => _time != null;

  // "day" field.
  int? _day;
  int get day => _day ?? 0;
  bool hasDay() => _day != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _time = snapshotData['time'] as DateTime?;
    _day = castToType<int>(snapshotData['day']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('alarm')
          : FirebaseFirestore.instance.collectionGroup('alarm');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('alarm').doc();

  static Stream<AlarmRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AlarmRecord.fromSnapshot(s));

  static Future<AlarmRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AlarmRecord.fromSnapshot(s));

  static AlarmRecord fromSnapshot(DocumentSnapshot snapshot) => AlarmRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AlarmRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AlarmRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AlarmRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AlarmRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAlarmRecordData({
  DateTime? time,
  int? day,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'time': time,
      'day': day,
    }.withoutNulls,
  );

  return firestoreData;
}

class AlarmRecordDocumentEquality implements Equality<AlarmRecord> {
  const AlarmRecordDocumentEquality();

  @override
  bool equals(AlarmRecord? e1, AlarmRecord? e2) {
    return e1?.time == e2?.time && e1?.day == e2?.day;
  }

  @override
  int hash(AlarmRecord? e) => const ListEquality().hash([e?.time, e?.day]);

  @override
  bool isValidKey(Object? o) => o is AlarmRecord;
}
