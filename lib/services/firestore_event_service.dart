import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:beacon_bloom/models/app_event.dart';

class FirestoreEventService {
  FirestoreEventService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _eventsCol =>
      _db.collection('events');

  /// Streams all events ordered by date ascending.
  Stream<List<AppEvent>> streamEvents() {
    return _eventsCol
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _mapDocToEvent(doc))
            .whereType<AppEvent>()
            .toList());
  }

  Future<List<AppEvent>> fetchEventsOnce() async {
    final qs = await _eventsCol.orderBy('date').get();
    return qs.docs
        .map((d) => _mapDocToEvent(d))
        .whereType<AppEvent>()
        .toList();
  }

  Future<void> addEvent(AppEvent event) async {
    await _eventsCol.doc(event.id).set(_toFirestore(event));
  }

  Future<void> updateEvent(AppEvent event) async {
    await _eventsCol.doc(event.id).update(_toFirestore(event));
  }

  Future<void> deleteEvent(String id) async {
    await _eventsCol.doc(id).delete();
  }

  Map<String, dynamic> _toFirestore(AppEvent e) {
    return {
      'title': e.title,
      'description': e.description,
      'imageUrl': e.imageUrl,
      'category': e.category,
      'date': Timestamp.fromDate(DateTime(e.date.year, e.date.month, e.date.day)),
      'time': e.time,
      'location': e.location,
      'price': e.price,
      'organizerId': e.organizerId,
      'attendeeCount': e.attendeeCount,
      'createdAt': Timestamp.fromDate(e.createdAt),
      'updatedAt': Timestamp.fromDate(e.updatedAt),
    };
  }

  AppEvent? _mapDocToEvent(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final data = doc.data();
      if (data == null) return null;

      DateTime _asDateTime(dynamic v) {
        if (v == null) return DateTime.now();
        if (v is Timestamp) return v.toDate();
        if (v is DateTime) return v;
        if (v is String) {
          try {
            return DateTime.parse(v);
          } catch (_) {
            return DateTime.now();
          }
        }
        return DateTime.now();
      }

      double _asDouble(dynamic v) {
        if (v is num) return v.toDouble();
        if (v is String) {
          return double.tryParse(v) ?? 0.0;
        }
        return 0.0;
      }

      int _asInt(dynamic v) {
        if (v is int) return v;
        if (v is num) return v.toInt();
        if (v is String) return int.tryParse(v) ?? 0;
        return 0;
      }

      final date = _asDateTime(data['date']);
      final createdAt = _asDateTime(data['createdAt']);
      final updatedAt = _asDateTime(data['updatedAt']);

      return AppEvent(
        id: doc.id,
        title: (data['title'] ?? '') as String,
        description: (data['description'] ?? '') as String,
        imageUrl: (data['imageUrl'] ?? '') as String,
        category: (data['category'] ?? 'Other') as String,
        date: date,
        time: (data['time'] ?? '') as String,
        location: (data['location'] ?? '') as String,
        price: _asDouble(data['price']),
        organizerId: (data['organizerId'] ?? '') as String,
        attendeeCount: _asInt(data['attendeeCount']),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e, st) {
      debugPrint('Failed to parse event doc ${doc.id}: $e\n$st');
      return null;
    }
  }
}
