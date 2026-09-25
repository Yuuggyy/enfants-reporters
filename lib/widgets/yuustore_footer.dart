import 'package:flutter/material.dart';

import '../core/app_constants.dart';

/// Pied de page standard de tous les projets YuuStore.
class YuuStoreFooter extends StatelessWidget {
  const YuuStoreFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Center(
        child: TextButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Contact YuuStore : ${AppConstants.yuuStorePhone}',
              ),
            ),
          ),
          icon: const Icon(Icons.storefront, size: 16),
          label: const Text(
            AppConstants.yuuStoreLabel,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
