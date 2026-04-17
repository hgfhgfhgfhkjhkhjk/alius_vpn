import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings settings;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('settings');
    settings = box.get('appSettings', defaultValue: AppSettings()) as AppSettings;
  }

  Future<void> _save() async {
    final box = Hive.box('settings');
    await box.put('appSettings', settings);
    Fluttertoast.showToast(msg: "Настройки сохранены ✓");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Настройки")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Подписка", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: "Ссылка на подписку"),
            controller: TextEditingController(text: (List<String>.from(jsonDecode(settings.subUrls))).join(",")),
            onChanged: (val) {
              final urls = val.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              settings.subUrls = jsonEncode(urls);
            },
          ),

          const Divider(height: 40),

          const Text("Подключение", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text("TUN / VPN режим"),
            value: settings.tunMode,
            onChanged: (v) => setState(() => settings.tunMode = v),
          ),
          SwitchListTile(
            title: const Text("Автоподключение при запуске"),
            value: settings.autoConnect,
            onChanged: (v) => setState(() => settings.autoConnect = v),
          ),

          const Divider(height: 40),

          const Text("Маршрутизация", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text("Bypass RU (прямое соединение для России)"),
            value: settings.bypassRU,
            onChanged: (v) => setState(() => settings.bypassRU = v),
          ),

          const Divider(height: 40),

          const Text("DNS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(
            decoration: const InputDecoration(labelText: "DNS сервер"),
            controller: TextEditingController(text: settings.dnsServer),
            onChanged: (v) => settings.dnsServer = v,
          ),

          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _save,
            child: const Text("Сохранить настройки"),
          ),
        ],
      ),
    );
  }
}
