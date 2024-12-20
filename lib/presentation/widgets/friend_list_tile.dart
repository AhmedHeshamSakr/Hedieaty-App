import 'package:flutter/material.dart';
class FriendListTile extends StatelessWidget {
  final String friendName;
  final IconData profilePic;
  final int upcomingEvents;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;


  const FriendListTile({
    super.key,
    required this.friendName,
    required this.profilePic,
    required this.upcomingEvents,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible( // Wrap ListTile with Dismissible for swipe-to-delete
        key: ValueKey(friendName),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete?.call(),
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
          onTap: onTap,
        ),
      ),
    );
  }
}