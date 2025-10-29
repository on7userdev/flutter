import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beacon_bloom/models/app_event.dart';
// import 'package:beacon_bloom/services/event_storage_service.dart';
import 'package:beacon_bloom/services/firestore_event_service.dart';
import 'package:beacon_bloom/widgets/event_card.dart';
import 'package:beacon_bloom/widgets/category_chip.dart';
import 'package:beacon_bloom/screens/event_detail_page.dart';
import 'package:beacon_bloom/screens/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _SettingsIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.settings, color: theme.colorScheme.primary),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  // Realtime Firestore service
  final FirestoreEventService _eventService = FirestoreEventService();
  final TextEditingController _searchController = TextEditingController();
  List<AppEvent> _allEvents = [];
  List<AppEvent> _displayedEvents = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  Stream<List<AppEvent>>? _eventsStream;

  final List<String> _categories = [
    'All',
    'Music',
    'Technology',
    'Art',
    'Sports',
    'Food',
    'Entertainment',
    'Wellness',
    'Fashion',
  ];

  @override
  void initState() {
    super.initState();
    _eventsStream = _eventService.streamEvents();
    // Initial load state will be cleared when first snapshot arrives (see StreamBuilder)
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Applies current filters to given list; used within the StreamBuilder without setState.
  List<AppEvent> _filtered(List<AppEvent> source) {
    _allEvents = source;
    final query = _searchController.text.trim().toLowerCase();
    final category = _selectedCategory;
    var filtered = source;
    if (category != 'All') {
      filtered = filtered.where((e) => e.category == category).toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query) ||
            e.location.toLowerCase().contains(query);
      }).toList();
    }
    return filtered;
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _searchEvents(String query) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Discover Events',
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _SettingsIconButton(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find amazing experiences near you',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _searchEvents,
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                        prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryChip(
                    label: category,
                    isSelected: _selectedCategory == category,
                    onTap: () => _filterByCategory(category),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<AppEvent>>(
                stream: _eventsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && _isLoading) {
                    return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                  }
                  if (snapshot.hasError) {
                    String details;
                    final err = snapshot.error;
                    if (err is FirebaseException && err.code == 'permission-denied') {
                      details = 'Permission denied. Update Firestore security rules to allow reads.';
                    } else {
                      details = '$err';
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
                          const SizedBox(height: 12),
                          Text('Failed to load events', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(details, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    );
                  }
                  final events = snapshot.data ?? const <AppEvent>[];
                  final filtered = _filtered(events);
                  _isLoading = false;

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 80, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(height: 16),
                          Text(
                            'No events found',
                            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final event = filtered[index];
                      return EventCard(
                        event: event,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailPage(event: event),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
