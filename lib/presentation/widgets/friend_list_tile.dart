import 'package:flutter/material.dart';

class FriendListTile extends StatelessWidget {
  final String friendName;
  final IconData profilePic;
  final int upcomingEvents;

  const FriendListTile({
    super.key,
    required this.friendName,
    required this.profilePic,
    required this.upcomingEvents,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(profilePic)),
        title: Text(friendName),
        subtitle: Text(
          upcomingEvents > 0
              ? "Upcoming Events: $upcomingEvents"
              : "No Upcoming Events",
        ),
        trailing: upcomingEvents > 0
            ? CircleAvatar(
          backgroundColor: Colors.red,
          child: Text(
            "$upcomingEvents",
            style: const TextStyle(color: Colors.white),
          ),
        )
            : null,
        onTap: () {
          Navigator.pushNamed(context, '/friendGiftList', arguments: friendName);
        },
      ),
    );
  }
}