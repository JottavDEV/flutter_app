import 'package:flutter/material.dart';
import '../../../../core/utils/date_formatter.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String? labelText;
  final String? errorText;

  const DatePickerField({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.labelText,
    this.errorText,
  });

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        helpText: 'Selecione a data de nascimento',
        cancelText: 'Cancelar',
        confirmText: 'Confirmar',
      );

      if (picked != null && picked != selectedDate) {
        onDateSelected(picked);
      }
    } catch (e) {
      // Se houver erro, mostra um diálogo simples
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text('Erro ao abrir seletor de data: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText ?? 'Data de Nascimento',
          errorText: errorText,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null
              ? DateFormatter.formatDate(selectedDate!)
              : 'Selecione a data',
          style: TextStyle(
            color: selectedDate != null
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

