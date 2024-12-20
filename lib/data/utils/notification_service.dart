import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Initialize Notifications
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null, // Use the app icon as default
      [
        NotificationChannel(
          channelGroupKey: 'high',
          channelKey: 'high',
          channelName: 'Gift Notifications',
          channelDescription: 'Notifications for pledging actions',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high',
          channelGroupName: 'High Priority Notifications',
        ),
      ],
      debug: true,
    );

    // Request permission if not allowed
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Set notification listeners
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  // Notification created callback
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Created: ${receivedNotification.title}');
  }

  // Notification displayed callback
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Displayed: ${receivedNotification.title}');
  }

  // Notification dismissed callback
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint('Notification Dismissed: ${receivedAction.title}');
  }

  // Notification action received callback
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint('Notification Action Received: ${receivedAction.title}');
    final payload = receivedAction.payload ?? {};
    if (payload['navigate'] == 'true') {
      // Navigate to the specific screen if needed
      debugPrint('Navigate to specified screen');
      // Example:
      // Navigator.pushNamed(context, '/specific_screen');
    }
  }

  // Request permission to send notifications
  Future<bool> requestPermission() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Show a gift pledged notification
  Future<void> showGiftPledgedNotification({
    required String giftName,
    String? giftDescription,
    NotificationCategory? category,
    String? bigPicture,
    List<NotificationActionButton>? actionButtons,
    bool scheduled = false,
    int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null),
    'Interval must be provided for scheduled notifications.');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high',
        title: 'Gift Pledged!',
        body: 'Your gift "$giftName" has been pledged!',
        summary: giftDescription,
        notificationLayout: bigPicture != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
        bigPicture: bigPicture,
        category: category,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
        interval: Duration(seconds: interval!),
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
      )
          : null,
    );
  }

  // Show a simple notification
  Future<void> showSimpleNotification({
    required String title,
    required String body,
    String? summary,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
        channelKey: 'high',
        title: title,
        body: body,
        summary: summary,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}