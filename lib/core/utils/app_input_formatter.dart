import 'package:flutter/services.dart';

class AppInputFormatter {
  AppInputFormatter._();
  static final textNoEmoji = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9\s.,/&()\-]+"),
  );
  static final textOnly = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z\s]+"),
  );
}