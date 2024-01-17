import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  initializeNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('null');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Messages'),
      ),
      body: FutureBuilder(
        // Replace this with logic to get and filter notifications
        // This is a placeholder
        future: getWhatsAppMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Message> messages = List<Message>.from(snapshot.data ?? []);
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessageItem(messages[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildMessageItem(Message message) {
    return ListTile(
      title: Text(message.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mobile Number: ${message.mobileNumber}'),
          Text('Message: ${message.message}'),
          Text('Timestamp: ${message.timestamp}'),
          if (message is GroupMessage) Text('Group: ${message.groupName}'),
        ],
      ),
    );
  }

  Future<List<Message>> getWhatsAppMessages() async {
    // Replace this with logic to get and filter notifications
    // This is a placeholder
    List<Message> messages = [
      IndividualMessage(
        name: 'sravan',
        mobileNumber: '1234567890',
        message: 'Hello there!',
        timestamp: '2024-01-12 10:30 AM',
      ),
      GroupMessage(
        name: 'leo',
        mobileNumber: '9876543210',
        groupName: 'Flutter Group',
        message: 'Meeting at 2 PM',
        timestamp: '2024-01-12 11:45 AM',
      ),
    ];

    return messages;
  }
}

abstract class Message {
  final String name;
  final String mobileNumber;
  final String message;
  final String timestamp;

  Message({
    required this.name,
    required this.mobileNumber,
    required this.message,
    required this.timestamp,
  });
}

class IndividualMessage extends Message {
  IndividualMessage({
    required String name,
    required String mobileNumber,
    required String message,
    required String timestamp,
  }) : super(
          name: name,
          mobileNumber: mobileNumber,
          message: message,
          timestamp: timestamp,
        );
}

class GroupMessage extends Message {
  final String groupName;

  GroupMessage({
    required String name,
    required String mobileNumber,
    required String groupName,
    required String message,
    required String timestamp,
  })  : groupName = groupName,
        super(
          name: name,
          mobileNumber: mobileNumber,
          message: message,
          timestamp: timestamp,
        );
}
