import 'dart:async';

import 'package:detox/core/firebase.dart';
import 'package:detox/types/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? user;
  bool isListening = false;

  StreamSubscription? _listener;

  void listen(String id) {
    if (isListening) return;
    isListening = true;

    usersColl.doc(id).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        user = User.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  initAuth({required Function onUserAvailable}) {
    _listener?.cancel();
    _listener = auth.authStateChanges().listen((user) async {
      if (user == null) {
        this.user = null;
        notifyListeners();
      } else {
        this.user = User(
          id: user.uid,
          name: user.displayName ?? "Anonymous",
          dp: user.photoURL ?? "https://picsum.photos/200",
          email: user.email ?? "",
          phoneNumber: user.phoneNumber,
          trackedAppPackages: [],
        );
        notifyListeners();

        try {
          this.user =
              User.fromMap((await usersColl.doc(user.uid).get()).data() ?? {});
          notifyListeners();
          onUserAvailable();
        } catch (e) {
          print("User not found, creating one");
        }

        await usersColl.doc(user.uid).set(this.user!.toMap());
        notifyListeners();
        listen(user.uid);
      }
    });
  }

  addTrackedApp(String packageName) async {
    if (user == null) return;

    user!.trackedAppPackages.add(packageName);
    await usersColl.doc(user!.id).update(user!.toMap());
    notifyListeners();
  }

  removeTrackedApp(String packageName) async {
    if (user == null) return;

    user!.trackedAppPackages.remove(packageName);
    await usersColl.doc(user!.id).update(user!.toMap());
    notifyListeners();
  }
}
