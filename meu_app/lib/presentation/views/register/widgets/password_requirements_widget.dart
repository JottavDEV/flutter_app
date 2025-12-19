import 'package:flutter/material.dart';
import '../../../../core/validators/password_validator.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final PasswordValidationResult? validation;

  const PasswordRequirementsWidget({
    super.key,
    required this.validation,
  });

  @override
  Widget build(BuildContext context) {
    if (validation == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requisitos da senha:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        _buildRequirement(
          context,
          'Pelo menos 1 caractere maiúsculo',
          validation!.hasUpperCase,
        ),
        _buildRequirement(
          context,
          'Pelo menos 1 caractere minúsculo',
          validation!.hasLowerCase,
        ),
        _buildRequirement(
          context,
          'Pelo menos 1 número',
          validation!.hasNumber,
        ),
        _buildRequirement(
          context,
          'Pelo menos 1 caractere especial',
          validation!.hasSpecialChar,
        ),
      ],
    );
  }

  Widget _buildRequirement(BuildContext context, String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: isValid ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isValid ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


