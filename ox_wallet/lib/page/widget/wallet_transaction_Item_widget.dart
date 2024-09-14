import 'package:flutter/cupertino.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/widgets/common_image.dart';

class WalletTransactionItemWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? info;
  final String? iconName;
  final VoidCallback? onTap;
  const WalletTransactionItemWidget(
      {super.key,
        this.title,
        this.subTitle,
        this.info,
        this.onTap,
        this.iconName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.px),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonImage(
              iconName: iconName ?? 'icon_coin_send.png',
              size: 24.px,
              package: 'ox_wallet',
            ),
            SizedBox(
              width: 8.px,
            ),
            Expanded(
                child:
                _buildTile(title: title ?? '', subTitle: subTitle ?? '')),
            SizedBox(
              width: 8.px,
            ),
            _buildTile(
                title: info ?? '',
                subTitle: '',
                crossAxisAlignment: CrossAxisAlignment.end),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
      {required String title,
        required String subTitle,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.px,
            fontWeight: FontWeight.w400,
            color: ThemeColor.color0,
            height: 19.6.px / 14.px,
          ),
        ),
        Text(
          subTitle,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.px,
            fontWeight: FontWeight.w400,
            color: ThemeColor.color100,
            height: 16.8.px / 12.px,
          ),
        ),
      ],
    );
  }
}
