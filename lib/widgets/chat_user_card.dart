import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../main.dart';
import '../model/chat_user.dart';

class chatusercard extends StatefulWidget {
  final ChatUser user;

  const chatusercard({Key? key, required this.user}) : super(key: key);

  @override
  State<chatusercard> createState() => _chatusercardState();
}

class _chatusercardState extends State<chatusercard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      child: InkWell(
        onTap: () {},
        child: ListTile(
            // leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .03),
              child: CachedNetworkImage(
                width: mq.height * .055,
                height: mq.height * .055,
                //fit: BoxFit.fill,
                imageUrl: widget.user.image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
            title: Text(widget.user.name),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(10)),
            )
            // trailing: Text(
            //   "12:00 PM",
            //   style: TextStyle(color: Colors.black54),
            // ),
            ),
      ),
    );
  }
}
