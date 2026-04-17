import 'package:hive_flutter/hive_flutter.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 1)
class AppSettings {
  @HiveField(0)
  String subUrls;

  @HiveField(1)
  int updateIntervalMinutes;

  @HiveField(2)
  bool tunMode;

  @HiveField(3)
  bool bypassRU;

  @HiveField(4)
  bool bypassLAN;

  @HiveField(5)
  String domainStrategy;

  @HiveField(6)
  String dnsServer;

  @HiveField(7)
  bool fakeDNS;

  @HiveField(8)
  String logLevel;

  @HiveField(9)
  bool sniffingEnabled;

  @HiveField(10)
  bool autoConnect;

  AppSettings({
    this.subUrls = '[]',
    this.updateIntervalMinutes = 240,
    this.tunMode = true,
    this.bypassRU = true,
    this.bypassLAN = true,
    this.domainStrategy = "IPIfNonMatch",
    this.dnsServer = "https://1.1.1.1/dns-query",
    this.fakeDNS = false,
    this.logLevel = "warning",
    this.sniffingEnabled = true,
    this.autoConnect = false,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        subUrls: json['subUrls'] ?? '[]',
        updateIntervalMinutes: json['updateIntervalMinutes'] ?? 240,
        tunMode: json['tunMode'] ?? true,
        bypassRU: json['bypassRU'] ?? true,
        bypassLAN: json['bypassLAN'] ?? true,
        domainStrategy: json['domainStrategy'] ?? "IPIfNonMatch",
        dnsServer: json['dnsServer'] ?? "https://1.1.1.1/dns-query",
        fakeDNS: json['fakeDNS'] ?? false,
        logLevel: json['logLevel'] ?? "warning",
        sniffingEnabled: json['sniffingEnabled'] ?? true,
        autoConnect: json['autoConnect'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'subUrls': subUrls,
        'updateIntervalMinutes': updateIntervalMinutes,
        'tunMode': tunMode,
        'bypassRU': bypassRU,
        'bypassLAN': bypassLAN,
        'domainStrategy': domainStrategy,
        'dnsServer': dnsServer,
        'fakeDNS': fakeDNS,
        'logLevel': logLevel,
        'sniffingEnabled': sniffingEnabled,
        'autoConnect': autoConnect,
      };
}
