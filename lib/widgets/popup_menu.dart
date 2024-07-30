import 'package:flutter/material.dart';

enum Menu { preview, share, getLink, remove, download }

class MessagePopup extends StatefulWidget {
  const MessagePopup({super.key});

  @override
  State<MessagePopup> createState() => _MessagePopupState();
}

class _MessagePopupState extends State<MessagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomPopupMenu<Menu>(
                  items: [
                    const PopupMenuItem<Menu>(
                      value: Menu.preview,
                      child: ListTile(
                        leading: Icon(Icons.visibility_outlined),
                        title: Text('Preview'),
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.share,
                      child: ListTile(
                        leading: Icon(Icons.share_outlined),
                        title: Text('Share'),
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.getLink,
                      child: ListTile(
                        leading: Icon(Icons.link_outlined),
                        title: Text('Get link'),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<Menu>(
                      value: Menu.remove,
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Remove'),
                      ),
                    ),
                    const PopupMenuItem<Menu>(
                      value: Menu.download,
                      child: ListTile(
                        leading: Icon(Icons.download_outlined),
                        title: Text('Download'),
                      ),
                    ),
                  ],
                  onTap: (Menu item) {
                    // Handle the selected item here
                    print('Selected: $item');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPopupMenu<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final void Function(T) onTap;
  final AnimationStyle? animationStyle; // Optional animation style

  const CustomPopupMenu({
    Key? key,
    required this.items,
    required this.onTap,
    this.animationStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: const Icon(Icons.more_vert),
      onSelected: onTap,
      itemBuilder: (BuildContext context) => items,
      // Optionally pass animation style if needed
      // popupMenuAnimationStyle: animationStyle,
    );
  }
}