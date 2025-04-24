import 'package:flutter/material.dart';

class TreeViewSearchUi {
  final String? hintText;
  final Widget? prefixIcon;
  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final bool? filled;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? autofocus;
  final bool? autocorrect;
  final int? maxLines;
  final int? minLines;

  const TreeViewSearchUi({
    this.hintText,
    this.prefixIcon,
    this.border,
    this.contentPadding,
    this.hintStyle,
    this.fillColor,
    this.filled,
    this.decoration,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.autofocus,
    this.autocorrect,
    this.maxLines,
    this.minLines,
  });

  TreeViewSearchUi copyWith({
    String? hintText,
    Widget? prefixIcon,
    InputBorder? border,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? hintStyle,
    Color? fillColor,
    bool? filled,
    InputDecoration? decoration,
    TextStyle? style,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool? autofocus,
    bool? autocorrect,
    int? maxLines,
    int? minLines,
  }) {
    return TreeViewSearchUi(
      hintText: hintText ?? this.hintText,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      border: border ?? this.border,
      contentPadding: contentPadding ?? this.contentPadding,
      hintStyle: hintStyle ?? this.hintStyle,
      fillColor: fillColor ?? this.fillColor,
      filled: filled ?? this.filled,
      decoration: decoration ?? this.decoration,
      style: style ?? this.style,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
      autofocus: autofocus ?? this.autofocus,
      autocorrect: autocorrect ?? this.autocorrect,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
    );
  }
}
