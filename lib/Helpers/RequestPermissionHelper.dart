import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

bool permissionsGranted = false;

Future<void> RequestPermission(context) async {
  final storagePermission = await Permission.storage.request();
  final otherPermissions = await PhotoManager.requestPermissionExtend();
  if (storagePermission.isGranted && otherPermissions.hasAccess) {
    permissionsGranted = true;
  } else {
    print("Permissions Denied---------------------------->");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permissions Denied"),
          content: Text("To use this app, please grant permission to access storage in settings."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.of(context).pop();
                // Open app settings
                await openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
