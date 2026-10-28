import 'package:flutter/material.dart';

void main() => runApp(const RiffCallApp());

const bg = Color(0xFF0B0D12);
const panel = Color(0xFF151923);
const panel2 = Color(0xFF202635);
const accent = Color(0xFF8B5CF6);
const green = Color(0xFF28D7A0);
const muted = Color(0xFF9299AA);

class RiffCallApp extends StatelessWidget {
  const RiffCallApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riff Call',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.dark),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class DemoContact {
  final String name, status, initials;
  final Color color;
  const DemoContact(this.name, this.status, this.initials, this.color);
}

const contacts = [
  DemoContact('Alya Putri', 'Online', 'AP', Color(0xFFE7A2B8)),
  DemoContact('Rizky Pratama', 'Terakhir dilihat 5 mnt lalu', 'RP', Color(0xFF6BA7D9)),
  DemoContact('Nadia Safitri', 'Online', 'NS', Color(0xFFB29AE8)),
  DemoContact('Dimas Arya', 'Online', 'DA', Color(0xFF65C8AE)),
  DemoContact('Fajar Ramadhan', 'Terakhir dilihat 1 jam lalu', 'FR', Color(0xFFE4B46C)),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;
  final List<Map<String, String>> messages = [
    {'name': 'Alya Putri', 'text': 'Nanti kita video call, ya!', 'time': '14.20'},
    {'name': 'Rizky Pratama', 'text': 'Oke, sampai nanti.', 'time': '13.48'},
    {'name': 'Nadia Safitri', 'text': 'Makasih 😄', 'time': 'Kemarin'},
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      ChatScreen(messages: messages),
      const CallsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: accent.withOpacity(.24),
        selectedIndex: tab,
        onDestinationSelected: (v) => setState(() => tab = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.call_outlined), selectedIcon: Icon(Icons.call), label: 'Panggilan'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHome() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
    children: [
      Row(children: [
        Container(width: 46, height: 46, decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [accent, Color(0xFF4F46E5)]),
          borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 27)),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Riff Call', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -.5)),
          Text('Tetap dekat, di mana saja', style: TextStyle(color: muted, fontSize: 12)),
        ])),
        IconButton.filledTonal(onPressed: () => _notice('Notifikasi demo'), icon: const Icon(Icons.notifications_none_rounded)),
      ]),
      const SizedBox(height: 25),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF30245A), Color(0xFF191B35), Color(0xFF171A24)]),
          border: Border.all(color: Colors.white.withOpacity(.08)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.auto_awesome, color: Color(0xFFC4B5FD), size: 18),
            SizedBox(width: 7),
            Text('RIFF ROOMS', style: TextStyle(color: Color(0xFFD3C7FF), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 14),
          const Text('Obrolan jadi\nlebih dekat.', style: TextStyle(fontSize: 28, height: 1.12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 9),
          const Text('Mulai ruang panggilan dan ajak teman bergabung.', style: TextStyle(color: Color(0xFFC4C4D5), fontSize: 13)),
          const SizedBox(height: 18),
          Row(children: [
            Expanded(child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: accent, padding: const EdgeInsets.symmetric(vertical: 13)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(group: true))),
              icon: const Icon(Icons.groups_rounded), label: const Text('Buat room'))),
            const SizedBox(width: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15), side: BorderSide(color: Colors.white.withOpacity(.2))),
              onPressed: _joinRoom, child: const Text('Gabung')),
          ]),
        ]),
      ),
      const SizedBox(height: 26),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Kontak', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () => _notice('Daftar kontak demo'), child: const Text('Lihat semua')),
      ]),
      const SizedBox(height: 5),
      SizedBox(height: 108, child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 17),
        itemBuilder: (_, i) {
          final c = contacts[i];
          return SizedBox(width: 68, child: InkWell(
            onTap: () => _contactActions(c),
            child: Column(children: [
              Stack(children: [
                CircleAvatar(radius: 27, backgroundColor: c.color, child: Text(c.initials, style: const TextStyle(color: Color(0xFF11131A), fontWeight: FontWeight.bold))),
                if (c.status == 'Online') Positioned(right: 0, bottom: 0, child: Container(width: 13, height: 13, decoration: BoxDecoration(color: green, shape: BoxShape.circle, border: Border.all(color: bg, width: 2)))),
              ]),
              const SizedBox(height: 8),
              Text(c.name.split(' ').first, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ]),
          ));
        },
      )),
      const SizedBox(height: 12),
      const Text('Akses cepat', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      _quickTile(Icons.video_call_rounded, 'Video call baru', 'Mulai panggilan video demo', accent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()))),
      _quickTile(Icons.call_rounded, 'Panggilan suara', 'Ngobrol tanpa video', green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(voiceOnly: true)))),
      _quickTile(Icons.chat_rounded, 'Kirim pesan', 'Lanjutkan obrolan dengan teman', const Color(0xFF63A7FF), () => setState(() => tab = 1)),
    ],
  );

  Widget _quickTile(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(.04))),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      leading: Container(width: 45, height: 45, decoration: BoxDecoration(color: color.withOpacity(.14), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, color: muted),
    ),
  );

  void _notice(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text — fitur simulasi')));
  void _joinRoom() {
    final controller = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: panel,
      title: const Text('Gabung room'),
      content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Kode room', hintText: 'Contoh: RIFF-4821')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
        FilledButton(onPressed: () { Navigator.pop(ctx); if (controller.text.trim().isNotEmpty) Navigator.push(context, MaterialPageRoute(builder: (_) => CallScreen(group: true, roomCode: controller.text.trim()))); }, child: const Text('Gabung')),
      ],
    ));
  }
  void _contactActions(DemoContact c) {
    showModalBottomSheet(context: context, backgroundColor: panel, builder: (ctx) => SafeArea(child: Padding(
      padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(radius: 29, backgroundColor: c.color, child: Text(c.initials, style: const TextStyle(color: bg, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10), Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(c.status, style: const TextStyle(color: muted, fontSize: 12)),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: FilledButton.icon(onPressed: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen())); }, icon: const Icon(Icons.videocam), label: const Text('Video'))),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton.icon(onPressed: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(voiceOnly: true))); }, icon: const Icon(Icons.call), label: const Text('Suara'))),
        ]),
      ]),
    )));
  }
}

