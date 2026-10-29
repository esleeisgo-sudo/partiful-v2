import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<PartyItem>> fetchPartyItems() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/items'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((item) => PartyItem.fromJson(item)).toList();
      }
    } catch (e) {
      // json-server가 꺼져 있거나 연결 불가능 시 시연용 예비 데이터
    }

    return [
      PartyItem(
        id: '1',
        title: 'Y2K Cyberpunk Rooftop Party 🚀',
        host: 'Alex & Sarah',
        date: '2026-10-31 20:00',
        location: 'Central Park Gate 4',
        imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=500',
        userRsvp: 'Pending',
        snoozedUntil: 'Today 8:00 PM',
        deliveryStatus: 'SMS Fallback Sent',
        isCalendarSynced: false,
        guests: [
          GuestStatus(name: 'Tom (tomsawyersf)', status: 'Pending', channel: 'Email Forwarded'),
          GuestStatus(name: 'Rachel (ZHiGoddess)', status: 'Going', channel: 'SMS Fallback')
        ],
      ),
      PartyItem(
        id: '2',
        title: 'Sunset Beach Bonfire 🔥',
        host: 'David Kim',
        date: '2026-11-05 18:00',
        location: 'Ocean Beach Pier #3',
        imageUrl: 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=500',
        userRsvp: 'Going',
        snoozedUntil: null,
        deliveryStatus: 'Push Delivered',
        isCalendarSynced: true,
        guests: [
          GuestStatus(name: 'RahilR', status: 'Going', channel: 'Push Delivered')
        ],
      ),
    ];
  }
}