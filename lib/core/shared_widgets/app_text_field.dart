
import 'package:flutter/material.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/core/style/text/app_texts.dart';
import '../validators/validator_helper.dart';
import 'form_label.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? errorMaxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.errorMaxLines = 2,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late bool _obscureText;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _toggleObscureText() {
    setState(() => _obscureText = !_obscureText);
  }

  Widget? _buildSuffixIcon() {
    if (!_hasText && !widget.isPassword) return null;

    if (widget.isPassword) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.highlight_remove, color: AppColors.lavenderPurple),
              onPressed: _controller.clear,
            ),
          if (_controller.text.isNotEmpty)
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade400,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.lavenderPurple,
            ),
            onPressed: _toggleObscureText,
          ),
        ],
      );
    }

    return IconButton(
      icon: Icon(Icons.highlight_remove, color: AppColors.lavenderPurple),
      onPressed: _controller.clear,
    );
  }

  InputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
        FormLabel(text: widget.label!),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          validator:
          widget.validator ??
                  (value) => ValidatorHelper.validateUsername(value ?? ''),
          keyboardType: widget.keyboardType ?? TextInputType.text,
          obscureText: widget.isPassword && _obscureText,
          maxLines: widget.maxLines,
          style: AppTextStyles.font16White400W,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Enter text',
            errorMaxLines: widget.errorMaxLines,
            fillColor: AppColors.jetBlack,
            filled: true,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            border: _buildBorder(AppColors.weakGray),
            enabledBorder: _buildBorder(AppColors.weakGray),
            focusedBorder: _buildBorder(AppColors.lavenderPurple),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red),
          ),
        ),
      ],
    );
  }
}
