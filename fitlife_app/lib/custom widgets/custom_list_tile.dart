import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? tileColor;
  final IconButton? trailing;

  const CustomListTile({
    super.key,
    this.leadingIcon,
     this.title,
     this.subtitle,
     this.onTap,
    this.iconColor,
     this.tileColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tileColor
        ),
        child: ListTile(
          leading: Icon(leadingIcon, color: iconColor, size: 28),
          title: Text(
            title ?? '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(subtitle ?? '', style: TextStyle(fontSize: 14)),
          trailing: trailing,
          tileColor: tileColor,
          onTap: onTap,
          iconColor: iconColor,
        ),
      ),
    );
  }
}
