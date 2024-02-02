import 'package:flutter/material.dart';
import 'package:hyperhire_app/Widgets/reciever_chat_view.dart';
import 'package:hyperhire_app/Widgets/sender_chat_view.dart';

class MessageCard extends StatelessWidget {
  final String name;
  final String message;
  final bool isMine;
  final String day;
  final int online;
  final bool isPhoto;
  final String photoUrl;
  final bool isActive;

  const MessageCard({
    super.key,
    required this.name,
    required this.message,
    required this.isMine,
    required this.day,
    required this.online,
    required this.isPhoto,
    required this.photoUrl,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: !isMine
            ? RecieveChatView(
                photoUrl: photoUrl,
                name: name,
                message: message,
                day: day,
                isActive: isActive,
              )
            : SenderChatView(message: message),
      ),
    );
  }
}
