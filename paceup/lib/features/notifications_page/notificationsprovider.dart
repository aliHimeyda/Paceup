import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [
    {
      'type': 'follower',
      'title': 'Yeay you got new follower!',
      'subtitle': 'Nararaya Susanti has follow you',
      'time': '1 min ago',
      'isRead': false,
    },
    {
      'type': 'bookmark',
      'title': 'Your “Cumi Saus Telur Asin” recipe bookmarked by Arumi',
      'subtitle': 'Arumi recently bookmark your recipe',
      'time': '5 hour ago',
      'isRead': true,
    },
    {
      'type': 'like',
      'title': 'Arumi like your recipe',
      'subtitle': '',
      'time': '1 day ago',
      'isRead': true,
    },
    {
      'type': 'review',
      'title': 'New review on Cumi Saus Telur Asin recipe',
      'subtitle': 'Arumi write a review “Wah terima kasih bunda” to your recipe',
      'time': '2 day ago',
      'isRead': false,
    },
    {
      'type': 'review_liked',
      'title': 'Your review liked',
      'subtitle': 'Your review on “Ayam Bakar Sambal Matah” being liked by Yuanita',
      'time': '2 day ago',
      'isRead': true,
    },
  ];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  void markAllRead() {
    for (final m in _items) m['isRead'] = true;
    notifyListeners();
  }

  void toggleRead(int index) {
    _items[index]['isRead'] = !(_items[index]['isRead'] as bool);
    notifyListeners();
  }

  void add(Map<String, dynamic> n) {
    _items.insert(0, n);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
