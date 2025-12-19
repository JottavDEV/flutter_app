# Meu App - Sistema de Cadastro e Login

**Desenvolvedor:** João Victor Carvalho de Oliveira

Sistema Flutter com arquitetura MVVM, banco de dados local (SQLite) e gerenciamento de estado com Riverpod.

## Funcionalidades

- ✅ Tela de Login com validação de credenciais
- ✅ Tela de Cadastro com validações em tempo real
- ✅ Banco de dados local (SQLite)
- ✅ Arquitetura MVVM
- ✅ Gerenciamento de estado com Riverpod
- ✅ Validações avançadas (CPF, Email, Senha)
- ✅ Analisador de Texto (funcionalidade original mantida)

## Requisitos

- Flutter SDK (versão 3.9.2 ou superior)
- Dart SDK
- Para Windows Desktop: Visual Studio Community com carga de trabalho "Desktop development with C++"
- Para Android: Android Studio e Android SDK
- Para iOS: Xcode (apenas macOS)

## Instalação

### 1. Clone o repositório ou navegue até a pasta do projeto

```bash
cd meu_app
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Verifique a configuração do Flutter

```bash
flutter doctor
```

Certifique-se de que todas as ferramentas necessárias estão instaladas.

## Como Executar

### Windows Desktop (Recomendado)

1. Certifique-se de que o Visual Studio está instalado com "Desktop development with C++"
2. Execute:

```bash
flutter run -d windows
```

Ou use o script batch:

```bash
.\run_app.bat
```

### Android

1. Certifique-se de que o Android Studio está instalado e um emulador/dispositivo está conectado
2. Execute:

```bash
flutter run -d android
```

### Web (Chrome/Edge)

⚠️ **Nota:** O banco de dados SQLite tem limitações em web. Para funcionalidade completa, use Windows Desktop ou Android.

```bash
flutter run -d chrome
```

ou

```bash
flutter run -d edge
```

### iOS (apenas macOS)

```bash
flutter run -d ios
```

## Estrutura do Projeto

```
lib/
├── core/
│   ├── database/          # Configuração do banco SQLite
│   ├── validators/        # Validadores (CPF, Email, Senha)
│   └── utils/             # Utilitários
├── data/
│   ├── models/            # Modelos de dados
│   └── repositories/      # Repositórios (acesso ao banco)
├── presentation/
│   ├── providers/          # Providers Riverpod
│   ├── viewmodels/        # ViewModels (lógica de negócio)
│   └── views/             # Telas (UI)
│       ├── login/         # Tela de login
│       ├── register/       # Tela de cadastro
│       └── text_analyzer/  # Analisador de texto
└── routes/                # Configuração de rotas
```

## Funcionalidades da Tela de Cadastro

- **Nome e Sobrenome:** Validação para garantir nome completo (nome + sobrenome)
- **CPF:** Máscara automática (XXX.XXX.XXX-XX) e validação de dígitos verificadores
- **Data de Nascimento:** DatePicker com validação
- **Email:** Validação de formato e verificação de duplicidade
- **Senha:** Validação em tempo real com indicadores visuais:
  - Pelo menos 1 caractere maiúsculo
  - Pelo menos 1 caractere minúsculo
  - Pelo menos 1 número
  - Pelo menos 1 caractere especial
- **Confirmar Senha:** Validação de igualdade com a senha
- **Botão Cadastrar:** Habilitado apenas quando todos os campos estão válidos

## Funcionalidades da Tela de Login

- **Email:** Campo obrigatório com validação de formato
- **Senha:** Campo obrigatório com ícone de visibilidade
- **Botão Entrar:** Valida credenciais no banco de dados local
- **Link para Cadastro:** Navega para tela de cadastro

## Banco de Dados

O sistema utiliza SQLite para armazenamento local:
- **Windows/Linux/Mac Desktop:** Usa `sqflite_common_ffi`
- **Android/iOS:** Usa `sqflite` nativo
- **Web:** Usa `sqflite_common_ffi_web` (com limitações)

Os dados são armazenados localmente no dispositivo/desktop.

## Tecnologias Utilizadas

- **Flutter:** Framework de desenvolvimento
- **Riverpod:** Gerenciamento de estado
- **SQLite (sqflite):** Banco de dados local
- **MVVM:** Arquitetura de software

## Desenvolvido por

João Victor Carvalho de Oliveira
