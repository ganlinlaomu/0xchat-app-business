import 'package:flutter/material.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_image.dart';

class WalletClaimWidget extends StatefulWidget {
  final ValueNotifier<bool>? shareController;
  const WalletClaimWidget({super.key, this.shareController});

  @override
  State<WalletClaimWidget> createState() => WalletClaimWidgetState();
}

class WalletClaimWidgetState extends State<WalletClaimWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.px),
      height: 52.px,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.45, 0.55],
          begin: const Alignment(-0.5, -20),
          end: const Alignment(0.5, 20),
          colors: [
            ThemeColor.gradientMainEnd.withOpacity(0.24),
            ThemeColor.gradientMainStart.withOpacity(0.24),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CommonImage(
                iconName: 'nuts_icon.png',
                width: 32.px,
                height: 32.px,
                package: 'ox_wallet',
              ).setPaddingOnly(right: 12.px),
              Text(
                'You have 3 nuts zaps to Cliam',
                style: TextStyle(
                    color: ThemeColor.color0,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
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
    );
  }
}
