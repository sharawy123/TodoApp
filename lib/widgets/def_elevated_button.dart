import 'package:flutter/material.dart';
import 'package:to_do_app/app_theme.dart';

class defElevatedButton extends StatelessWidget {
  String label;
  VoidCallback onPressedButton;

  defElevatedButton({required this.label, required this.onPressedButton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.sizeOf(context).width, 52)),
        onPressed: onPressedButton,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppTheme.white,
              ),
        ));
  }
}
