import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server.dart';
import 'servers_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late V2ray v2ray;
  final ValueNotifier<V2RayStatus> statusNotifier = ValueNotifier(V2RayStatus());
  Server? currentServer;
  bool isConnected = false;
  String subUrl = "";
  Timer? autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    v2ray = V2ray(onStatusChanged: (status) {
      statusNotifier.value = status;
      setState(() => isConnected = status.state == 'CONNECTED');
    });

    _initV2ray();
    _loadSettings();
  }

  Future<void> _initV2ray() async {
    await v2ray.initialize();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    subUrl = prefs.getString('sub_url') ?? "";

    final box = Hive.box('servers');
    if (box.isEmpty && subUrl.isNotEmpty) {
      await _loadSubscription();
    } else {
      _loadLastServer();
    }
  }

  Future<void> _loadSubscription() async {
    if (subUrl.isEmpty) return;

    try {
      final resp = await http.get(Uri.parse(subUrl));
      String data = resp.body.trim();

      if (data.length % 4 == 0 && !data.contains('\n')) {
        data = utf8.decode(base64.decode(data));
      }

      final lines = data.split('\n').where((l) => l.trim().isNotEmpty);

      final List<Server> servers = [];
      for (var link in lines) {
        try {
          final parser = V2ray.parseFromURL(link.trim());
          servers.add(Server(
            remark: parser.remark,
            config: parser.getFullConfiguration(),
            link: link.trim(),
          ));
        } catch (_) {}
      }

      final box = Hive.box('servers');
      await box.put('list', servers.map((s) => s.toJson()).toList());

      Fluttertoast.showToast(msg: "Загружено ${servers.length} серверов");
      if (servers.isNotEmpty && currentServer == null) {
        setState(() => currentServer = servers.first);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Ошибка загрузки подписки");
    }
  }

  void _loadLastServer() {
    final box = Hive.box('servers');
    final list = box.get('list') as List? ?? [];
    if (list.isNotEmpty) {
      setState(() => currentServer = Server.fromJson(Map.from(list.first)));
    }
  }

  String _getFlag(String remark) {
    final lower = remark.toLowerCase();
    if (lower.contains('ru')) return '🇷🇺';
    if (lower.contains('us')) return '🇺🇸';
    if (lower.contains('de')) return '🇩🇪';
    return '🌐';
  }

  Future<void> connect() async {
    if (currentServer == null) {
      Fluttertoast.showToast(msg: "Выберите сервер");
      return;
    }

    if (await v2ray.requestPermission()) {
      v2ray.startV2Ray(
        remark: currentServer!.remark,
        config: currentServer!.config,
        proxyOnly: false,
      );
    }
  }

  void disconnect() => v2ray.stopV2Ray();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AliusVPN", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ServersScreen(onServerSelected: (s) => setState(() => currentServer = s))),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.vpn_key, size: 120, color: Colors.blueAccent),
            const SizedBox(height: 30),
            ValueListenableBuilder<V2RayStatus>(
              valueListenable: statusNotifier,
              builder: (_, status, __) => Column(
                children: [
                  Text(
                    isConnected ? "Подключено ✅" : "Отключено",
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  if (currentServer != null)
                    Text("${_getFlag(currentServer!.remark)} ${currentServer!.remark}", style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: isConnected ? disconnect : connect,
              icon: Icon(isConnected ? Icons.power_settings_new : Icons.power, size: 32),
              label: Text(isConnected ? "Отключить" : "Подключить", style: const TextStyle(fontSize: 24)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 22),
                backgroundColor: isConnected ? Colors.red : Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: _loadSubscription,
              icon: const Icon(Icons.refresh),
              label: const Text("Обновить подписку"),
            ),
          ],
        ),
      ),
    );
  }
}
