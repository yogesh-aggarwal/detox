import 'package:detox/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TrackerSettings extends StatefulWidget {
  const TrackerSettings({super.key});

  @override
  State<TrackerSettings> createState() => _TrackerSettingsState();
}

class _TrackerSettingsState extends State<TrackerSettings> {
  List<AppInfo>? _apps;

  @override
  void initState() {
    super.initState();

    getUsageStats();
  }

  void getUsageStats() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);

    setState(() {
      _apps = apps;
    });

    // try {
    //   DateTime endDate = DateTime.now();
    //   DateTime startDate = endDate.subtract(Duration(hours: 1));
    //   List<AppUsageInfo> infoList =
    //       await AppUsage().getAppUsage(startDate, endDate);
    //   setState(() => _infos = infoList);

    //   for (var info in infoList) {
    //     print(info.toString());
    //   }
    // } on AppUsageException catch (exception) {
    //   print(exception);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final trackedApps = context.watch<UserProvider>().user?.trackedAppPackages;

    print(trackedApps);

    if (trackedApps == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Tracked apps'),
        actions: [
          IconButton(
            onPressed: () => getUsageStats(),
            icon: const Icon(Icons.refresh),
          ),
        ],
        centerTitle: true,
      ),
      body: _apps == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _apps!.length,
              itemBuilder: (context, index) {
                AppInfo app = _apps![index];

                return ListTile(
                  leading: Image.memory(app.icon!, width: 50, height: 50),
                  title: app.name.toString().text.make(),
                  subtitle: app.packageName.toString().text.make(),
                  trailing: Checkbox(
                    value: trackedApps.contains(app.packageName),
                    onChanged: (value) {},
                  ),
                  onTap: () {
                    if (trackedApps.contains(app.packageName)) {
                      context
                          .read<UserProvider>()
                          .removeTrackedApp(app.packageName!);
                    } else {
                      context
                          .read<UserProvider>()
                          .addTrackedApp(app.packageName!);
                    }
                  },
                );
              },
            ),
    );
  }
}

showTrackerSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (context) => const TrackerSettings(),
  );
}
