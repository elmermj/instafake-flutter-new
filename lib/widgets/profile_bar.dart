import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBar extends StatelessWidget {
  const ProfileBar({
    super.key,
    required this.isMe,
    this.isFollowed,
    this.logout,
    this.editProfile,
    this.follow,
    this.unfollow
  });

  final bool isMe;
  final bool? isFollowed;
  final void Function()? logout;
  final void Function()? editProfile;
  final void Function()? follow;
  final void Function()? unfollow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:  Row(
        children: isMe 
      ? [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                side: BorderSide(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                  width: 1
                ),
              ),
              onPressed: (){}, 
              child: const Text(
                "Edit Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),
              )
            ),
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                side: BorderSide(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                  width: 1
                ),
                backgroundColor: Get.theme.colorScheme.error
              ),
              onPressed: logout, 
              child: const Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              )
            ),
          ),
        ]
      : [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                  width: 1,
                ),
                backgroundColor: isFollowed! ? null : Get.theme.colorScheme.primaryContainer
              ),
              onPressed: isFollowed!? unfollow : follow,
              child: Text(
                isFollowed!  ? "Unfollow" : "Follow",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isFollowed!? null : Get.theme.colorScheme.onSurface
                ),
              ),
            ),
          )
        ],
      ) 
      
    );
  }
}

