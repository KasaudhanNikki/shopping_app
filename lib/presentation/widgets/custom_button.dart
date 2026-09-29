import 'package:flutter/material.dart';
import '../../core/constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isTapped = false;

  void _handlePress() async {
    if (_isTapped || widget.isLoading || widget.onPressed == null) return;
    
    setState(() => _isTapped = true);
    
    // Prevents double taps rapidly
    widget.onPressed!();
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _isTapped = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (widget.isLoading || widget.onPressed == null) ? null : _handlePress,
      child: widget.isLoading
          ? const SizedBox(
              width: AppConstants.spacing24,
              height: AppConstants.spacing24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(widget.text),
    );
  }
}
