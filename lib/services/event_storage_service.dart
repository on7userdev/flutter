import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beacon_bloom/models/app_event.dart';

class EventStorageService {
  static const String _eventsKey = 'events';

  Future<List<AppEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_eventsKey);
    if (eventsJson == null) {
      final sampleEvents = _getSampleEvents();
      await saveEvents(sampleEvents);
      return sampleEvents;
    }
    try {
      final List<dynamic> decoded = jsonDecode(eventsJson) as List<dynamic>;
      final events = <AppEvent>[];
      for (var item in decoded) {
        try {
          events.add(AppEvent.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          continue;
        }
      }
      if (events.isEmpty) {
        final sampleEvents = _getSampleEvents();
        await saveEvents(sampleEvents);
        return sampleEvents;
      }
      return events;
    } catch (e) {
      final sampleEvents = _getSampleEvents();
      await saveEvents(sampleEvents);
      return sampleEvents;
    }
  }

  Future<void> saveEvents(List<AppEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = jsonEncode(events.map((e) => e.toJson()).toList());
    await prefs.setString(_eventsKey, eventsJson);
  }

  Future<void> addEvent(AppEvent event) async {
    final events = await loadEvents();
    events.add(event);
    await saveEvents(events);
  }

  Future<void> updateEvent(AppEvent event) async {
    final events = await loadEvents();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event;
      await saveEvents(events);
    }
  }

  Future<void> deleteEvent(String id) async {
    final events = await loadEvents();
    events.removeWhere((e) => e.id == id);
    await saveEvents(events);
  }

  Future<List<AppEvent>> getEventsByCategory(String category) async {
    final events = await loadEvents();
    if (category == 'All') return events;
    return events.where((e) => e.category == category).toList();
  }

  Future<List<AppEvent>> searchEvents(String query) async {
    final events = await loadEvents();
    final lowerQuery = query.toLowerCase();
    return events.where((e) =>
      e.title.toLowerCase().contains(lowerQuery) ||
      e.description.toLowerCase().contains(lowerQuery) ||
      e.location.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  List<AppEvent> _getSampleEvents() {
    final now = DateTime.now();
    return [
      AppEvent(
        id: 'event_1',
        title: 'Summer Music Festival',
        description: 'Join us for an unforgettable outdoor music festival featuring top artists from around the world. Experience live performances, food trucks, and amazing vibes under the stars.',
        imageUrl: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800',
        category: 'Music',
        date: now.add(const Duration(days: 15)),
        time: '6:00 PM',
        location: 'Central Park, New York',
        price: 89.99,
        organizerId: 'user_1',
        attendeeCount: 2547,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      AppEvent(
        id: 'event_2',
        title: 'Tech Innovation Summit 2024',
        description: 'Discover the latest trends in technology, AI, and innovation. Network with industry leaders and attend inspiring keynote sessions.',
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
        category: 'Technology',
        date: now.add(const Duration(days: 22)),
        time: '9:00 AM',
        location: 'Convention Center, San Francisco',
        price: 299.00,
        organizerId: 'user_1',
        attendeeCount: 1823,
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      AppEvent(
        id: 'event_3',
        title: 'Art Gallery Opening',
        description: 'Celebrate contemporary art at our exclusive gallery opening. Meet emerging artists and enjoy complimentary refreshments.',
        imageUrl: 'https://images.unsplash.com/photo-1531243269054-5ebf6f34081e?w=800',
        category: 'Art',
        date: now.add(const Duration(days: 8)),
        time: '7:00 PM',
        location: 'Modern Art Gallery, London',
        price: 0.00,
        organizerId: 'user_1',
        attendeeCount: 342,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      AppEvent(
        id: 'event_4',
        title: 'Marathon for Hope',
        description: 'Run for a cause! Join thousands of runners in this charity marathon supporting local communities. All fitness levels welcome.',
        imageUrl: 'https://images.unsplash.com/photo-1532444458054-01a7dd3e9fca?w=800',
        category: 'Sports',
        date: now.add(const Duration(days: 35)),
        time: '7:00 AM',
        location: 'Downtown, Chicago',
        price: 45.00,
        organizerId: 'user_1',
        attendeeCount: 5621,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      AppEvent(
        id: 'event_5',
        title: 'Food & Wine Festival',
        description: 'Indulge in culinary delights from award-winning chefs. Taste exquisite wines and learn from cooking demonstrations.',
        imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
        category: 'Food',
        date: now.add(const Duration(days: 12)),
        time: '12:00 PM',
        location: 'Harbor Pavilion, Seattle',
        price: 125.00,
        organizerId: 'user_1',
        attendeeCount: 892,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      AppEvent(
        id: 'event_6',
        title: 'Comedy Night Live',
        description: 'Laugh out loud with top comedians performing stand-up routines. A night of non-stop entertainment guaranteed!',
        imageUrl: 'https://images.unsplash.com/photo-1527224857830-43a7acc85260?w=800',
        category: 'Entertainment',
        date: now.add(const Duration(days: 5)),
        time: '8:30 PM',
        location: 'Comedy Club, Los Angeles',
        price: 35.00,
        organizerId: 'user_1',
        attendeeCount: 478,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      AppEvent(
        id: 'event_7',
        title: 'Yoga & Wellness Retreat',
        description: 'Reconnect with yourself in this peaceful weekend retreat. Includes yoga sessions, meditation, and organic meals.',
        imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
        category: 'Wellness',
        date: now.add(const Duration(days: 28)),
        time: '10:00 AM',
        location: 'Mountain Resort, Colorado',
        price: 450.00,
        organizerId: 'user_1',
        attendeeCount: 156,
        createdAt: now.subtract(const Duration(days: 40)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),
      AppEvent(
        id: 'event_8',
        title: 'Fashion Week Showcase',
        description: 'Witness the latest fashion trends on the runway. Exclusive access to designer collections and after-party.',
        imageUrl: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=800',
        category: 'Fashion',
        date: now.add(const Duration(days: 18)),
        time: '6:00 PM',
        location: 'Fashion District, Milan',
        price: 350.00,
        organizerId: 'user_1',
        attendeeCount: 723,
        createdAt: now.subtract(const Duration(days: 35)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }
}
