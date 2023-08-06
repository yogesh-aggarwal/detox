import 'package:app_usage/app_usage.dart';
import 'package:detox/providers/usage.dart';
import 'package:detox/providers/user.dart';
import 'package:detox/types/usage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  List<Usage>? _usages;

  @override
  void initState() {
    super.initState();

    context
        .read<UsageProvider>()
        .listen(context.read<UserProvider>().user!.trackedAppPackages);
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usages = context.watch<UsageProvider>().usages;

    if (usages == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (usages.isEmpty) {
      return const Center(child: Text("No usages yet"));
    }

    return const Placeholder();
  }
}
