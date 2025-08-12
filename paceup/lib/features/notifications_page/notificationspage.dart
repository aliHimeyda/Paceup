import 'package:flutter/material.dart';
import 'package:paceup/features/notifications_page/notificationsprovider.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title bar (CSS: Title Screen)
            Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, 1),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: provider.markAllRead,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: provider.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final n = provider.items[index];
                  final isRead = n['isRead'] as bool;

                  return InkWell(
                    onTap: () => provider.toggleRead(index),
                    child: Container(
                      // CSS: Frame 162 (unread, sarı) / Frame 163 (normal)
                      color: isRead ? Colors.white : const Color(0xFFFFF8EC),
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _leadingIcon(n['type'] as String, context),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((n['title'] as String).isNotEmpty)
                                  Text(
                                    n['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                if ((n['subtitle'] as String).isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    n['subtitle'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Text(
                                  n['time'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leadingIcon(String type, BuildContext context) {
    IconData icon;
    switch (type) {
      case 'follower':
        icon = Icons.person_add_alt_1;
        break;
      case 'bookmark':
        icon = Icons.bookmark_border;
        break;
      case 'like':
        icon = Icons.favorite_border;
        break;
      case 'review':
        icon = Icons.chat_bubble_outline;
        break;
      case 'review_liked':
        icon = Icons.thumb_up_off_alt;
        break;
      default:
        icon = Icons.notifications_none;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
    );
  }
}
