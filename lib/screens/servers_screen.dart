import 'package:flutter/material.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/server.dart';

class ServersScreen extends StatefulWidget {
  final Function(Server) onServerSelected;
  const ServersScreen({super.key, required this.onServerSelected});

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  List<Server> servers = [];
  final V2ray v2rayTest = V2ray(onStatusChanged: (status) {});

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  Future<void> _loadServers() async {
    final box = Hive.box('servers');
    final list = box.get('list') ?? [];
    servers = list.map<Server>((e) => Server.fromJson(Map.from(e))).toList();
    setState(() {});
  }

  Future<void> _testAllPings() async {
    for (var s in servers) {
      try {
        s.delayMs = await v2rayTest.getServerDelay(config: s.config);
      } catch (_) {
        s.delayMs = 9999;
      }
    }
    servers.sort((a, b) => (a.delayMs ?? 9999).compareTo(b.delayMs ?? 9999));
    final box = Hive.box('servers');
    await box.put('list', servers.map((s) => s.toJson()).toList());
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Пинги обновлены и отсортированы")));
  }

  String _getFlag(String remark) {
    final lower = remark.toLowerCase();
    if (lower.contains('ru')) return '🇷🇺';
    if (lower.contains('us')) return '🇺🇸';
    if (lower.contains('de')) return '🇩🇪';
    if (lower.contains('nl')) return '🇳🇱';
    return '🌐';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Серверы"),
        actions: [
          IconButton(
            icon: const Icon(Icons.speed),
            onPressed: _testAllPings,
          ),
        ],
      ),
      body: servers.isEmpty
          ? const Center(child: Text("Нет серверов.\nОбновите подписку в настройках"))
          : ListView.builder(
              itemCount: servers.length,
              itemBuilder: (context, i) {
                final s = servers[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Text(_getFlag(s.remark), style: const TextStyle(fontSize: 32)),
                    title: Text(s.remark),
                    trailing: Text(s.delayMs != null ? "${s.delayMs} ms" : "—", style: const TextStyle(color: Colors.grey)),
                    onTap: () {
                      widget.onServerSelected(s);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
    );
  }
}
