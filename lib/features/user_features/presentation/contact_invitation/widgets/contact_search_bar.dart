import 'package:flutter/material.dart';

/// {@template contact_search_bar}
/// Search bar for contacts with filtering options
/// {@endtemplate}
class ContactSearchBar extends StatelessWidget {
  /// {@macro contact_search_bar}
  const ContactSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterChanged,
    required this.appUsersOnly,
    required this.appUsersCount,
    required this.totalContactsCount,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<bool> onFilterChanged;
  final bool appUsersOnly;
  final int appUsersCount;
  final int totalContactsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search field
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search contacts...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                        onPressed: onClearSearch,
                        icon: const Icon(Icons.clear),
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue[600]!),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter chips
          Row(
            children: [
              // App users filter
              FilterChip(
                label: Text('App Users ($appUsersCount)'),
                selected: appUsersOnly,
                onSelected: onFilterChanged,
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue[700],
                avatar: Icon(
                  Icons.people,
                  size: 16,
                  color: appUsersOnly ? Colors.blue[700] : Colors.grey[600],
                ),
              ),

              const SizedBox(width: 8),

              // All contacts chip
              FilterChip(
                label: Text('All Contacts ($totalContactsCount)'),
                selected: !appUsersOnly,
                onSelected: (selected) => onFilterChanged(!selected),
                selectedColor: Colors.green[100],
                checkmarkColor: Colors.green[700],
                avatar: Icon(
                  Icons.contacts,
                  size: 16,
                  color: !appUsersOnly ? Colors.green[700] : Colors.grey[600],
                ),
              ),

              const Spacer(),

              // Sync status indicator
              if (appUsersCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$appUsersCount found',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
