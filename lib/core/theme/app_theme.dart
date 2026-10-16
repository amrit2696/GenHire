import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghire/core/theme/app_colors.dart';


TextStyle _textStyle(
  double size,
  FontWeight weight, {
  Color color = AppColor.textPrimary,
}) {
  return TextStyle(
    fontFamily: 'PublicSansRegular',
    fontWeight: weight,
    color: color,
    fontSize: size.sp,
  );
}

/// Extra Bold - 800
final xb24 = _textStyle(24, FontWeight.w800);
final xb22 = _textStyle(22, FontWeight.w800);
final xb20 = _textStyle(20, FontWeight.w800);
final xb18 = _textStyle(18, FontWeight.w800);
final xb16 = _textStyle(16, FontWeight.w800);
final xb14 = _textStyle(14, FontWeight.w800);
final xb12 = _textStyle(12, FontWeight.w800);
final xb10 = _textStyle(10, FontWeight.w800);
final xb08 = _textStyle(8, FontWeight.w800);
final xb06 = _textStyle(6, FontWeight.w800);

/// Bold - 700
final b24 = _textStyle(24, FontWeight.w700);
final b22 = _textStyle(22, FontWeight.w700);
final b20 = _textStyle(20, FontWeight.w700);
final b18 = _textStyle(18, FontWeight.w700);
final b16 = _textStyle(16, FontWeight.w700);
final b14 = _textStyle(14, FontWeight.w700);
final b12 = _textStyle(12, FontWeight.w700);
final b10 = _textStyle(10, FontWeight.w700);
final b08 = _textStyle(8, FontWeight.w700);
final b06 = _textStyle(6, FontWeight.w700);

/// Semi Bold - 600
final sb24 = _textStyle(24, FontWeight.w600);
final sb22 = _textStyle(22, FontWeight.w600);
final sb20 = _textStyle(20, FontWeight.w600);
final sb18 = _textStyle(18, FontWeight.w600);
final sb16 = _textStyle(16, FontWeight.w600);
final sb14 = _textStyle(14, FontWeight.w600);
final sb12 = _textStyle(12, FontWeight.w600);
final sb10 = _textStyle(10, FontWeight.w600);
final sb08 = _textStyle(8, FontWeight.w600);
final sb06 = _textStyle(6, FontWeight.w600);

/// Medium - 500
final m24 = _textStyle(24, FontWeight.w500);
final m22 = _textStyle(22, FontWeight.w500);
final m20 = _textStyle(20, FontWeight.w500);
final m18 = _textStyle(18, FontWeight.w500);
final m16 = _textStyle(16, FontWeight.w500);
final m14 = _textStyle(14, FontWeight.w500);
final m12 = _textStyle(12, FontWeight.w500);
final m10 = _textStyle(10, FontWeight.w500);
final m08 = _textStyle(8, FontWeight.w500);
final m06 = _textStyle(6, FontWeight.w500);

/// Normal - 400
final n24 = _textStyle(24, FontWeight.w400);
final n22 = _textStyle(22, FontWeight.w400);
final n20 = _textStyle(20, FontWeight.w400);
final n18 = _textStyle(18, FontWeight.w400);
final n16 = _textStyle(16, FontWeight.w400);
final n14 = _textStyle(14, FontWeight.w400);
final n12 = _textStyle(12, FontWeight.w400);
final n10 = _textStyle(10, FontWeight.w400);
final n08 = _textStyle(8, FontWeight.w400);
final n06 = _textStyle(6, FontWeight.w400);

/// Light - 300
final l24 = _textStyle(24, FontWeight.w300);
final l22 = _textStyle(22, FontWeight.w300);
final l20 = _textStyle(20, FontWeight.w300);
final l18 = _textStyle(18, FontWeight.w300);
final l16 = _textStyle(16, FontWeight.w300);
final l14 = _textStyle(14, FontWeight.w300);
final l12 = _textStyle(12, FontWeight.w300);
final l10 = _textStyle(10, FontWeight.w300);
final l08 = _textStyle(8, FontWeight.w300);
final l06 = _textStyle(6, FontWeight.w300);

/// Extra Light - 200
final xl24 = _textStyle(24, FontWeight.w200);
final xl22 = _textStyle(22, FontWeight.w200);
final xl20 = _textStyle(20, FontWeight.w200);
final xl18 = _textStyle(18, FontWeight.w200);
final xl16 = _textStyle(16, FontWeight.w200);
final xl14 = _textStyle(14, FontWeight.w200);
final xl12 = _textStyle(12, FontWeight.w200);
final xl10 = _textStyle(10, FontWeight.w200);
final xl08 = _textStyle(8, FontWeight.w200);
final xl06 = _textStyle(6, FontWeight.w200);

/// Custom text style
TextStyle appText(
  double size,
  FontWeight weight, {
  Color color = AppColor.textPrimary,
}) {
  return _textStyle(
    size,
    weight,
    color: color,
  );
}