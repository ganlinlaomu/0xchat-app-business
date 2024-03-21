import 'package:flutter/material.dart';
import 'package:ox_common/widgets/common_appbar.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';

import '../../enum/moment_enum.dart';
import '../widgets/moment_widget.dart';

class TopicMomentPage extends StatefulWidget {
  final String title;
  const TopicMomentPage({Key? key,required this.title}) : super(key: key);

  @override
  State<TopicMomentPage> createState() => _TopicMomentPageState();
}

class _TopicMomentPageState extends State<TopicMomentPage> {
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
    String content = "#0xchat it's worth noting that Satoshi Nakamoto's true identity remains unknown, and there is no publicly @Satoshi \nhttps://www.0xchat.com \nRead More";
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: CommonAppBar(
        backgroundColor: ThemeColor.color200,
        title: widget.title,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.px,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MomentWidget(type:EMomentType.picture,momentContent: content),
              MomentWidget(type:EMomentType.content,momentContent: content),
              MomentWidget(type:EMomentType.video,momentContent: content),
              MomentWidget(type:EMomentType.quote,momentContent: content),
            ],
          ),
        ),
      ),
    );
  }
}

