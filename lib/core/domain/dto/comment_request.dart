class CommentRequest {
  final String comment;
  final String username;

  CommentRequest({required this.comment, required this.username});

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'username': username,
    };
  }
}