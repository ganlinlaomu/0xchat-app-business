import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:ui';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:chatcore/chat-core.dart';
import 'package:flutter/material.dart';
import 'package:ox_common/utils/image_picker_utils.dart';
import 'package:ox_common/widgets/common_network_image.dart';
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
import 'package:video_compress/video_compress.dart';

import '../enum/moment_enum.dart';
import 'moments/create_moments_page.dart';
import 'moments/public_moments_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with
        AutomaticKeepAliveClientMixin,
        OXUserInfoObserver,
        WidgetsBindingObserver,
        OXRelayObserver,
        CommonStateViewMixin {
  final RefreshController _refreshController = RefreshController();
  late Image _placeholderImage;

  List<ChannelModel?> _channelModelList = [];
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    // OXUserInfoManager.sharedInstance.addObserver(this);
    // OXRelayManager.sharedInstance.addObserver(this);
    // ThemeManager.addOnThemeChangedCallback(onThemeStyleChange);
    // Localized.addLocaleChangedCallback(onLocaleChange);
    // WidgetsBinding.instance.addObserver(this);
    // String localAvatarPath = 'assets/images/icon_group_default.png';
    // _placeholderImage = Image.asset(
    //   localAvatarPath,
    //   fit: BoxFit.cover,
    //   width: Adapt.px(76),
    //   height: Adapt.px(76),
    //   package: 'ox_common',
    // );
    // _getHotChannels(type: _currentIndex.value + 1,context: context);
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
    double mm = boundingTextSize(
            Localized.text('ox_discovery.discovery'),
            TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Adapt.px(20),
                color: ThemeColor.titleColor))
        .width;
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
              iconName: "moment_add_icon.png",
              width: Adapt.px(24),
              height: Adapt.px(24),
              color: ThemeColor.color100,
              package: 'ox_discovery',
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => _buildBottomDialog());
            },
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Adapt.px(20),
                      color: ThemeColor.titleColor),
                  colors: [
                    ThemeColor.gradientMainStart,
                    ThemeColor.gradientMainEnd
                  ]),
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
      body: OXSmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefresh,
        onLoading: null,
        child: const SingleChildScrollView(
          child: Column(
            children: [
              // _topSearch(),
              PublicMomentsPage(),
              // commonStateViewWidget(context, bodyWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return ListView.builder(
      padding: EdgeInsets.only(
          left: Adapt.px(24), right: Adapt.px(24), bottom: Adapt.px(120)),
      primary: false,
      controller: null,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: hotChatViews(),
        );
      },
    );
  }

  void _onRefresh() async {
    if (_currentIndex.value == 2) {
      _getLatestChannelList();
    } else {
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(Adapt.px(16))),
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
                                      child: OXCachedNetworkImage(
                                        height: Adapt.px(100),
                                        imageUrl: item?.picture ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: (context, url, error) =>
                                            _placeholderImage,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 6, sigmaY: 6),
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: Adapt.px(20), top: Adapt.px(53)),
                                padding: EdgeInsets.all(Adapt.px(1)),
                                decoration: BoxDecoration(
                                  color: ThemeColor.color190,
                                  border: Border.all(
                                      color: ThemeColor.color180,
                                      width: Adapt.px(3)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Adapt.px(8))),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Adapt.px(4))),
                                  child: OXCachedNetworkImage(
                                    imageUrl: item?.picture ?? '',
                                    height: Adapt.px(60),
                                    width: Adapt.px(60),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        _placeholderImage,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Adapt.px(10),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Adapt.px(16), right: Adapt.px(16)),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              item?.channelName ?? '',
                              maxLines: 1,
                              style: TextStyle(
                                  color: ThemeColor.color0,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: Adapt.px(20),
                            margin: EdgeInsets.only(
                                left: Adapt.px(16), right: Adapt.px(16)),
                            alignment: Alignment.bottomLeft,
                            child: FutureBuilder(
                                future: _getCreator(item?.owner ?? ''),
                                builder: (context, snapshot) {
                                  return Text(
                                    '${Localized.text('ox_common.by')} ${snapshot.data}',
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
                                initialData: const [].cast<String>(),
                                future: _getChannelMembersAvatars(
                                    item?.latestChatUsers ?? []),
                                builder: (context, snapshot) {
                                  List<String> avatars = snapshot.data ?? [];
                                  return avatars.isEmpty
                                      ? const SizedBox()
                                      : _buildAvatarStack(avatars);
                                },
                              ),
                              item?.msgCount != null
                                  ? Expanded(
                                      child: Text(
                                        '${item?.msgCount} ${Localized.text('ox_discovery.msg_count')}',
                                        style: TextStyle(
                                          fontSize: Adapt.px(13),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ).setPadding(EdgeInsets.only(
                              bottom: Adapt.px(item?.msgCount != null ||
                                      item?.latestChatUsers != null
                                  ? 20
                                  : 0))),
                        ],
                      )),
                )),
            onTap: () async {
              bool isLogin = OXUserInfoManager.sharedInstance.isLogin;
              if (isLogin) {
                LogUtil.e("groupId : ${item?.channelId}");
                OXModuleService.pushPage(
                    context, 'ox_chat', 'ChatGroupMessagePage', {
                  'chatId': item?.channelId,
                  'chatName': item?.channelName,
                  'chatType': ChatType.chatChannel,
                  'time': item?.createTimeMs,
                  'avatar': item?.picture,
                  'groupId': item?.channelId,
                });
              } else {
                await OXModuleService.pushPage(
                    context, "ox_login", "LoginPage", {});
              }
            },
          ));
    }).toList();
  }

  Widget _buildAvatarStack(List<String> avatarURLs) {
    final avatarCount = min(avatarURLs.length, 4);
    avatarURLs = avatarURLs.sublist(0, avatarCount);

    double maxWidth = Adapt.px(32);
    if (avatarURLs.length > 1) {
      maxWidth = Adapt.px(avatarURLs.length * 26);
    }

    return Container(
      margin: EdgeInsets.only(
        right: Adapt.px(10),
      ),
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: Adapt.px(32),
      ),
      child: AvatarStack(
        settings: RestrictedPositions(
            // maxCoverage: 0.1,
            // minCoverage: 0.2,
            align: StackAlign.left,
            laying: StackLaying.first),
        borderColor: ThemeColor.color180,
        height: Adapt.px(32),
        avatars: avatarURLs
            .map((url) {
              if (url.isEmpty) {
                return const AssetImage('assets/images/user_image.png',
                    package: 'ox_common');
              } else {
                return OXCachedNetworkImageProviderEx.create(
                  context,
                  url,
                  height: Adapt.px(26),
                );
              }
            })
            .toList()
            .cast<ImageProvider>(),
      ),
    );
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
              child: CommonImage(
                  iconName: 'icon_chat_search.png',
                  width: Adapt.px(24),
                  height: Adapt.px(24),
                  fit: BoxFit.cover,
                  package: 'ox_chat'),
            ),
            SizedBox(
              width: Adapt.px(8),
            ),
            Text(
              Localized.text('ox_chat.search'),
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

  static Size boundingTextSize(String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
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
            style: TextStyle(
                color: ThemeColor.titleColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
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

  Future<void> _getHotChannels(
      {required int type, BuildContext? context}) async {
    List<ChannelModel> channels =
        await getHotChannels(type: type, context: context);

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

  Future<List<String>> _getChannelMembersAvatars(List<String> pubKeys) async {
    List<String?> avatars = [];
    List<UserDB> users = await _getChannelMembers(pubKeys);
    avatars.addAll(users.map((e) => e.picture).toList());
    return avatars.where((e) => e != null).toList().cast<String>();
  }

  Future<String> _getCreator(String pubKey) async {
    List<String> pubKeys = [pubKey];
    List<UserDB> users = await _getChannelMembers(pubKeys);
    return users.first.name ?? '';
  }

  Future<void> _getLatestChannelList() async {
    try {
      OXLoading.show(status: Localized.text('ox_common.loading'));
      List<ChannelDB> channelDBList =
          await Channels.sharedInstance.getChannelsFromRelay();
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
        color: ThemeColor.color180,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            'Camera',
            index: 0,
            onTap: () {
              OXNavigator.pop(context);
              _openCamera(context);
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            'Choose Image',
            index: 1,
            onTap: () {
              OXNavigator.pop(context);
              _goToAlbum(context, 1);
              // OXNavigator.presentPage(
              //   context,
              //       (context) => CreateMomentsPage(type:EMomentType.video),
              // );
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          _buildItem(
            'Choose Video',
            index: 1,
            onTap: () {
              OXNavigator.pop(context);
              _goToAlbum(context, 2);
              // OXNavigator.presentPage(
              //   context,
              //       (context) => CreateMomentsPage(type:EMomentType.video),
              // );
            },
          ),
          Divider(
            color: ThemeColor.color170,
            height: Adapt.px(0.5),
          ),
          Container(
            height: Adapt.px(8),
            color: ThemeColor.color190,
          ),
          _buildItem(Localized.text('ox_common.cancel'), index: 3, onTap: () {
            OXNavigator.pop(context);
          }),
          SizedBox(
            height: Adapt.px(21),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title,
      {required int index, GestureTapCallback? onTap}) {
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
            fontWeight: FontWeight.w400,
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
    setState(() {});
  }

  @override
  void didDeleteRelay(RelayModel? relayModel) {
    setState(() {});
  }

  @override
  void didRelayStatusChange(String relay, int status) {
    setState(() {});
  }

  onThemeStyleChange() {
    if (mounted) setState(() {});
  }

  onLocaleChange() {
    if (mounted) setState(() {});
  }

  Future<void> _goToAlbum(BuildContext context, int type) async {
    final isVideo = type == 2;
    final messageSendHandler = isVideo ? _dealWithVideo : _dealWithPicture;

    final res = await ImagePickerUtils.pickerPaths(
      galleryMode: isVideo ? GalleryMode.video : GalleryMode.image,
      selectCount: 9,
      showGif: false,
      compressSize: 1024,
    );

    List<File> fileList = [];
    await Future.forEach(res, (element) async {
      final entity = element;
      final file = File(entity.path ?? '');
      fileList.add(file);
    });

    messageSendHandler(context, fileList);
  }

  Future _dealWithPicture(BuildContext context, List<File> images) async {
    List<String> imageList = [];
    for (final result in images) {
      String fileName = Path.basename(result.path);
      fileName = fileName.substring(13);
      imageList.add(result.path.toString());
    }

    OXNavigator.presentPage(
      context,
      (context) =>
          CreateMomentsPage(type: EMomentType.picture, imageList: imageList),
    );
  }

  Future _dealWithVideo(BuildContext context, List<File> images) async {
    for (final result in images) {
      // OXLoading.show();
      final uint8list = await VideoCompress.getByteThumbnail(result.path,
          quality: 50, // default(100)
          position: -1 // default(-1)
          );
      final image = await decodeImageFromList(uint8list!);
      Directory directory = await getTemporaryDirectory();
      String thumbnailDirPath = '${directory.path}/thumbnails';
      await Directory(thumbnailDirPath).create(recursive: true);

      // Save the thumbnail to a file
      String thumbnailPath = '$thumbnailDirPath/thumbnail.jpg';
      File thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(uint8list);

      OXNavigator.presentPage(
        context,
        (context) => CreateMomentsPage(
          type: EMomentType.video,
          videoPath: result.path.toString(),
          videoImagePath: thumbnailPath,
        ),
      );
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    Media? res = await ImagePickerUtils.openCamera(
      cameraMimeType: CameraMimeType.photo,
      compressSize: 1024,
    );
    if(res == null) return;
    final file = File(res.path ?? '');
    _dealWithPicture(context,[file]);
  }
}
