class FollowRequest {
  int id;
  int otherId;

  FollowRequest({
    required this.id,
    required this.otherId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherId': otherId,
    };
  }
}