import 'package:ox_localizable/ox_localizable.dart';

enum GroupType{
  channel,
  openGroup,
  privateGroup,
}

extension GroupTypeEx on GroupType{
  String get text {
    switch (this) {
      case GroupType.openGroup:
        return Localized.text('ox_discovery.group');
      case GroupType.privateGroup:
        return Localized.text('ox_chat.str_group_type_private');
      case GroupType.channel:
        return Localized.text('ox_discovery.channel');
    }
  }

  String get typeIcon {
    switch (this) {
      case GroupType.openGroup:
        return 'icon_group_open.png';
      case GroupType.privateGroup:
        return 'icon_group_private.png';
      case GroupType.channel:
        return 'icon_group_channel.png';
    }
  }

  String get groupDesc {
    switch (this) {
      case GroupType.openGroup:
        return Localized.text('ox_chat.str_group_open_description');
      case GroupType.privateGroup:
        return Localized.text('ox_chat.str_group_private_description');
      case GroupType.channel:
        return 'Channel description';
    }
  }
}