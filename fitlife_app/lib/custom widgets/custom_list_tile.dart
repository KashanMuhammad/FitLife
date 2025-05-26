import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? tileColor;
  final IconButton? trailing;

  const CustomListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.tileColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    // Default subtitle style
    final defaultStyle = TextStyle(fontSize: 14, color: Colors.black87);

    // Red style
    final redStyle = TextStyle(fontSize: 14, color: Colors.red);

    // Blue style
    final blueStyle = TextStyle(fontSize: 14, color: Colors.blue);

    List<TextSpan> parseSubtitle(String text) {
      List<TextSpan> spans = [];

      // Use regex to match kcl and mins separately
      final regex = RegExp(r'(-?\d+\s?kcl)|(\d+\s?mins)|(\d+\s?hrs)', caseSensitive: false);
      final matches = regex.allMatches(text);

      int currentIndex = 0;

      for (final match in matches) {
        if (match.start > currentIndex) {
          spans.add(TextSpan(
            text: text.substring(currentIndex, match.start),
            style: defaultStyle,
          ));
        }

        final matchedText = text.substring(match.start, match.end);
        TextStyle matchStyle = defaultStyle;

        if (matchedText.contains('-') || matchedText.contains('hrs')) {
          matchStyle = redStyle;
        } else if (matchedText.contains('mins')) {
          matchStyle = blueStyle;
        }

        spans.add(TextSpan(
          text: matchedText,
          style: matchStyle,
        ));

        currentIndex = match.end;
      }

      // Add remaining text
      if (currentIndex < text.length) {
        spans.add(TextSpan(
          text: text.substring(currentIndex),
          style: defaultStyle,
        ));
      }

      return spans;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: tileColor,
        ),
        child: ListTile(
          leading: leading,
          title: Text(
            title ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: subtitle != null
              ? RichText(
            text: TextSpan(
              children: parseSubtitle(subtitle!),
            ),
          )
              : null,
          trailing: trailing,
          tileColor: tileColor,
          onTap: onTap,
          iconColor: iconColor,
        ),
      ),
    );
  }
}
