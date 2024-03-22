import 'package:flutter/material.dart';

/// 加載資料Widget
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
      return const Center(
        child: RefreshProgressIndicator(),
      );
  }
}
