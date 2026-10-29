import 'package:flutter/material.dart';
import '../api.dart';
import '../models.dart';
import 'b_detail_screen.dart';

class AListScreen extends StatefulWidget {
  const AListScreen({super.key});

  @override
  State<AListScreen> createState() => _AListScreenState();
}

class _AListScreenState extends State<AListScreen> {
  late Future<List<PartyItem>> _partyFuture;

  @override
  void initState() {
    super.initState();
    _partyFuture = ApiService.fetchPartyItems();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Partiful v2', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          bottom: const TabBar(
            labelColor: Color(0xFF8B5CF6),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: '초대받은 파티'),
              Tab(text: '알림 수신 트래킹'),
            ],
          ),
        ),
        body: FutureBuilder<List<PartyItem>>(
          future: _partyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('초대받은 파티가 없습니다.'));
            }

            final items = snapshot.data!;
            return TabBarView(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 600) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, i) => _buildPartyCard(items[i]),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, i) => _buildPartyCard(items[i]),
                    );
                  },
                ),
                _buildTrackingDashboard(items),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPartyCard(PartyItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BDetailScreen(item: item)),
          ).then((_) => setState(() {}));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Chip(
                    label: Text(item.deliveryStatus, style: const TextStyle(fontSize: 10, color: Colors.white)),
                    backgroundColor: item.deliveryStatus.contains('SMS') ? Colors.orange : const Color(0xFF8B5CF6),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text('일시: ${item.date} • 주최: ${item.host}'),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('RSVP: ${item.userRsvp}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEC4899))),
                  if (item.snoozedUntil != null)
                    Text('⏰ ${item.snoozedUntil} 알림 예정', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingDashboard(List<PartyItem> items) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('하객별 알림 전달 상태 (Push 실패 시 SMS/Email 자동 전환)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        ...items.expand((item) => item.guests).map((guest) => ListTile(
              leading: Icon(
                guest.channel.contains('SMS') ? Icons.sms : Icons.mark_email_read,
                color: const Color(0xFF8B5CF6),
              ),
              title: Text(guest.name),
              subtitle: Text('수신 채널: ${guest.channel}'),
              trailing: Text(guest.status, style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
      ],
    );
  }
}