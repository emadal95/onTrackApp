import 'package:flutter/material.dart';

class QuickAddIcons extends StatefulWidget {
  Function onIconPicked;
  List<IconData> iconsData;
  IconData pickedIcon;

  QuickAddIcons({@required this.onIconPicked, @required this.iconsData, this.pickedIcon});

  @override
  _QuickAddIconsState createState() => _QuickAddIconsState();
}

class _QuickAddIconsState extends State<QuickAddIcons> {
  List<IconData> icons;
  IconData pickedIcon;
  
  @override
  void initState() {
    icons = widget.iconsData;
    pickedIcon = (widget.pickedIcon != null) ? widget.pickedIcon : icons[0];
    super.initState();
  }

  void _onIconSelected(IconData icon) {
    setState(() {
      pickedIcon = icon;
    });
    widget.onIconPicked(icon);
  }

  Widget _buildIconCircle(IconData icon) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 2,
          color: (icon.codePoint == pickedIcon.codePoint)
              ? Theme.of(context).accentColor
              : Colors.transparent,
        ),
      ),
      child: GestureDetector(
        onTap: () => _onIconSelected(icon),
        child: CircleAvatar(
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              child: Text("Pick icon", style: Theme.of(context).textTheme.caption,),
            ),
            GridView.builder(
              itemBuilder: (ctx, i) => _buildIconCircle(icons[i]),
              itemCount: icons.length,
              //physics: ScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (icons.length / 2).ceil(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1),
            ),
          ],
        ),
      ),
    );
  }
}
