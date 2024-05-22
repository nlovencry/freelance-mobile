import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../helper/constant.dart';

class Skeleton<Data> extends StatelessWidget {
  final Widget child;
  final Data? value;
  final bool silver;
  double? width;
  double? height;
  bool isCircle;
  Skeleton(
      {Key? key,
      required this.child,
      this.value,
      this.silver = false,
      this.width,
      this.height,
      this.isCircle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value != null) {
      return child;
    } else {
      return Shimmer.fromColors(
        direction: ShimmerDirection.rtl,
        baseColor:
            (silver ? Colors.white : Constant.primaryColor).withAlpha(200),
        highlightColor:
            (silver ? Colors.grey : Constant.backgroundColor).withAlpha(200),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          ),
          margin: EdgeInsets.all(2),
          child: child,
        ),
      );
    }
  }
}
