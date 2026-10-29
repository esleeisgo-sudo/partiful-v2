import 'package:flutter/material.dart';
import '../models.dart';

class CResultSheet extends StatefulWidget {
  final PartyItem item;
  final Function(String newRsvp, String? snoozeTime) onRsvpUpdated;

  const CResultSheet({
    super.key,
    required this.item,
    required this.onRsvpUpdated,
  });

  @override
  State<CResultSheet> createState() => _CResultSheetState();
}

class _CResultSheetState extends State<CResultSheet> {
  String _selectedRsvp = 'Going';
  double _snoozeHours = 4.0;

  @override
  void initState() {
    super.initState();
    _selectedRsvp = widget.item.userRsvp;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('RSVP 응답 및 알림 유예 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // C-1 P03
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Going', 'Not Going', 'Snooze (나중에)'].map((status) {
              return ChoiceChip(
                label: Text(status),
                selected: _selectedRsvp == status,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedRsvp = status;
                    });
                  }
                },
              );
            }).toList(),
          ),
          if (_selectedRsvp == 'Snooze (나중에)') ...[
            const Divider(height: 32),
            const Text('바쁜 일정을 위해 원하는 시간에 알림을 다시 보내드립니다:', style: TextStyle(fontSize: 13, color: Colors.grey)),
            Row(
              children: [
                Text('${_snoozeHours.toInt()}시간 후 재알림'),
                Expanded(
                  child: Slider(
                    value: _snoozeHours,
                    min: 1,
                    max: 24,
                    divisions: 23,
                    onChanged: (val) {
                      setState(() {
                        _snoozeHours = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                String? snoozeText = _selectedRsvp == 'Snooze (나중에)' ? '${_snoozeHours.toInt()}시간 후' : null;
                widget.onRsvpUpdated(_selectedRsvp, snoozeText);
                Navigator.pop(context); // C-2 P03
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
              child: const Text('설정 완료', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}