import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../providers/user_providers.dart';
import '../register/widgets/password_requirements_widget.dart';
import '../register/widgets/date_picker_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Máscara para CPF
  final _cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = ref.read(registerViewModelProvider.notifier);
    final result = await viewModel.register();

    if (!mounted) return;

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      // Limpar formulário
      viewModel.clear();
      _nameController.clear();
      _cpfController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Erro ao cadastrar'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Nome e Sobrenome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome e Sobrenome',
                  border: OutlineInputBorder(),
                  hintText: 'Digite seu nome completo',
                ),
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  viewModel.updateName(value);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite seu nome completo';
                  }
                  final parts = value.trim().split(' ');
                  if (parts.length < 2) {
                    return 'Digite nome e sobrenome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo CPF
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  border: const OutlineInputBorder(),
                  hintText: '000.000.000-00',
                  errorText: state.cpf.isNotEmpty && !state.isCpfValid
                      ? 'CPF inválido'
                      : null,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [_cpfMaskFormatter],
                onChanged: (value) {
                  viewModel.updateCpf(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CPF é obrigatório';
                  }
                  if (!state.isCpfValid) {
                    return 'CPF inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Data de Nascimento
              DatePickerField(
                selectedDate: state.birthDate,
                onDateSelected: (date) {
                  viewModel.updateBirthDate(date);
                },
                errorText: state.birthDate == null ? 'Data é obrigatória' : null,
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  hintText: 'seu@email.com',
                  errorText: state.email.isNotEmpty && !state.isEmailValid
                      ? 'Email inválido'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  viewModel.updateEmail(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }
                  if (!state.isEmailValid) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Senha
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: const OutlineInputBorder(),
                  hintText: 'Digite sua senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      viewModel.togglePasswordVisibility();
                    },
                  ),
                ),
                obscureText: !state.isPasswordVisible,
                onChanged: (value) {
                  viewModel.updatePassword(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória';
                  }
                  if (state.passwordValidation?.isValid != true) {
                    return 'Senha não atende aos requisitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Widget de requisitos de senha
              if (state.password.isNotEmpty)
                PasswordRequirementsWidget(
                  validation: state.passwordValidation,
                ),
              const SizedBox(height: 16),

              // Campo Confirmar Senha
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: const OutlineInputBorder(),
                  hintText: 'Digite a senha novamente',
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      viewModel.toggleConfirmPasswordVisibility();
                    },
                  ),
                  errorText: state.confirmPassword.isNotEmpty &&
                          !state.isConfirmPasswordValid
                      ? 'As senhas não coincidem'
                      : null,
                ),
                obscureText: !state.isConfirmPasswordVisible,
                onChanged: (value) {
                  viewModel.updateConfirmPassword(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmação de senha é obrigatória';
                  }
                  if (value != state.password) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Cadastrar
              ElevatedButton(
                onPressed: state.isFormValid && !state.isLoading
                    ? _handleRegister
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


