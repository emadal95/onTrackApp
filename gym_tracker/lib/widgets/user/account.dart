import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker/icons/tabs_icons.dart';
import 'package:gym_tracker/providers/user_provider.dart';
import 'package:gym_tracker/widgets/user/personal_info_editor.dart';
import 'package:gym_tracker/widgets/user/user_stats_editor.dart';
import 'package:gym_tracker/widgets/user/user_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class Account extends StatefulWidget {
  UserProvider user;
  var viewSize;

  Account(this.user, this.viewSize);

  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var _currentPageIndex = 0;
  final pageController = PageController(initialPage: 0);

  Future<void> onPictureSourcePicked(ImageSource source) async {
    Navigator.of(context).pop();

    final avatarPic = await ImagePicker.pickImage(
      source: source,
      maxWidth: MediaQuery.of(context).size.width / 2,
    );
    
    if (avatarPic != null) {
      final filesDirectory = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(avatarPic.path);
      final filePath = path.join(filesDirectory.path, fileName);
      final savedImage = await avatarPic.copy(filePath);

      widget.user.setImageUrl(filePath);
    }
  }

  Widget _buildAvatar() {
    return FittedBox(
      fit: BoxFit.contain,
      child: Center(
        child: GestureDetector(
          onTap: _onAvatarTap,
          child: UserAvatar(
            image: widget.user.image,
            radius: 80,
          ),
        ),
      ),
    );
  }

  void _onAvatarTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 6),
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildPictureSourceBtn('Take Photo', ImageSource.camera),
            _buildPictureSourceBtn('Library', ImageSource.gallery)
          ],
        ),
      ),
    );
  }

  Widget _buildPictureSourceBtn(String title, ImageSource thisSource) {
    return Container(
      margin: EdgeInsets.all(4),
      child: RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => onPictureSourcePicked(thisSource),
        child: Container(
          width: double.infinity,
          height: 50,
          child: Center(
            child: AutoSizeText(
              title,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPageDot(idx, iconData, iconSize, distance) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (idx == _currentPageIndex)
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ),
        SizedBox(
          height: distance,
        ),
        Icon(
          iconData,
          color: (idx == _currentPageIndex)
              ? Theme.of(context).primaryColor
              : Colors.grey,
          size: iconSize,
        )
      ],
    );
  }

  void onPageChanged(newPageIdx) {
    setState(() {
      _currentPageIndex = newPageIdx;
    });
  }

  Widget _buildPageView() {
    var pageViewSize = widget.viewSize * 0.55;

    return Container(
      width: double.infinity,
      child: PageView(
        onPageChanged: (idx) => onPageChanged(idx),
        scrollDirection: Axis.horizontal,
        controller: pageController,
        children: <Widget>[
          PersonalInfoEditor(pageViewSize, widget.user),
          UserStatsEditor(pageViewSize, widget.user),
        ],
      ),
    );
  }

  Widget _buildFooterBar() {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Container(
        padding: EdgeInsets.only(top: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getPageDot(0, Icons.account_circle, 17.0, 5.0),
            SizedBox(
              width: 10,
            ),
            _getPageDot(1, TabsIcons.balance_scale, 13.0, 7.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: _buildAvatar(),
          ),
          Flexible(
            flex: 8,
            child: _buildPageView(),
          ),
          Flexible(child: _buildFooterBar(), flex: 1),
        ],
      ),
    );
  }
}
