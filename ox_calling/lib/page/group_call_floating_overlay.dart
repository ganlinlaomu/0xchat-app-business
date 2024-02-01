import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_calling/utils/widget_util.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

///Title: group_call_floating_overlay
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2024/2/1 10:35
class GroupCallFloatingOverlay extends StatefulWidget {
  final UserDB userDB;
  final List<UserDB> otherInvitee;

  const GroupCallFloatingOverlay({Key? key, required this.userDB, required this.otherInvitee}) : super(key: key);

  @override
  GroupCallFloatingOverlayState createState() => GroupCallFloatingOverlayState();
}

class GroupCallFloatingOverlayState extends State<GroupCallFloatingOverlay> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.px),
      padding: EdgeInsets.all(16.px),
      decoration: BoxDecoration(
        color: ThemeColor.color180,
        borderRadius: BorderRadius.circular(24.px),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonImage(iconName: 'icon_user_default.png', width: 36.px, height: 36.px),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  abbrText('Satoshi', 16.sp, Colors.white),
                  abbrText('Invites you to a group call...', 12.sp, Colors.white),
                ],
              )).setPadding(EdgeInsets.symmetric(horizontal: 8.px)),
              SizedBox(width: 14.px),
              CommonImage(iconName: 'icon_call_end.png', width: 40.px, height: 40.px, package: 'ox_calling'),
              SizedBox(width: 10.px),
              CommonImage(iconName: 'icon_call_accept.png', width: 40.px, height: 40.px, package: 'ox_calling'),
              abbrText('3 people on the call:', 14.sp, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

}
