String visualTime(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final hour = date.hour.toString().padLeft(2, "0");
  final minute = date.minute.toString().padLeft(2, "0");
  return "$hour:$minute";
}

String visualDuration(int duration) {
  final minutes = duration ~/ 1000 ~/ 60;
  final hours = minutes ~/ 60;
  final minutesLeft = minutes % 60;

  String result = "";

  if (hours > 0) result += "$hours hr ";
  if (minutesLeft > 0) result += "$minutesLeft min";
  if (result.isEmpty) result = "${duration ~/ 1000} sec";

  return result.trim();
}
