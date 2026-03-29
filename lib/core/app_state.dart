import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/check_in.dart';
import '../models/journal_entry.dart';
import '../models/trigger.dart';
import '../models/goal.dart';
import '../models/chat_message.dart';

class AppState extends ChangeNotifier {
  User? _user;
  final List<CheckIn> _checkIns = [];
  final List<JournalEntry> _journals = [];
  final List<Trigger> _triggers = [];
  final List<Goal> _goals = [];
  final List<ChatMessage> _chatHistory = [];

  User? get user => _user;
  List<CheckIn> get checkIns => List.unmodifiable(_checkIns);
  List<JournalEntry> get journals => List.unmodifiable(_journals);
  List<Trigger> get triggers => List.unmodifiable(_triggers);
  List<Goal> get goals => List.unmodifiable(_goals);
  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  AppState() {
    _initialize();
  }

  Future<void> _initialize() async {
    await load();
    _performAutoCheckIn();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _performAutoCheckIn() {
    if (!isCheckedInToday) {
      _checkIns.add(CheckIn(date: DateTime.now(), completed: true));
      save();
      notifyListeners();
      debugPrint('AUTO-CHECKIN: Welcome back for the day!');
    }
  }

  // Support manual check-in for the UI if needed
  void addCheckIn(bool completed) {
    if (!isCheckedInToday) {
      _checkIns.add(CheckIn(date: DateTime.now(), completed: completed));
      save();
      notifyListeners();
    }
  }

  int get totalCheckIns {
    return _checkIns
        .where((c) => c.completed)
        .map((c) => _normalizeDate(c.date))
        .toSet()
        .length;
  }

  // --- Persistence ---
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('checkIns', jsonEncode(_checkIns.map((c) => c.toJson()).toList()));
    prefs.setString('journals', jsonEncode(_journals.map((j) => j.toJson()).toList()));
    prefs.setString('triggers', jsonEncode(_triggers.map((t) => t.toJson()).toList()));
    prefs.setString('goals', jsonEncode(_goals.map((g) => g.toJson()).toList()));
    prefs.setString('chatHistory', jsonEncode(_chatHistory.map((m) => m.toJson()).toList()));
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    
    final checkInsStr = prefs.getString('checkIns');
    if (checkInsStr != null) {
      _checkIns.clear();
      _checkIns.addAll((jsonDecode(checkInsStr) as List).map((j) => CheckIn.fromJson(j)));
    }

    final journalsStr = prefs.getString('journals');
    if (journalsStr != null) {
      _journals.clear();
      _journals.addAll((jsonDecode(journalsStr) as List).map((j) => JournalEntry.fromJson(j)));
    }

    final triggersStr = prefs.getString('triggers');
    if (triggersStr != null) {
      _triggers.clear();
      _triggers.addAll((jsonDecode(triggersStr) as List).map((j) => Trigger.fromJson(j)));
    }

    final goalsStr = prefs.getString('goals');
    if (goalsStr != null) {
      _goals.clear();
      _goals.addAll((jsonDecode(goalsStr) as List).map((j) => Goal.fromJson(j)));
    }

    final chatHistoryStr = prefs.getString('chatHistory');
    if (chatHistoryStr != null) {
      _chatHistory.clear();
      _chatHistory.addAll((jsonDecode(chatHistoryStr) as List).map((m) => ChatMessage.fromJson(m)));
    }
    
    notifyListeners();
  }

  // --- Logic ---
  bool get isCheckedInToday {
    final today = _normalizeDate(DateTime.now());
    return _checkIns.any((c) => _normalizeDate(c.date) == today && c.completed);
  }

  int get streakCount {
    if (_checkIns.isEmpty) return 0;
    final completedDates = _checkIns
        .where((c) => c.completed)
        .map((c) => _normalizeDate(c.date))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    
    if (completedDates.isEmpty) return 0;
    
    final today = _normalizeDate(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (completedDates.first != today && completedDates.first != yesterday) return 0;
    
    int streak = 0;
    DateTime currentCheck = completedDates.first;
    for (int i = 0; i < completedDates.length; i++) {
      if (completedDates.contains(currentCheck)) {
        streak++;
        currentCheck = currentCheck.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  void addJournal(String title, String content) {
    _journals.add(JournalEntry(
      id: DateTime.now().toIso8601String(),
      date: DateTime.now(),
      title: title,
      content: content,
    ));
    save();
    notifyListeners();
  }

  void addTrigger(String name) {
    _triggers.add(Trigger(id: DateTime.now().toIso8601String(), name: name));
    save();
    notifyListeners();
  }

  void removeTrigger(String id) {
    _triggers.removeWhere((t) => t.id == id);
    save();
    notifyListeners();
  }

  void addGoal(String title) {
    _goals.add(Goal(id: DateTime.now().toIso8601String(), title: title, progress: 0.0));
    save();
    notifyListeners();
  }

  void updateGoalProgress(String id, double progress) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final oldGoal = _goals[index];
      _goals[index] = Goal(id: oldGoal.id, title: oldGoal.title, progress: progress);
      save();
      notifyListeners();
    }
  }

  void addChatMessage(String text, String sender) {
    _chatHistory.add(ChatMessage(text: text, sender: sender, timestamp: DateTime.now()));
    save();
    notifyListeners();
  }

  void clearChatHistory() {
    _chatHistory.clear();
    save();
    notifyListeners();
  }
}
