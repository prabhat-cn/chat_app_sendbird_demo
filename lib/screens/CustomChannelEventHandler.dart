import 'package:sendbird_sdk/sendbird_sdk.dart';

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
