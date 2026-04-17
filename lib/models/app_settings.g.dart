// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 1;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      subUrls: fields[0] as String,
      updateIntervalMinutes: fields[1] as int,
      tunMode: fields[2] as bool,
      bypassRU: fields[3] as bool,
      bypassLAN: fields[4] as bool,
      domainStrategy: fields[5] as String,
      dnsServer: fields[6] as String,
      fakeDNS: fields[7] as bool,
      logLevel: fields[8] as String,
      sniffingEnabled: fields[9] as bool,
      autoConnect: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.subUrls)
      ..writeByte(1)
      ..write(obj.updateIntervalMinutes)
      ..writeByte(2)
      ..write(obj.tunMode)
      ..writeByte(3)
      ..write(obj.bypassRU)
      ..writeByte(4)
      ..write(obj.bypassLAN)
      ..writeByte(5)
      ..write(obj.domainStrategy)
      ..writeByte(6)
      ..write(obj.dnsServer)
      ..writeByte(7)
      ..write(obj.fakeDNS)
      ..writeByte(8)
      ..write(obj.logLevel)
      ..writeByte(9)
      ..write(obj.sniffingEnabled)
      ..writeByte(10)
      ..write(obj.autoConnect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
