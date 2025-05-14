// lib/widgets/expandable_text.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText({
    Key? key,
    required this.text,
    this.trimLines = 4,
    this.style,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final defaultStyle = widget.style ?? const TextStyle(fontSize: 14, color: Colors.black);

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: text, style: defaultStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;

        if (_isExpanded || !isOverflow) {
          return RichText(
            text: TextSpan(
              style: defaultStyle,
              children: [
                TextSpan(text: text),
                if (isOverflow)
                  TextSpan(
                    text: " less",
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() => _isExpanded = false),
                  ),
              ],
            ),
          );
        }

        return RichText(
          text: TextSpan(
            style: defaultStyle,
            children: [
              TextSpan(
                text: _trimToMaxLines(text, defaultStyle, constraints.maxWidth, widget.trimLines),
              ),
              const TextSpan(text: '... '),
              TextSpan(
                text: 'more',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() => _isExpanded = true),
              ),
            ],
          ),
        );
      },
    );
  }

  String _trimToMaxLines(String text, TextStyle style, double maxWidth, int maxLines) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );

    String result = text;
    int min = 0, max = text.length;
    while (min < max) {
      final mid = (min + max) ~/ 2;
      final span = TextSpan(text: text.substring(0, mid), style: style);
      textPainter.text = span;
      textPainter.layout(maxWidth: maxWidth);
      if (textPainter.didExceedMaxLines) {
        max = mid;
      } else {
        result = text.substring(0, mid);
        min = mid + 1;
      }
    }

    return result.trimRight();
  }
}