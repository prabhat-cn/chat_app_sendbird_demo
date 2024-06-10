import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String appId;
  final List<String> otherUserIds;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.appId,
    required this.otherUserIds,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with ChannelEventHandler {
  List<BaseMessage> _messages = [];
  GroupChannel? _channel;

  @override
  void initState() {
    _loadMessages();
    SendbirdSdk().addChannelEventHandler('chat_event', this);

    super.initState();
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler('chat_event');
    super.dispose();
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    setState(() {
      _messages.add(message);
    });

    super.onMessageReceived(channel, message);
  }

  void _loadMessages() async {
    try {
      // init + connect
      final sendBird = SendbirdSdk(
        appId: widget.appId,
      );
      final _ = await sendBird.connect(widget.userId);

      // get any existing channel
      final query = GroupChannelListQuery()
        ..limit = 1
        ..userIdsExactlyIn = widget.otherUserIds;

      List<GroupChannel> channels = await query.loadNext();

      GroupChannel aChannel;
      if (channels.isEmpty) {
        // Create new channel
        aChannel = await GroupChannel.createChannel(GroupChannelParams()
          ..userIds = widget.otherUserIds + [widget.userId]);
      } else {
        aChannel = channels[0];
      }

      // get message from channel
      List<BaseMessage> message = await aChannel.getMessagesByTimestamp(
        DateTime.now().millisecondsSinceEpoch * 1000,
        MessageListParams(),
      );

      // set the data

      setState(() {
        _messages = message;
        _channel = aChannel;
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  ChatUser asDashChatUser(User? user) {
    if (user == null) {
      return ChatUser(
        id: "",
        profileImage: '',
      );
    }
    return ChatUser(
        id: user.userId,
        firstName: user.nickname.isNotEmpty ? user.nickname : null,
        profileImage: user.profileUrl!.isNotEmpty ? user.profileUrl : null);
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    return [
      for (BaseMessage sbm in messages)
        ChatMessage(
          text: sbm.message,
          user: asDashChatUser(sbm.sender),
          createdAt: DateTime.now(),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.userId == 'John' ? 'John' : 'William'} Chat with ${widget.userId == 'John' ? 'William' : 'John'}'),
      ),
      body: DashChat(
        // currentUser: ChatUser(
        //   id: widget.userId,
        //   profileImage: '',
        // ),
        currentUser: asDashChatUser(SendbirdSdk().currentUser),
        onSend: (newMessage) {
          print('newMessage=> ${newMessage.text}');
        },
        messages: asDashChatMessages(_messages),
      ),
    );
  }
}
