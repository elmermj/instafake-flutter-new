import 'package:flutter/material.dart';

class ProfileHandlerWidget extends StatelessWidget {
  const ProfileHandlerWidget({
    super.key,
    this.picUrl, required this.username,
  });

  final String? picUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 45,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              picUrl != null &&
                      picUrl!.isNotEmpty
                  ? picUrl!
                  : "https://picsum.photos/200/300",
            ),
          ),
          const SizedBox(width: 8), // Added space between avatar and username
          Text(
            username,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
