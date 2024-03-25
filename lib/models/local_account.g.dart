// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalAccountAdapter extends TypeAdapter<LocalAccount> {
  @override
  final int typeId = 0;

  @override
  LocalAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalAccount(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalAccount obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