class CallScreen extends StatefulWidget {
  final bool voiceOnly, group;
  final String? roomCode;
  const CallScreen({super.key, this.voiceOnly = false, this.group = false, this.roomCode});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool mic = true, camera = true, speaker = false, chatOpen = false;
  final chatController = TextEditingController();
  final List<String> chat = ['Hai! Ini contoh chat saat panggilan.'];
  @override
  void dispose() { chatController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B10),
      body: SafeArea(child: Stack(children: [
        Positioned.fill(child: Container(
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF25203E), Color(0xFF10141D), Color(0xFF080A0E)])),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 132, height: 132, decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withOpacity(.17), border: Border.all(color: accent.withOpacity(.4), width: 2)),
              child: Icon(widget.voiceOnly ? Icons.person_rounded : Icons.videocam_rounded, size: 65, color: const Color(0xFFD5C8FF))),
            const SizedBox(height: 22),
            Text(widget.group ? 'Riff Room' : 'Panggilan Demo', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 7),
            Text(widget.roomCode == null ? (widget.voiceOnly ? 'Panggilan suara simulasi' : 'Menghubungkan... demo UI') : 'Kode room: ${widget.roomCode}', style: const TextStyle(color: muted)),
            const SizedBox(height: 15),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20)), child: const Text('00:12  •  Demo', style: TextStyle(fontSize: 12, color: green))),
          ])),
        )),
        if (!widget.voiceOnly && camera) Positioned(right: 18, top: 18, child: Container(width: 100, height: 145, decoration: BoxDecoration(color: panel2, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white24)), child: const Center(child: Icon(Icons.person, size: 44, color: muted)))),
        Positioned(top: 8, left: 8, child: IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.keyboard_arrow_down))),
        if (chatOpen) Positioned(left: 14, right: 14, bottom: 105, child: Container(height: 260, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white12)), child: Column(children: [
          const Row(children: [Icon(Icons.chat_bubble_outline, size: 18), SizedBox(width: 8), Text('Chat panggilan', style: TextStyle(fontWeight: FontWeight.bold)), Spacer()]),
          const Divider(),
          Expanded(child: ListView(children: chat.map((m) => Align(alignment: Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: panel2, borderRadius: BorderRadius.circular(12)), child: Text(m, style: const TextStyle(fontSize: 12)))).toList())),
          Row(children: [Expanded(child: TextField(controller: chatController, decoration: const InputDecoration(hintText: 'Tulis pesan...', isDense: true))), IconButton(onPressed: () { if (chatController.text.trim().isNotEmpty) setState(() { chat.add(chatController.text.trim()); chatController.clear(); }); }, icon: const Icon(Icons.send, color: accent))]),
        ]))),
        Positioned(left: 18, right: 18, bottom: 22, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _control(mic ? Icons.mic : Icons.mic_off, mic ? 'Mikrofon' : 'Bisukan', () => setState(() => mic = !mic), active: !mic),
          if (!widget.voiceOnly) _control(camera ? Icons.videocam : Icons.videocam_off, 'Kamera', () => setState(() => camera = !camera), active: !camera),
          _control(speaker ? Icons.volume_up : Icons.volume_down, 'Speaker', () => setState(() => speaker = !speaker), active: speaker),
          _control(Icons.chat_bubble_outline, 'Chat', () => setState(() => chatOpen = !chatOpen)),
          _control(Icons.call_end, 'Akhiri', () => Navigator.pop(context), danger: true),
        ])),
      ])),
    );
  }

  Widget _control(IconData icon, String label, VoidCallback action, {bool active = false, bool danger = false}) => InkWell(
    onTap: action, borderRadius: BorderRadius.circular(18), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 53, height: 53, decoration: BoxDecoration(color: danger ? const Color(0xFFE5485D) : active ? accent : panel2, borderRadius: BorderRadius.circular(18)), child: Icon(icon, color: Colors.white)),
      const SizedBox(height: 6), Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
    ]),
  );
}

