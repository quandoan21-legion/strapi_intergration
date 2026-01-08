import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/api_config.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  EventCard({super.key, required this.event});

  final Event event;
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy – HH:mm');

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConfig.resolveMediaUrl(event.coverUrl);
    final dateLabel = event.startDate != null
        ? _dateFormat.format(event.startDate!.toLocal())
        : 'Đang cập nhật';

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.black12,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.7),
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.event, size: 56, color: Colors.white),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.category != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      event.category!.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  event.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                if (event.location?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.pin_drop_outlined, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.location!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  event.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
