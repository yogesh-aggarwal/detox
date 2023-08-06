import 'package:app_usage/app_usage.dart';
import 'package:detox/core/logging.dart';
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

    final trackedAppPackages =
        context.read<UserProvider>().user!.trackedAppPackages;
    getUsageStats(trackedAppPackages);
  }

  void getUsageStats(List<String> trackingPackages) async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      var filtered = infoList
          .where((element) => trackingPackages.contains(element.packageName));

      for (var info in filtered) {
        logger.i(info.toString());
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      logger.e(exception);
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
