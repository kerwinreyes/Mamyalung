import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mamyalung/extension.dart';
import 'package:mamyalung/materials.dart';
class StudCard extends StatefulWidget {
  
  final bool isActive;
  final VoidCallback press;

  const StudCard({
    Key? key,
    this.isActive = true,
    required this.press,
  }) : super(key: key);
  @override
  _StudCardState createState() => _StudCardState();
}

class _StudCardState extends State<StudCard> {
  


  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: widget.press,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: widget.isActive ? kPrimaryColor : kBgDarkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "sdf",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: widget.isActive ? Colors.white : kTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: "sdf",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color:
                                          widget.isActive ? Colors.white : kTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'asdadasd',
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  color: widget.isActive ? Colors.white70 : null,
                                ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
                    'asd',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          height: 1.5,
                          color: widget.isActive ? Colors.white70 : null,
                        ),
                  )
                ],
              ),
            ).addNeumorphism(
              blurRadius: 15,
              borderRadius: 15,
              offset: Offset(5, 5),
              topShadowColor: Colors.white60,
              botShadowColor: Color(0xFF234395).withOpacity(0.15),
            ),
          ],
        ),
      ),
    );
  }
}

