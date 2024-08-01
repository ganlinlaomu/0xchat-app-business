import 'package:flutter/material.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/model/chat_session_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';

///Title: chat_session_utils
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/4/1 07:58
class ChatSessionUtils {
  static String getChatName(ChatSessionModel model) {
    String showName = '';
    switch (model.chatType) {
      case ChatType.chatChannel:
        showName = Channels.sharedInstance.channels[model.chatId]?.name ?? '';
        if (showName.isEmpty) showName = Channels.encodeChannel(model.chatId, null, null);
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        showName = Account.sharedInstance.userCache[model.getOtherPubkey]?.value.name ?? '';
        break;
      case ChatType.chatGroup:
        showName = Groups.sharedInstance.groups[model.chatId]?.name ?? '';
        if (showName.isEmpty) showName = Groups.encodeGroup(model.chatId, null, null);
        break;
      case ChatType.chatRelayGroup:
        showName = RelayGroup.sharedInstance.groups[model.chatId]?.name ?? '';
        if (showName.isEmpty) showName = RelayGroup.sharedInstance.encodeGroup(model.chatId) ?? '';
        break;
      case ChatType.chatNotice:
        showName = model.chatName ?? '';
        break;
    }
    return showName;
  }

  static String getChatIcon(ChatSessionModel model) {
    String showPicUrl = '';
    switch (model.chatType) {
      case ChatType.chatChannel:
        showPicUrl = Channels.sharedInstance.channels[model.chatId]?.picture ?? '';
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        showPicUrl = Account.sharedInstance.userCache[model.getOtherPubkey]?.value.picture ?? '';
        break;
      case ChatType.chatGroup:
        showPicUrl = Groups.sharedInstance.groups[model.chatId]?.picture ?? '';
        break;
      case ChatType.chatRelayGroup:
        showPicUrl = RelayGroup.sharedInstance.groups[model.chatId]?.picture ?? '';
        break;
    }
    return showPicUrl;
  }

  static String getChatDefaultIcon(ChatSessionModel model) {
    String localAvatarPath = '';
    switch (model.chatType) {
      case ChatType.chatChannel:
        localAvatarPath = 'icon_group_default.png';
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
        localAvatarPath = 'user_image.png';
        break;
      case ChatType.chatGroup:
      case ChatType.chatRelayGroup:
        localAvatarPath = 'icon_group_default.png';
        break;
      case ChatType.chatNotice:
        localAvatarPath = 'icon_request_avatar.png';
        break;
    }
    return localAvatarPath;
  }

  static bool getChatMute(ChatSessionModel model) {
    bool isMute = false;
    switch (model.chatType) {
      case ChatType.chatChannel:
        ChannelDBISAR? channelDB = Channels.sharedInstance.channels[model.chatId];
        if (channelDB != null) {
          isMute = channelDB.mute ?? false;
        }
        break;
      case ChatType.chatSingle:
      case ChatType.chatSecret:
      UserDBISAR? tempUserDB = Account.sharedInstance.userCache[model.chatId]?.value;
        if (tempUserDB != null) {
          isMute = tempUserDB.mute ?? false;
        }
        break;
      case ChatType.chatGroup:
        GroupDBISAR? groupDB = Groups.sharedInstance.groups[model.chatId];
        if (groupDB != null) {
          isMute = groupDB.mute;
        }
        break;
      case ChatType.chatRelayGroup:
        RelayGroupDB? relayGroupDB = RelayGroup.sharedInstance.groups[model.chatId];
        if (relayGroupDB != null) {
          isMute = relayGroupDB.mute;
        }
        break;
    }
    return isMute;
  }

  static Widget getTypeSessionView(int chatType, String chatId){
    String? iconName;
    switch (chatType) {
      case ChatType.chatChannel:
        iconName = 'icon_type_channel.png';
        break;
      case ChatType.chatGroup:
        iconName = 'icon_type_private_group.png';
        break;
      case ChatType.chatRelayGroup:
        RelayGroupDB? relayGroupDB = RelayGroup.sharedInstance.groups[chatId];
        if (relayGroupDB != null){
          if (relayGroupDB.closed){
            iconName = 'icon_type_close_group.png';
          } else {
            iconName = 'icon_type_open_group.png';
          }
        }
        break;
      default:
        break;
    }
    Widget typeSessionWidget = iconName != null ? CommonImage(iconName: iconName, size: 24.px, package: 'ox_chat',useTheme: true,) : SizedBox();
    return typeSessionWidget;
  }
}
