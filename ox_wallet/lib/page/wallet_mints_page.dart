import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';

import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';

import '../../../utils/widget_tool.dart';

class WalletMintsPage extends StatefulWidget {
  const WalletMintsPage({Key? key}) : super(key: key);

  @override
  WalletMintsPageState createState() => WalletMintsPageState();
}

class WalletMintsPageState extends State<WalletMintsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        useLargeTitle: false,
        centerTitle: true,
        title: 'Mints',
        backgroundColor: ThemeColor.color190,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _mintListWidget().setPaddingOnly(top: 12.px, bottom: 24.px),
            CommonButton.themeButton(onTap: () {}, text: 'Add Mint'),
          ],
        ).setPadding(
          EdgeInsets.symmetric(horizontal: 24.px),
        ),
      ),
    );
  }

  Widget _mintListWidget() {
    return labelWidgetWrapWidget(
      widget: Column(
        children: [
          labelWidget(title: 'mint.tangjinxing.com', subTitle: '99 Sats'),
        ],
      ),
    );
  }

  Widget labelWidget({
    bool showArrow = true,
    String title = '',
    String subTitle = '',
    bool showDivider = false,
    Widget? rightWidget,
    Function? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Container(
        height: 58.px,
        padding: EdgeInsets.symmetric(
          horizontal: 16.px,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 16.px,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                        color: ThemeColor.color100,
                        fontSize: 14.px,
                      ),
                    ),
                  ],
                ),
                CommonImage(
                  iconName: 'icon_arrow_more.png',
                  width: 24.px,
                  height: 24.px,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
