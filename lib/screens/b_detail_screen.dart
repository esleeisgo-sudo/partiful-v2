import 'package:flutter/material.dart';
import '../models.dart';
import 'c_result_sheet.dart';

class BDetailScreen extends StatefulWidget {
  final PartyItem item;
  const BDetailScreen({super.key, required this.item});

  @override
  State<BDetailScreen> createState() => _BDetailScreenState();
}

class _BDetailScreenState extends State<BDetailScreen> {
  void _openRsvpModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CResultSheet(
        item: widget.item,
        onRsvpUpdated: (newRsvp, snoozeTime) {
          setState(() {
            widget.item.userRsvp = newRsvp;
            widget.item.snoozedUntil = snoozeTime;
          });
        },
      ),
    );
  }

  void _showCalendarSyncDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.calendar_month, color: Color(0xFF8B5CF6)),
            SizedBox(width: 8),
            Text('외부 공유 및 캘린더 동기화'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('배우자/동료에게 이메일로 초대를 전달하거나 캘린더 앱에 저장하세요.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  widget.item.isCalendarSynced = true;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Google / Apple 캘린더에 연동되었습니다!')),
                );
              },
              icon: const Icon(Icons.sync),
              label: const Text('Google / Apple 캘린더에 연동'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.item.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text('일시: ${widget.item.date}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('장소: ${widget.item.location}', style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('내 RSVP: ${widget.item.userRsvp}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEC4899))),
                ElevatedButton.icon(
                  onPressed: _showCalendarSyncDialog,
                  icon: Icon(widget.item.isCalendarSynced ? Icons.check_circle : Icons.event),
                  label: Text(widget.item.isCalendarSynced ? '캘린더 연동됨' : '이메일 전달/캘린더 연동'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                )
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _openRsvpModal,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC4899)),
                child: const Text('RSVP 결정 / 나중에 알림 유예 설정', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}