import 'package:flutter/material.dart';

showConfirmDialog({
  required BuildContext context,
  required String message,
  required onOkay,
  required Function onCancel,
  required String okayButtonName,
  required String cancelButtonName,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text("Warning"),
          ],
        ),
        content: Text(message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w400, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onCancel();
            },
            child: Text(cancelButtonName),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onOkay();
            },
            child: Text(okayButtonName),
          ),
        ],
      );
    },
  );
}
