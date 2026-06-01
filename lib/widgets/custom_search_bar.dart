import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/search_screen.dart';

class CustomSearchBar extends StatelessWidget {
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const CustomSearchBar({
    Key? key,
    this.readOnly = false,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly
          ? () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            }
          : null,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9), // Light slate gray
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppTheme.textMuted,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: readOnly
                  ? const Text(
                      'Search "fresh strawberry", "milk" or "bread"',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : TextField(
                      controller: controller,
                      onChanged: onChanged,
                      autofocus: true,
                      style: const TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search for fresh items, dairy, snacks...',
                        hintStyle: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
            ),
            if (!readOnly && controller != null && controller!.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: AppTheme.textMuted),
                onPressed: () {
                  controller!.clear();
                  if (onChanged != null) onChanged!('');
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else
              const Icon(
                Icons.mic_none_rounded,
                color: AppTheme.primaryOrange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
