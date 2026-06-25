import 'package:flutter/material.dart';

class ElearningTheme {
  ElearningTheme({
    this.primaryColor,
    this.secondaryColor,
    this.backgroundColor,
    this.cardColor,
    this.textColor,
    this.subtextColor,
    this.borderColor,
    this.successColor,
    this.errorColor,
    this.warningColor,
  });

  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? backgroundColor;
  final Color? cardColor;
  final Color? textColor;
  final Color? subtextColor;
  final Color? borderColor;
  final Color? successColor;
  final Color? errorColor;
  final Color? warningColor;

  /// Get primary color with fallback to theme or default
  Color getPrimaryColor(BuildContext context) {
    return primaryColor ?? Theme.of(context).primaryColor;
  }

  /// Get secondary color with fallback to theme or default
  Color getSecondaryColor(BuildContext context) {
    return secondaryColor ?? Theme.of(context).colorScheme.secondary;
  }

  /// Get background color with fallback to theme or default
  Color getBackgroundColor(BuildContext context) {
    return backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
  }

  /// Get card color with fallback to theme or default
  Color getCardColor(BuildContext context) {
    return cardColor ?? Theme.of(context).cardColor;
  }

  /// Get text color with fallback to theme or default
  Color getTextColor(BuildContext context) {
    return textColor ??
        Theme.of(context).textTheme.bodyLarge?.color ??
        Colors.black87;
  }

  /// Get subtext color with fallback to theme or default
  Color getSubtextColor(BuildContext context) {
    return subtextColor ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        Colors.black54;
  }

  /// Get border color with fallback to theme or default
  Color getBorderColor(BuildContext context) {
    return borderColor ?? Colors.grey.shade300;
  }

  /// Get success color with fallback to default
  Color getSuccessColor(BuildContext context) {
    return successColor ?? Colors.green;
  }

  /// Get error color with fallback to default
  Color getErrorColor(BuildContext context) {
    return errorColor ?? Colors.red;
  }

  /// Get warning color with fallback to default
  Color getWarningColor(BuildContext context) {
    return warningColor ?? Colors.orange;
  }
}
