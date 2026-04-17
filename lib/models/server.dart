class Server {
  final String remark;
  final String config;
  final String? link;
  int? delayMs;

  Server({
    required this.remark,
    required this.config,
    this.link,
    this.delayMs,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
        remark: json['remark'],
        config: json['config'],
        link: json['link'],
        delayMs: json['delayMs'],
      );

  Map<String, dynamic> toJson() => {
        'remark': remark,
        'config': config,
        'link': link,
        'delayMs': delayMs,
      };
}
