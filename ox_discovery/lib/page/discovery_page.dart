import 'dart:ui';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_theme/ox_theme.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:ox_common/log_util.dart';
import 'package:ox_common/mixin/common_state_view_mixin.dart';
import 'package:ox_common/model/channel_model.dart';
import 'package:ox_common/model/chat_type.dart';
import 'package:ox_common/model/relay_model.dart';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_common/utils/adapt.dart';
import 'package:ox_common/utils/theme_color.dart';
import 'package:ox_common/utils/widget_tool.dart';
import 'package:ox_common/utils/ox_relay_manager.dart';
import 'package:ox_common/utils/ox_userinfo_manager.dart';
import 'package:ox_common/widgets/common_image.dart';
import 'package:ox_common/widgets/common_pull_refresher.dart';
import 'package:ox_common/widgets/common_loading.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:ox_module_service/ox_module_service.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with AutomaticKeepAliveClientMixin, OXUserInfoObserver, WidgetsBindingObserver, OXRelayObserver, CommonStateViewMixin {
  final RefreshController _refreshController = RefreshController();
  late Image _placeholderImage;

  List<ChannelModel?> _channelModelList = [];
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    OXUserInfoManager.sharedInstance.addObserver(this);
    OXRelayManager.sharedInstance.addObserver(this);
    ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    WidgetsBinding.instance.addObserver(this);
    String localAvatarPath = 'assets/images/icon_group_default.png';
    _placeholderImage = Image.asset(
      localAvatarPath,
      fit: BoxFit.cover,
      width: Adapt.px(76),
      height: Adapt.px(76),
      package: 'ox_chat',
    );
    _getHotChannels(type: _currentIndex.value + 1,context: context);
  }

  @override
  void dispose() {
    OXUserInfoManager.sharedInstance.removeObserver(this);
    OXRelayManager.sharedInstance.removeObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  stateViewCallBack(CommonStateView commonStateView) {
    switch (commonStateView) {
      case CommonStateView.CommonStateView_None:
        break;
      case CommonStateView.CommonStateView_NetworkError:
        break;
      case CommonStateView.CommonStateView_NoData:
        break;
      case CommonStateView.CommonStateView_NotLogin:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double mm = boundingTextSize(Localized.text('ox_discovery.discovery'), TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: ThemeColor.titleColor)).width;
    return Scaffold(
      backgroundColor: ThemeColor.color200,
      appBar: AppBar(
        backgroundColor: ThemeColor.color200,
        elevation: 0,
        titleSpacing: 0.0,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: CommonImage(
              iconName: "nav_more_new.png",
              width: Adapt.px(24),
              height: Adapt.px(24),
              color: ThemeColor.color100,
            ),
            onTap: () {
              showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (context) => _buildBottomDialog());
            },
          ),
          SizedBox(
            width: Adapt.px(20),
          ),
          SizedBox(
            height: Adapt.px(24),
            child: GestureDetector(
              onTap: () {
                OXModuleService.invoke('ox_usercenter', 'showRelayPage', [context]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonImage(
                    iconName: 'icon_relay_connected_amount.png',
                    width: Adapt.px(24),
                    height: Adapt.px(24),
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: Adapt.px(4),
                  ),
                  Text(
                    '${OXRelayManager.sharedInstance.connectedCount}/${OXRelayManager.sharedInstance.relayAddressList.length}',
                    style: TextStyle(
                      fontSize: Adapt.px(14),
                      color: ThemeColor.color100,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: Adapt.px(24),
          ),
        ],
        title: Row(
          children: [
            SizedBox(
              width: Adapt.px(24),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: mm),
              child: GradientText(Localized.text('ox_discovery.discovery'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: ThemeColor.titleColor),
                  colors: [ThemeColor.gradientMainStart, ThemeColor.gradientMainEnd]),
            ),
            SizedBox(
              width: Adapt.px(24),
            ),
            SizedBox(
              width: Adapt.px(24),
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: Adapt.px(60),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  height: double.infinity,
                  color: ThemeColor.color200,
                  child: Column(
                    children: <Widget>[
                      _topSearch(),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: commonStateViewWidget(context, bodyWidget()),
      ),
    );
  }

  Widget bodyWidget() {
    return SafeArea(
      bottom: false,
      child: OXSmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefresh,
        onLoading: null,
        child: ListView.builder(
          padding: EdgeInsets.only(left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(120)),
          primary: false,
          controller: null,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: hotChatViews(),
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() async {
    if(_currentIndex.value == 2){
      _getLatestChannelList();
    }else{
      _getHotChannels(type: _currentIndex.value + 1);
    }
    _refreshController.refreshCompleted();
  }

  List<Widget> hotChatViews() {
    double width = MediaQuery.of(context).size.width;
    return _channelModelList.map((item) {
      return Container(
          margin: EdgeInsets.only(top: Adapt.px(16.0)),
          child: GestureDetector(
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Container(
                  width: Adapt.px(width - 24 * 2),
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                        color: ThemeColor.color190,
                        borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Stack(
                                children: [
                                  ClipRect(
                                    child: Transform.scale(
                                      alignment: Alignment.center,
                                      scale: 1.2,
                                      child: CachedNetworkImage(
                                        height: Adapt.px(100),
                                        imageUrl: item?.picture ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: (context,url,error) => _placeholderImage,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Adapt.px(20), top: Adapt.px(53)),
                                padding: EdgeInsets.all(Adapt.px(1)),
                                decoration: BoxDecoration(
                                  color: ThemeColor.color190,
                                  border: Border.all(color: ThemeColor.color180, width: Adapt.px(3)),
                                  borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
                                ),
                                height: Adapt.px(60),
                                width: Adapt.px(60),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(Adapt.px(4))),
                                  child: CachedNetworkImage(
                                    imageUrl: item?.picture ?? '',
                                    fit: BoxFit.cover,
                                    errorWidget: (context,url,error) => _placeholderImage,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Adapt.px(10),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              item?.channelName ?? '',
                              maxLines: 1,
                              style: TextStyle(color: ThemeColor.color0, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: Adapt.px(20),
                            margin: EdgeInsets.only(left: Adapt.px(16), right: Adapt.px(16)),
                            alignment: Alignment.bottomLeft,
                            child: FutureBuilder(
                                future: _getCreator(item?.owner ?? ''),
                                builder: (context, snapshot) {
                                  return Text(
                                    'By ${snapshot.data}',
                                    style: TextStyle(
                                      color: ThemeColor.color100,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                  );
                                }),
                          ),
                          SizedBox(
                            height: Adapt.px(12),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Adapt.px(16),
                              ),
                              FutureBuilder(
                                  future: _getChannelMembersAvatars(item?.latestChatUsers ?? []),
                                  builder: (context, snapshot) {
                                    List<String?> avatars = snapshot.data ?? [];
                                    return avatars.isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.only(
                                              right: Adapt.px(10),
                                            ),
                                            constraints: BoxConstraints(
                                                maxWidth: avatars.length > 1
                                                    ? avatars.length > 4
                                                        ? Adapt.px(4 * 26)
                                                        : Adapt.px(26 * avatars.length)
                                                    : Adapt.px(32),
                                                minWidth: Adapt.px(32)),
                                            child: AvatarStack(
                                              settings: RestrictedPositions(
                                                  // maxCoverage: 0.1,
                                                  // minCoverage: 0.2,
                                                  align: StackAlign.left,
                                                  laying: StackLaying.first),
                                              borderColor: ThemeColor.color180,
                                              height: Adapt.px(32),
                                              avatars: [
                                                for (var n = 0; n < avatars.length; n++)
                                                  if(avatars[n] != null && avatars[n]!.isNotEmpty) CachedNetworkImageProvider(avatars[n]!) else const AssetImage('assets/images/user_image.png',package: 'ox_common'),
                                              ],
                                            ),
                                          )
                                        : Container();
                                  }),
                              item?.msgCount != null ? Expanded(
                                child: Text(
                                  '${item?.msgCount} ${Localized.text('ox_discovery.msg_count')}',
                                  style: TextStyle(
                                    fontSize: Adapt.px(13),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ):Container(),
                            ],
                          ).setPadding(EdgeInsets.only(bottom: Adapt.px(item?.msgCount !=null || item?.latestChatUsers !=null ? 20 : 0))),
                        ],
                      )),
                )),
            onTap: () async {
              bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
              if (isLogin) {
                LogUtil.e("groupId : ${item?.channelId}");
                OXModuleService.pushPage(context, 'ox_chat', 'ChatGroupMessagePage', {
                  'chatId': item?.channelId,
                  'chatName': item?.channelName,
                  'chatType': ChatType.chatChannel,
                  'time': item?.createTimeMs,
                  'avatar': item?.picture,
                  'groupId': item?.channelId,
                });
              } else {
                await OXModuleService.pushPage(context, "ox_login", "LoginPage", {});
              }
            },
          ));
    }).toList();
  }

  Widget _topSearch() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      autofocus: true,
      onTap: () {
        OXModuleService.pushPage(context, 'ox_chat', 'SearchPage', {});
      },
      child: Container(
        width: width,
        margin: EdgeInsets.symmetric(
          horizontal: Adapt.px(24),
          vertical: Adapt.px(6),
        ),
        height: Adapt.px(48),
        decoration: BoxDecoration(
          color: ThemeColor.color190,
          borderRadius: BorderRadius.all(Radius.circular(Adapt.px(16))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: Adapt.px(18)),
              child: CommonImage(iconName: 'icon_chat_search.png', width: Adapt.px(24), height: Adapt.px(24), fit: BoxFit.cover, package: 'ox_chat'),
            ),
            SizedBox(
              width: Adapt.px(8),
            ),
            Text(
              Localized.text('ox_discovery.channel_search_hint_text'),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Adapt.px(15),
                color: ThemeColor.color150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Size boundingTextSize(String text, TextStyle style, {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr, text: TextSpan(text: text, style: style), maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  Widget headerViewForIndex(String leftTitle, int index) {
    return SizedBox(
      height: Adapt.px(45),
      child: Row(
        children: [
          SizedBox(
            width: Adapt.px(24),
          ),
          Text(
            leftTitle,
            style: TextStyle(color: ThemeColor.titleColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // CommonImage(
          //   iconName: "more_icon_z.png",
          //   width: Adapt.px(39),
          //   height: Adapt.px(8),
          // ),
          SizedBox(
            width: Adapt.px(16),
          ),
        ],
      ),
    );
  }

  Future<void> _getHotChannels({required int type,BuildContext? context}) async {
    List<ChannelModel> channels = await getHotChannels(type: type,context: context);

    if (channels.isEmpty) {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_NoData);
      });
    } else {
      setState(() {
        updateStateView(CommonStateView.CommonStateView_None);
        _channelModelList = channels;
      });
    }
  }

  Future<List<UserDB>> _getChannelMembers(List<String> pubKeys) async {
    List<UserDB> users = [];
    for (var element in pubKeys) {
      UserDB? user = await Account.sharedInstance.getUserInfo(element);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  Future<List<String?>> _getChannelMembersAvatars(List<String> pubKeys) async {
    List<String?> avatars = [];
    List<UserDB> users = await _getChannelMembers(pubKeys);
    avatars.addAll(users.map((e) => e.picture).toList());
    return avatars;
  }

  Future<String> _getCreator(String pubKey) async {
    List<String> pubKeys = [pubKey];
    List<UserDB> users = await _getChannelMembers(pubKeys);
    return users.first.name ?? '';
  }

  Future<void> _getLatestChannelList() async {
    try {
      OXLoading.show(status: Localized.text('ox_common.loading'));
      List<ChannelDB> channelDBList = await Channels.sharedInstance.getChannelsFromRelay();
      OXLoading.dismiss();
      List<ChannelModel> channels = channelDBList
          .map((channelDB) => ChannelModel.fromChannelDB(channelDB))
          .toList();
      if (channels.isEmpty) {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_NoData);
        });
      } else {
        setState(() {
          updateStateView(CommonStateView.CommonStateView_None);
          _channelModelList = channels;
        });
      }
    } catch (error, stack) {
      OXLoading.dismiss();
      LogUtil.e("get LatestChannel failed $error\r\n$stack");
    }
  }

  Widget _buildBottomDialog() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Adapt.px(12)),
        color:  ThemeColor.color160,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            Localized.text('ox_discovery.recommended_item'),
            index: 0,
            onTap: () {
              _currentIndex.value = 0;
              OXNavigator.pop(context);
              _getHotChannels(type: _currentIndex.value + 1,context: context);
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.popular_item'),
            index: 1,
            onTap: () {
              _currentIndex.value = 1;
              OXNavigator.pop(context);
              _getHotChannels(type: _currentIndex.value + 1,context: context);
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            Localized.text('ox_discovery.latest_item'),
            index: 2,
            onTap: () {
              _currentIndex.value = 2;
              OXNavigator.pop(context);
              // _getHotChannels(type: _currentIndex.value + 1,context: context);
              _getLatestChannelList();
            },
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_common.cancel'), index: 3, onTap: () {
            OXNavigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildItem(String title, {required int index, GestureTapCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: Adapt.px(56),
        child: Text(
          title,
          style: TextStyle(
            color: ThemeColor.color0,
            fontSize: Adapt.px(16),
            fontWeight: index == _currentIndex.value ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  void didLoginSuccess(UserDB? userInfo) {
    // TODO: implement didLoginSuccess
    setState(() {});
  }

  @override
  void didLogout() {
    // TODO: implement didLogout
    LogUtil.e("find.didLogout()");
    setState(() {});
  }

  @override
  void didSwitchUser(UserDB? userInfo) {
    // TODO: implement didSwitchUser
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void didAddRelay(RelayModel? relayModel) {
    setState(() {
    });
  }

  @override
  void didDeleteRelay(RelayModel? relayModel) {
    setState(() {
    });
  }

  @override
  void didRelayStatusChange(String relay, int status) {
    setState(() {});
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }
}
