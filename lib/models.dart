class GuestStatus {
  final String name;
  final String status;
  final String channel;

  GuestStatus({
    required this.name,
    required this.status,
    required this.channel,
  });

  factory GuestStatus.fromJson(Map<String, dynamic> json) {
    return GuestStatus(
      name: json['name'] ?? 'Guest',
      status: json['status'] ?? 'Pending',
      channel: json['channel'] ?? 'Push',
    );
  }
}

class PartyItem {
  final String id;
  final String title;
  final String host;
  final String date;
  final String location;
  final String imageUrl;
  String userRsvp;
  String? snoozedUntil;
  final String deliveryStatus;
  bool isCalendarSynced;
  final List<GuestStatus> guests;

  PartyItem({
    required this.id,
    required this.title,
    required this.host,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.userRsvp,
    this.snoozedUntil,
    required this.deliveryStatus,
    required this.isCalendarSynced,
    required this.guests,
  });

  factory PartyItem.fromJson(Map<String, dynamic> json) {
    var guestList = (json['guests'] as List<dynamic>?)
            ?.map((g) => GuestStatus.fromJson(g))
            .toList() ??
        [];
    return PartyItem(
      id: json['id']?.toString() ?? '0',
      title: json['title'] ?? 'Party Event',
      host: json['host'] ?? 'Host',
      date: json['date'] ?? 'TBD',
      location: json['location'] ?? 'Location TBD',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/300',
      userRsvp: json['userRsvp'] ?? 'Pending',
      snoozedUntil: json['snoozedUntil'],
      deliveryStatus: json['deliveryStatus'] ?? 'Push Delivered',
      isCalendarSynced: json['isCalendarSynced'] ?? false,
      guests: guestList,
    );
  }
}