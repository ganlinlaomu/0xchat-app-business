import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_localizable/ox_localizable.dart';

///Title: widget_util
///Description: TODO(Fill in by oneself)
///Copyright: Copyright (c) 2021
///@author Michael
///CreateTime: 2023/7/27 17:30
extension UserDBToUIEx on UserDB {
  String getUserShowName() {
    final nickName = (this.nickName ?? '').trim();
    final name = (this.name ?? '').trim();
    if (nickName.isNotEmpty) return nickName;
    if (name.isNotEmpty) return name;
    return 'unknown';
  }
}

extension OXCallStr on String {
  String localized([Map<String, String>? replaceArg]) {
    String text = Localized.text('ox_calling.$this');
    if (replaceArg != null) {
      replaceArg.keys.forEach((key) {
        text = text.replaceAll(key, replaceArg[key] ?? '');
      });
    }
    return text;
  }
}

Widget abbrText(String content, double fontSize, Color txtColor, {TextAlign? textAlign, double? height, FontWeight fontWeight = FontWeight.w400}) {
  return Text(
    content,
    textAlign: textAlign,
    softWrap: true,
    style: TextStyle(fontSize: Adapt.px(fontSize), color: txtColor, fontWeight: fontWeight, height: height),
  );
}

Widget assetIcon(String iconName, double widthD, double heightD, {bool useTheme = false, BoxFit? fit}) {
  return CommonImage(
      useTheme: useTheme,
      iconName: iconName,
      width: Adapt.px(widthD),
      height: Adapt.px(heightD),
      fit: fit,
      package: 'ox_calling'
  );
}