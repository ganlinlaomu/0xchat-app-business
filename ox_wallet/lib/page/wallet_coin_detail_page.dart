import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_select_relay_page.dart';
import 'package:ox_wallet/page/wallet_backup_funds_page.dart';
import 'package:ox_wallet/page/wallet_mints_page.dart';
import 'package:ox_wallet/page/wallet_pubkey_page.dart';
import 'package:ox_wallet/page/widget/wallet_transaction_Item_widget.dart';

import '../utils/widget_tool.dart';
import '../widget/ecash_navigation_bar.dart';

class WalletCoinDetailPage extends StatefulWidget {
  const WalletCoinDetailPage({super.key});

  @override
  State<WalletCoinDetailPage> createState() => WalletCoinDetailPageState();
}

class WalletCoinDetailPageState extends State<WalletCoinDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: 'USD',
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _coinPriceWidget(),
                  _replayWidget(),
                  WalletTransactionItemWidget(
                    title: '111',
                    subTitle: '2222',
                    info: '123',
                  ),
                ],
              ),
              Positioned(
                left: 51.px,
                right: 51.px,
                bottom: 30.px,
                height: 68.px,
                child: const EcashNavigationBar(),
              ),
            ],
          ),
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)));
  }

  Widget _coinPriceWidget() {
    return Center(
      child: Column(
        children: [
          Text(
            '1023.2332',
            style: TextStyle(
              color: ThemeColor.color0,
              fontWeight: FontWeight.w600,
              fontSize: 32.px,
            ),
          ).setPaddingOnly(bottom: 8.px),
          Text(
            '\$1023.23',
            style: TextStyle(
              color: ThemeColor.color100,
              fontWeight: FontWeight.w400,
              fontSize: 14.px,
            ),
          ),
        ],
      ),
    ).setPaddingOnly(top: 12.px,bottom: 24.px);
  }

  Widget _replayWidget() {
    return Container(
      padding:EdgeInsets.only(bottom: 10.px),
      child: Text(
        'wss://relay.damus.io',
        style: TextStyle(
          color: ThemeColor.color0,
          fontSize: 16.px,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

