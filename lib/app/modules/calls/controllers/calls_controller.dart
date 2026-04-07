import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallsController extends GetxController {
  final searchController = TextEditingController();
  bool isSearching = false;
  
  List<Map<String, dynamic>> calls = [];
  List<Map<String, dynamic>> filteredCalls = [];

  @override
  void onInit() {
    super.onInit();
    // Sample calls data
    calls = [
      {
        'name': 'John Doe',
        'type': 'incoming',
        'time': 'Today, 10:30 AM',
        'isMissed': false,
      },
      {
        'name': 'Jane Smith',
        'type': 'outgoing',
        'time': 'Today, 9:15 AM',
        'isMissed': false,
      },
      {
        'name': 'Mike Johnson',
        'type': 'missed',
        'time': 'Yesterday, 8:45 PM',
        'isMissed': true,
      },
      {
        'name': 'Sarah Williams',
        'type': 'video',
        'time': 'Yesterday, 5:20 PM',
        'isMissed': false,
      },
      {
        'name': 'David Brown',
        'type': 'incoming',
        'time': '2 days ago, 3:10 PM',
        'isMissed': false,
      },
      {
        'name': 'Emily Davis',
        'type': 'missed',
        'time': '3 days ago, 11:30 AM',
        'isMissed': true,
      },
      {
        'name': 'Chris Wilson',
        'type': 'video',
        'time': '4 days ago, 7:45 PM',
        'isMissed': false,
      },
      {
        'name': 'Lisa Anderson',
        'type': 'outgoing',
        'time': '5 days ago, 2:15 PM',
        'isMissed': false,
      },
    ];
    filteredCalls = List.from(calls);
  }

  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) {
      searchController.clear();
      filteredCalls = List.from(calls);
    }
    update();
  }

  void filterCalls(String query) {
    if (query.isEmpty) {
      filteredCalls = List.from(calls);
    } else {
      filteredCalls = calls
          .where((call) =>
              (call['name'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}