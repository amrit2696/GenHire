import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppSpace {
  AppSpace._();

  /// Vertical spaces
  static SizedBox h2 = SizedBox(height: 2.h);
  static SizedBox h4 = SizedBox(height: 4.h);
  static SizedBox h5 = SizedBox(height: 5.h);
  static SizedBox h8 = SizedBox(height: 8.h);
  static SizedBox h10 = SizedBox(height: 10.h);
  static SizedBox h12 = SizedBox(height: 12.h);
  static SizedBox h16 = SizedBox(height: 16.h);
  static SizedBox h20 = SizedBox(height: 20.h);
  static SizedBox h24 = SizedBox(height: 24.h);
  static SizedBox h30 = SizedBox(height: 30.h);
  static SizedBox h40 = SizedBox(height: 40.h);

  /// Horizontal spaces
  static SizedBox w2 = SizedBox(width: 2.w);
  static SizedBox w4 = SizedBox(width: 4.w);
  static SizedBox w5 = SizedBox(width: 5.w);
  static SizedBox w8 = SizedBox(width: 8.w);
  static SizedBox w10 = SizedBox(width: 10.w);
  static SizedBox w12 = SizedBox(width: 12.w);
  static SizedBox w16 = SizedBox(width: 16.w);
  static SizedBox w20 = SizedBox(width: 20.w);
  static SizedBox w24 = SizedBox(width: 24.w);
}