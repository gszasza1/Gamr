// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DBPointAdapter extends TypeAdapter<DBPoint> {
  @override
  final int typeId = 2;

  @override
  DBPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DBPoint(
      x: fields[0] as double,
      y: fields[1] as double,
      z: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DBPoint obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y)
      ..writeByte(2)
      ..write(obj.z);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DBPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