class ChatScreen extends StatefulWidget {
  final List<Map<String, String>> messages;
  const ChatScreen({super.key, required this.messages});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  late List<Map<String, String>> items;
  @override
  void initState() { super.initState(); items = List.of(widget.messages); }
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Column(children: [
    const Padding(padding: EdgeInsets.fromLTRB(20, 22, 20, 15), child: Row(children: [Text('Pesan', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)), Spacer(), Icon(Icons.edit_square, color: accent)])),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Cari percakapan', filled: true, fillColor: panel, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)))),
    const SizedBox(height: 12),
    Expanded(child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 18), itemCount: items.length, separatorBuilder: (_, __) => const Divider(color: Colors.white10, indent: 74), itemBuilder: (_, i) {
      final c = contacts.firstWhere((x) => x.name == items[i]['name'], orElse: () => contacts[0]);
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(radius: 25, backgroundColor: c.color, child: Text(c.initials, style: const TextStyle(color: bg, fontWeight: FontWeight.bold))),
        title: Text(items[i]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(items[i]['text']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: muted)),
        trailing: Text(items[i]['time']!, style: const TextStyle(color: muted, fontSize: 10)),
        onTap: () => _openChat(items[i]['name']!),
      );
    })),
  ]);
  void _openChat(String name) {
    final c = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: panel, title: Text('Chat dengan $name'),
      content: TextField(controller: c, decoration: const InputDecoration(hintText: 'Ketik pesan demo')),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')), FilledButton(onPressed: () { setState(() { items.insert(0, {'name': name, 'text': c.text.trim().isEmpty ? 'Pesan terkirim (demo)' : c.text.trim(), 'time': 'Baru'}); }); Navigator.pop(ctx); }, child: const Text('Kirim'))],
    ));
  }
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Panggilan', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
    const SizedBox(height: 7), const Text('Riwayat dan panggilan grup', style: TextStyle(color: muted)),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Mulai panggilan baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(height: 6), const Text('Pilih jenis panggilan untuk melihat demo UI.', style: TextStyle(color: muted, fontSize: 12)),
      const SizedBox(height: 15),
      FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen())), icon: const Icon(Icons.videocam), label: const Text('Video call'), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48))),
      const SizedBox(height: 9),
      OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(voiceOnly: true))), icon: const Icon(Icons.call), label: const Text('Panggilan suara'), style: OutlinedButton.styleFrom(minimumSi
