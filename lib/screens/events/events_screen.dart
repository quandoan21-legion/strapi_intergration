import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/event_controller.dart';
import '../../widgets/category_filter.dart';
import '../../widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<EventController>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tech-Events Hub',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Khám phá sự kiện mới nhất',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
      body: Consumer<EventController>(
        builder: (context, controller, _) {
          if (controller.isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Global Tech Solutions',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Kết nối cộng đồng dev qua\nnhững buổi chia sẻ chất lượng',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.auto_graph,
                          size: 48,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Chủ đề nổi bật',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                CategoryFilter(
                  categories: controller.categories,
                  selectedCategoryId: controller.selectedCategoryId,
                  onSelected: (id) {
                    controller.selectCategory(id);
                  },
                ),
                const SizedBox(height: 16),
                if (controller.errorMessage != null &&
                    controller.events.isEmpty)
                  _ErrorState(
                    message: controller.errorMessage!,
                    onRetry: controller.refresh,
                  )
                else if (controller.isEmpty)
                  const _EmptyState()
                else ...[
                  for (final event in controller.events) ...[
                    EventCard(event: event),
                    const SizedBox(height: 12),
                  ],
                  if (controller.isPaginating)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (!controller.hasMore)
                    Column(
                      children: const [
                        SizedBox(height: 16),
                        Text(
                          'Bạn đã xem hết các sự kiện 🎉',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                ],
                if (controller.errorMessage != null &&
                    controller.events.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Không thể tải thêm dữ liệu: ${controller.errorMessage}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: const [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.black38),
          SizedBox(height: 12),
          Text(
            'Chưa có sự kiện phù hợp',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy kiểm tra lại vào lúc khác nhé!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Không thể tải dữ liệu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
