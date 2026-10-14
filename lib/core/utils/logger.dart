import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kDebugMode ? Level.trace : Level.off,
  printer: PrettyPrinter(
    methodCount: 2, // Normal logs: Only show 2 steps of footprints
    errorMethodCount: 8, // Error logs: Show 8 steps to help find the bug
    lineLength: 80, // Width of the box drawn in the console
    colors: true, // Use bright colors
    printEmojis: true, // Put a 🛑 next to errors and a 💡 next to info
    // Time is usually annoying, so we turn it off
    dateTimeFormat: DateTimeFormat.none,
  ),
);
