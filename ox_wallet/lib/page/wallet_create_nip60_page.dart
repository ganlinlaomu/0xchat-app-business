import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_wallet/page/wallet_home_page.dart';

class WalletCreateNip60Page extends StatefulWidget {
  const WalletCreateNip60Page({super.key});

  @override
  State<WalletCreateNip60Page> createState() => WalletCreateNip60PageState();
}

class WalletCreateNip60PageState extends State<WalletCreateNip60Page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ThemeColor.color200,
        appBar: CommonAppBar(
          backgroundColor: ThemeColor.color200,
        ),
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {},
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                ThemeColor.gradientMainEnd,
                                ThemeColor.gradientMainStart,
                              ],
                            ).createShader(Offset.zero & bounds.size);
                          },
                          child: Text(
                            'Create nip60 wallet',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 32.px,
                            ),
                          ),
                        ),
                      ),
                    ).setPadding(EdgeInsets.symmetric(vertical: 28.px)),
                    labelWrapWidget(
                        title: 'Mints',
                        subTitle: '2',
                        tips: 'These are the mints you are comfortable using.',
                    ),
                    labelWrapWidget(
                        title: 'Relays',
                        subTitle: 'Add',
                        tips:
                            'These are the relays where your ecash will be stored.',),
                    ThemeButton(text: 'Create',height: 48.px,onTap: (){
                      OXNavigator.pushPage(context, (context) => WalletHomePage());
                    },),
                  ],
                ),
              ),
            ],
          ),
        ).setPadding(EdgeInsets.symmetric(horizontal: 30.px)),
      ),
    );
  }

  Widget labelWrapWidget({
    required String title,
    required String subTitle,
    required String tips,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget(title: title, subTitle: subTitle),
        Text(
          tips,
          style: TextStyle(
            color: ThemeColor.color100,
            fontSize: 12.px,
            fontWeight: FontWeight.w400,
          ),
        ).setPaddingOnly(top: 12.px),
      ],
    ).setPaddingOnly(bottom: 30.px);
  }

  Widget labelWidget({
    bool showArrow = true,
    String title = '',
    String subTitle = '',
    Widget? rightWidget,
    Function? onTap,
  }) {
    Widget arrowWidget() {
      if (rightWidget != null) return rightWidget;
      if (!showArrow) return const SizedBox();
      return CommonImage(
        iconName: 'icon_arrow_more.png',
        width: 24.px,
        height: 24.px,
      );
    }

    return Center(
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => onTap?.call(),
          child: Container(
            height: 52.px,
            padding: EdgeInsets.symmetric(
              horizontal: 16.px,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ThemeColor.color180,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: ThemeColor.color0,
                        fontSize: 16.px,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          subTitle,
                          style: TextStyle(
                            color: ThemeColor.color100,
                            fontSize: 14.px,
                          ),
                        ),
                        arrowWidget(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
