import 'dart:async';

import 'package:detox/core/firebase.dart';
import 'package:detox/types/usage.dart';
import 'package:detox/types/user.dart';
import 'package:flutter/material.dart';

class UsageProvider with ChangeNotifier {
  List<Usage>? usages;

  StreamSubscription? _listener;

  void listen(List<String> trackedAppPackages) async {
    final userID = auth.currentUser?.uid;
    if (userID == null) return;

    _listener?.cancel();

    final user = User.fromMap((await usersColl.doc(userID).get()).data() ?? {});
    if (trackedAppPackages.isEmpty) {
      usages = [];
      notifyListeners();
      return;
    }

    print(user.trackedAppPackages);

    _listener = usagesColl
        .where("createdBy", isEqualTo: userID)
        .where("packageName", whereIn: user.trackedAppPackages)
        .snapshots()
        .listen((event) {
      usages = event.docs.map((e) => Usage.fromMap(e.data())).toList();
      notifyListeners();
    });
  }

  void addUsage(Usage usage) async {
    await usagesColl.add(usage.toMap());
    notifyListeners();
  }

  void removeUsage(String id) async {
    await usagesColl.doc(id).delete();
    notifyListeners();
  }

  void updateReason(String id, String reason) async {
    await usagesColl.doc(id).update({'reason': reason});
    notifyListeners();
  }
}
