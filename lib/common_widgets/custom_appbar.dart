import 'package:flutter/material.dart';

Image image = Image.network("");

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Image profilePic;
  final String username;
  final Widget status;
  final double height;
  final Color color;
  final Color backButtonColor;
  final IconButton backbutton;
  final int actionspacer;
  final TextStyle usernamestyle;
  final TextStyle statusstyle;
  final String lastseen;
  final Function onImagetab;

  @override
  Size get preferredSize => Size.fromHeight(height);

  CustomAppBar(
      {Key key,
      this.onImagetab,
      this.lastseen,
      this.backbutton,
      this.backButtonColor = Colors.white,
      this.color,
      this.usernamestyle,
      this.statusstyle,
      this.actionspacer = 1,
      this.height = 60,
      @required this.username,
      @required this.profilePic,
      @required this.status})
      : assert(profilePic != null, 'PP NULL'),
        assert(status != null, 'Status NULL'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          color: color,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2.0)]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: backbutton != null
                ? backbutton
                : BackButton(
                    color: backButtonColor,
                  ),
          ),
          GestureDetector(
            child: ClipRRect(
                borderRadius: new BorderRadius.circular(30.0),
                child: profilePic),
            onTap: onImagetab,
          ),
          SizedBox(
            width: 7.0,
          ),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    username,
                    style: usernamestyle != null
                        ? usernamestyle
                        : TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: status,
                  )
                ],
              )),
        ],
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: 0,
        bottom: 10,
        right: 8,
      ),
    );
  }
}
