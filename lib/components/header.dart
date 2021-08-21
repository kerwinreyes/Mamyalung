import 'package:flutter/material.dart';
import 'package:mamyalung/responsive.dart';
import 'package:mamyalung/materials.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          // We need this back button on mobile only
          if (Responsive.isMobile(context)) BackButton(),
          IconButton(
            icon:Icon(Icons.delete),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.reply),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.reply_all),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.transfer_within_a_station),
            onPressed: () {},
          ),
          Spacer(),
          // We don't need print option on mobile
          if (Responsive.isDesktop(context))
            IconButton(
              icon:Icon(Icons.print),
              onPressed: () {},
            ),
          IconButton(
            icon: Icon(Icons.headphones),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}