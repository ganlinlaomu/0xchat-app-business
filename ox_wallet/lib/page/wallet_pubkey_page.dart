import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/widgets/common_button.dart';
import 'package:ox_common/widgets/theme_button.dart';
import 'package:ox_wallet/page/wallet_mints_page.dart';

import '../utils/widget_tool.dart';

class WalletPubkeyPage extends StatefulWidget {
  const WalletPubkeyPage({super.key});

  @override
  State<WalletPubkeyPage> createState() => WalletPubkeyPageState();
}

class WalletPubkeyPageState extends State<WalletPubkeyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeColor.color190,
        appBar: CommonAppBar(
          title: 'Pubkey',
          centerTitle: true,
          useLargeTitle: false,
        ),
        body: Container(
          child: Column(
            children: [
              _walletNameWidget(),
              _descriptionWidget(),
              ThemeButton(text:'Save',height: 48.px,).setPaddingOnly(top: 24.px),
            ],
          ),
        ).setPadding(EdgeInsets.symmetric(horizontal: 24.px)));
  }

  Widget _walletNameWidget() {
    return labelWidgetWrapWidget(
      title: 'Wallet Name',
      widget:
          labelWidget(title: '#000001', showArrow: false),
    );
  }

  Widget _descriptionWidget() {
    return labelWidgetWrapWidget(
      title: 'Description',
      widget: Container(
        padding: EdgeInsets.all(16.px),
        child: Text(
            'This is description, This is description, This is description, This is description, This is description, This is description...'),
      ),
    );
  }
}
