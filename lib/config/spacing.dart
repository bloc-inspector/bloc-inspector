import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  static double horizontalSpacing = 20.w;

  // Horizontal SizedBoxes.
  static Widget get horizontalSpaceSmall => SizedBox(width: 5.w);
  static Widget get horizontalSpaceMedium => SizedBox(width: 18.w);

  // Vertical SizedBoxes.
  static Widget get verticalSpaceSmall => SizedBox(height: 5.w);
  static Widget get verticalSpaceMedium => SizedBox(height: 18.w);
  static Widget get verticalSpaceLarge => SizedBox(height: 30.w);
}
