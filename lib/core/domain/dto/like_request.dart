class LikeRequest {
  final String userId;
  final String postId;

  LikeRequest({required this.userId, required this.postId});

  toJson () {
    return {
      'userId': userId,
      'postId': postId,
    };
  }
}