class ChatRoom {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserImageUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatRoom({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
  });
} 