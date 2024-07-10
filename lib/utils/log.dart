import 'package:flutter/material.dart';

class Log {
  static void red(String msg) {
    debugPrint('\x1B[31m$msg\x1B[0m');
  }

  static void green(String msg) {
    debugPrint('\x1B[32m$msg\x1B[0m');
  }

  static void yellow(String msg) {
    debugPrint('\x1B[33m$msg\x1B[0m');
  }

  static void cyan(String msg) {
    debugPrint('\x1B[36m$msg\x1B[0m');
  }

  static void pink(String msg){
    debugPrint('\x1B[35m$msg\x1B[0m');
  }
}