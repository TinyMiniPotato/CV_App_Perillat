import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/style_viewmodel.dart';
import '../widgets/style_selector.dart';

class CVTab extends ConsumerWidget {
  const CVTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStyle = ref.watch(styleProvider);

    return Column(
      children: [
        const StyleSelector(),
        Expanded(
          child: currentStyle.buildFlutterView(context),
        ),
      ],
    );
  }
}
