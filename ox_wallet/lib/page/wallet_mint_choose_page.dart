import 'package:flutter/material.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_wallet/services/ecash_manager.dart';
import 'package:cashu_dart/cashu_dart.dart';
import 'package:ox_wallet/widget/mint_indicator_item.dart';

class WalletMintChoosePage extends StatefulWidget {
  final ValueChanged<IMint>? onChanged;
  const WalletMintChoosePage({super.key, this.onChanged});

  @override
  State<WalletMintChoosePage> createState() => _WalletMintChoosePageState();
}

class _WalletMintChoosePageState extends State<WalletMintChoosePage> {
  List<IMint> mintItems = [];

  @override
  void initState() {
    mintItems = EcashManager.shared.mintList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.color190,
      appBar: CommonAppBar(
        title: 'Select Mint',
        centerTitle: true,
        useLargeTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 12.px,),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => MintItem(mint: mintItems[index],onChanged: _chooseMint,),
            separatorBuilder: (context,index) => SizedBox(height: 12.px,),
            itemCount: mintItems.length,
          ),
        ],
      ).setPadding(EdgeInsets.symmetric(horizontal: 24.px,vertical: 12.px)),
    );
  }

  Future<void> _chooseMint(IMint? mint) async {
    if(mint == null) return;
    if(context.mounted){
      OXNavigator.pop(context);
      if (widget.onChanged != null) {
        widget.onChanged!.call(mint);
        return;
      }
    }
  }
}