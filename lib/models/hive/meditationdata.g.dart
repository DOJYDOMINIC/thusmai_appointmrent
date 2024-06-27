// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditationdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeditationDataAdapter extends TypeAdapter<MeditationData> {
  @override
  final int typeId = 0;

  @override
  MeditationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeditationData(
      startTime: fields[0] as String,
      endTime: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MeditationData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
