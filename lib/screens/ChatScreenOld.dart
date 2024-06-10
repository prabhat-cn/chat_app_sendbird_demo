import 'package:chat_demo/screens/CustomChannelEventHandler.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ChatScreenOld extends StatefulWidget {
  final String userId;
  final String appId;

  const ChatScreenOld({super.key, required this.userId, required this.appId});

  @override
  _ChatScreenOldState createState() => _ChatScreenOldState();
}

class _ChatScreenOldState extends State<ChatScreenOld> {
  final TextEditingController _messageController = TextEditingController();
  late GroupChannel _channel;
  List<BaseMessage> _messages = [];
  BaseMessage? _replyingTo;

  @override
  void initState() {
    super.initState();
    _initializeSendbird();
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler('chat_event');
    super.dispose();
  }

  void _initializeSendbird() async {
    try {
      SendbirdSdk(appId: widget.appId);
      SendbirdSdk().addChannelEventHandler(
          'chat_event',
          CustomChannelEventHandler(
              onMessageReceivedCallback: _onMessageReceived));
      _createOrJoinChannel();
    } catch (e) {
      print('Error initializing Sendbird: $e');
    }
  }

  void _createOrJoinChannel() async {
    try {
      GroupChannelListQuery query = GroupChannelListQuery()
        ..setUserIdsIncludeFilter(
            ['John', 'William'], GroupChannelListQueryType.and);

      List<GroupChannel> channels = await query.loadNext();
      if (channels.isNotEmpty) {
        _channel = channels.firstWhere((channel) => channel.name == 'ChatDemo',
            orElse: () => channels.first);
      } else {
        GroupChannelParams params = GroupChannelParams()
          ..userIds = ['John', 'William']
          ..name = 'ChatDemo';
        _channel = await GroupChannel.createChannel(params);
      }

      _loadMessages();
    } catch (e) {
      print('Error creating or joining channel: $e');
    }
  }

  void _loadMessages() async {
    try {
      List<BaseMessage> messages = await _channel.getMessagesByTimestamp(
        DateTime.now().millisecondsSinceEpoch,
        MessageListParams(),
      );
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  void _sendMessage(String message) async {
    try {
      UserMessageParams params = UserMessageParams(message: message);
      if (_replyingTo != null) {
        params.parentMessageId = _replyingTo!.messageId;
      }
      BaseMessage sentMessage = _channel.sendUserMessage(params);
      setState(() {
        _messages.insert(0, sentMessage);
        _replyingTo = null;
      });
      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _selectReplyMessage(BaseMessage message) {
    setState(() {
      _replyingTo = message;
    });
  }

  void _onMessageReceived(BaseChannel channel, BaseMessage message) {
    if (channel.channelUrl == _channel.channelUrl) {
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.userId == 'John' ? 'John' : 'William'} Chat with ${widget.userId == 'John' ? 'William' : 'John'}'),
      ),
      body: Column(
        children: [
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[300],
              child: Row(
                children: [
                  Expanded(
                    child: Text('Replying to: ${_replyingTo!.message}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _replyingTo = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                BaseMessage message = _messages[index];
                return GestureDetector(
                  onLongPress: () => _selectReplyMessage(message),
                  child: ListTile(
                    title: Text(message.message),
                    subtitle: Text(message.sender?.userId ?? 'Unknown'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Enter a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomChannelEventHandler extends ChannelEventHandler {
  final Function(BaseChannel, BaseMessage) onMessageReceivedCallback;

  CustomChannelEventHandler({required this.onMessageReceivedCallback});

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    onMessageReceivedCallback(channel, message);
  }

  @override
  void onChannelChanged(BaseChannel channel) {}

  @override
  void onChannelDeleted(String channelUrl, ChannelType channelType) {}

  @override
  void onChannelFrozen(BaseChannel channel) {}

  @override
  void onChannelHidden(BaseChannel channel) {}

  @override
  void onChannelParticipantCountChanged(List<OpenChannel> channels) {}

  @override
  void onChannelUnfrozen(BaseChannel channel) {}

  @override
  void onChannelUnreadCountChanged(List<GroupChannel> channels) {}

  @override
  void onMentionReceived(BaseChannel channel, BaseMessage message) {}

  @override
  void onMetaDataCreated(BaseChannel channel, Map<String, String> metaData) {}

  @override
  void onMetaDataDeleted(BaseChannel channel, List<String> keys) {}

  @override
  void onMetaDataUpdated(BaseChannel channel, Map<String, String> metaData) {}

  @override
  void onMetaCountersCreated(
      BaseChannel channel, Map<String, int> metaCounters) {}

  @override
  void onMetaCountersDeleted(BaseChannel channel, List<String> keys) {}

  @override
  void onMetaCountersUpdated(
      BaseChannel channel, Map<String, int> metaCounters) {}

  @override
  void onOperatorUpdated(BaseChannel channel) {}

  @override
  void onPinnedMessageUpdated(BaseChannel channel) {}

  @override
  void onReactionUpdated(BaseChannel channel, ReactionEvent event) {}

  @override
  void onTypingStatusUpdated(GroupChannel channel) {}

  @override
  void onUserBanned(BaseChannel channel, User user) {}

  @override
  void onUserEntered(OpenChannel channel, User user) {}

  @override
  void onUserExited(OpenChannel channel, User user) {}

  @override
  void onUserJoined(GroupChannel channel, User user) {}

  @override
  void onUserLeft(GroupChannel channel, User user) {}

  @override
  void onUserMuted(BaseChannel channel, User user) {}

  @override
  void onUserUnbanned(BaseChannel channel, User user) {}

  @override
  void onUserUnmuted(BaseChannel channel, User user) {}
}
