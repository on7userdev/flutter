# Events App Architecture

## Overview
A beautiful events discovery app with a modern, non-Material UI design featuring sleek animations, generous spacing, and elegant typography.

## Design Approach
**Vibrant & Energetic Style** - Perfect for an events/social app
- Light Mode: Bright coral/orange accents (#FF6B6B) and teal (#4ECDC4) with clean white backgrounds
- Dark Mode: Rich medium-toned colors on dark grays with vibrant accents
- Clean, modern cards with rounded corners
- No heavy shadows - flat, minimal aesthetic
- Generous spacing and whitespace

## Features
1. **Event Discovery** - Browse upcoming events with beautiful cards
2. **Event Details** - View comprehensive event information
3. **Categories** - Filter events by category
4. **Search** - Find specific events

## Data Models (lib/models/)
1. **User** - User profile information
   - id, name, email, avatarUrl, createdAt, updatedAt
   
2. **AppEvent** - Event details (avoiding naming conflict with Flutter's Event)
   - id, title, description, imageUrl, category, date, time, location, price, organizerId, attendeeCount, createdAt, updatedAt

## Services (lib/services/)
1. **EventStorageService** - Manages event data operations
   - Load/save events to local storage
   - CRUD operations for events
   - Filter by category and search
   - Include realistic sample data

2. **UserStorageService** - Manages user data
   - Load/save user profile
   - Include sample user data

## Screens (lib/screens/)
1. **HomePage** - Main event discovery screen
   - Category filters at top
   - Event grid/list with beautiful cards
   - Search functionality
   - Smooth animations

2. **EventDetailPage** - Detailed event view
   - Hero image
   - Full event information
   - Elegant layout with generous spacing

## Widgets (lib/widgets/)
1. **EventCardWidget** - Reusable event card component
2. **CategoryChipWidget** - Category filter chips
3. **SearchBarWidget** - Custom search bar

## Implementation Steps
1. Update theme with vibrant color palette
2. Create data models with toJson/fromJson/copyWith
3. Implement storage services with sample data
4. Build reusable widget components
5. Create HomePage with event grid and filters
6. Create EventDetailPage with beautiful layout
7. Add smooth animations and transitions
8. Compile and fix any errors
