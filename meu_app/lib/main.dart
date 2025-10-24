import 'package:flutter/material.dart';


void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {

 const MyApp({super.key});


 @override

 Widget build(BuildContext context) {

  return MaterialApp(

   title: 'Analisador de Texto',

   debugShowCheckedModeBanner: false,

   theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),

   home: const MyHomePage(title: 'Analisador de Texto'),

  );

 }

}


class MyHomePage extends StatefulWidget {

 const MyHomePage({super.key, required this.title});


 final String title;


 @override

 State<MyHomePage> createState() => _MyHomePageState();

}


class _MyHomePageState extends State<MyHomePage> {

 final TextEditingController _textController = TextEditingController();


 // Variáveis para guardar os resultados da análise

 bool _resultsVisible = false;

 int? _charCountWithSpaces;

 int? _charCountWithoutSpaces;

 int? _wordCount;

 int? _uniqueWordCount;

 int? _sentenceCount;

 String? _readingTime;

 List<MapEntry<String, int>>? _top10Words;


 @override

 void initState() {

  super.initState();

  // Adiciona um listener para esconder os resultados se o texto mudar

  _textController.addListener(() {

   if (_resultsVisible) {

    setState(() {

     _resultsVisible = false;

    });

   }

   // NOVO: Adicionado para que o botão de limpar apareça/desapareça

   // sem precisar de uma análise primeiro.

   setState(() {});

  });

 }


 @override

 void dispose() {

  _textController.dispose();

  super.dispose();

 }


 // Função central que realiza toda a análise

 void _analyzeText() {

  final String currentText = _textController.text;

  if (currentText.trim().isEmpty) {

   // Não analisa se o campo estiver vazio, apenas mostra uma mensagem

   ScaffoldMessenger.of(context).showSnackBar(

    const SnackBar(

     content: Text('Por favor, digite um texto para analisar.'),

     duration: Duration(seconds: 2),

    ),

   );

   return;

  }


  final List<String> words = currentText

    .toLowerCase()

    .replaceAll(RegExp(r'[^\w\s]+'), '')

    .split(RegExp(r'\s+'))

    .where((word) => word.isNotEmpty)

    .toList();


  // Executa os cálculos e guarda nas variáveis de estado

  setState(() {

   _charCountWithSpaces = currentText.length;

   _charCountWithoutSpaces =

     currentText.replaceAll(RegExp(r'\s+'), '').length;

   _wordCount = words.length;

   _uniqueWordCount = Set<String>.from(words).length;


   final sentences = currentText.split(RegExp(r'[.?!]'));

   _sentenceCount = sentences.where((s) => s.trim().isNotEmpty).length;


   const wordsPerMinute = 250;

   final double minutes = _wordCount! / wordsPerMinute;

   if (minutes == 0) {

    _readingTime = '0 min';

   } else if (minutes < 1) {

    _readingTime = '< 1 min';

   } else {

    _readingTime = '${minutes.round()} min';

   }


   final Map<String, int> wordFrequencies = {};

   for (final word in words) {

    wordFrequencies[word] = (wordFrequencies[word] ?? 0) + 1;

   }

   final sortedWords = wordFrequencies.entries.toList()

    ..sort((a, b) => b.value.compareTo(a.value));

   _top10Words = sortedWords.take(10).toList();


   _resultsVisible = true; // Torna os resultados visíveis

  });

 }


 // NOVO MÉTODO: Função que exibe o diálogo de confirmação.

 Future<bool?> _showClearConfirmationDialog() {

  return showDialog<bool>(

   context: context,

   builder: (BuildContext context) {

    return AlertDialog(

     title: const Text('Confirmar Limpeza'),

     content: const Text(

       'Você tem certeza que deseja apagar todo o texto? Esta ação não pode ser desfeita.'),

     actions: <Widget>[

      TextButton(

       child: const Text('Cancelar'),

       onPressed: () {

        // Fecha o diálogo e retorna 'false'

        Navigator.of(context).pop(false);

       },

      ),

      TextButton(

       child: const Text('Limpar'),

       onPressed: () {

        // Fecha o diálogo e retorna 'true'

        Navigator.of(context).pop(true);

       },

      ),

     ],

    );

   },

  );

 }


 @override

 Widget build(BuildContext context) {

  return Scaffold(

   appBar: AppBar(

    title: Text(widget.title),

    backgroundColor: Theme.of(context).colorScheme.inversePrimary,

    actions: [

     if (_textController.text.isNotEmpty)

      IconButton(

       icon: const Icon(Icons.clear),

       tooltip: 'Limpar Texto',

       // MODIFICADO: O onPressed agora é 'async' e chama o diálogo.

       onPressed: () async {

        // 1. Chama a função do diálogo e espera a resposta do usuário

        final bool? confirmClear = await _showClearConfirmationDialog();


        // 2. Só limpa o texto se o usuário confirmou (retornou true)

        if (confirmClear == true) {

         _textController.clear();

        }

       },

      ),

    ],

   ),

   body: SingleChildScrollView(

    child: Padding(

     padding: const EdgeInsets.all(16.0),

     child: Column(

      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: <Widget>[

       TextField(

        controller: _textController,

        decoration: const InputDecoration(

         border: OutlineInputBorder(),

         labelText: 'Digite seu texto aqui...',

        ),

        style: const TextStyle(fontSize: 18),

        maxLines: 8,

       ),

       const SizedBox(height: 16),

       ElevatedButton.icon(

        icon: const Icon(Icons.analytics_outlined),

        label: const Text('Analisar Texto'),

        onPressed: _analyzeText,

        style: ElevatedButton.styleFrom(

         padding: const EdgeInsets.symmetric(vertical: 16),

         textStyle: const TextStyle(fontSize: 18),

        ),

       ),

       const SizedBox(height: 24),

       if (_resultsVisible)

        Column(

         children: [

          const Divider(),

          const SizedBox(height: 16),

          GridView.count(

           crossAxisCount: 3,

           shrinkWrap: true,

           physics: const NeverScrollableScrollPhysics(),

           childAspectRatio: 1.5,

           mainAxisSpacing: 8,

           crossAxisSpacing: 8,

           children: [

            _buildStatCard('Palavras', '${_wordCount ?? 0}'),

            _buildStatCard(

              'Palavras Únicas', '${_uniqueWordCount ?? 0}'),

            _buildStatCard('Frases', '${_sentenceCount ?? 0}'),

            _buildStatCard(

              'Caracteres', '${_charCountWithSpaces ?? 0}'),

            _buildStatCard('Caracteres s/ espaço',

              '${_charCountWithoutSpaces ?? 0}'),

            _buildStatCard('Tempo Leitura', _readingTime ?? '0 min'),

           ],

          ),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 16),

          Text(

           'Top 10 Palavras Mais Comuns',

           style: Theme.of(context).textTheme.headlineSmall,

           textAlign: TextAlign.center,

          ),

          const SizedBox(height: 16),

          if (_top10Words == null || _top10Words!.isEmpty)

           const Text(

            'Nenhuma palavra para analisar.',

            textAlign: TextAlign.center,

           )

          else

           ..._top10Words!.asMap().entries.map((entry) {

            final index = entry.key + 1;

            final wordEntry = entry.value;

            return ListTile(

             leading: CircleAvatar(child: Text('$index')),

             title: Text(

              "'${wordEntry.key}'",

              style: const TextStyle(fontWeight: FontWeight.bold),

             ),

             trailing: Text(

              '${wordEntry.value} vezes',

              style: TextStyle(

                color: Theme.of(context).colorScheme.primary),

             ),

            );

           }),

         ],

        ),

      ],

     ),

    ),

   ),

  );

 }


 Widget _buildStatCard(String label, String value) {

  return Card(

   elevation: 2,

   child: Center(

    child: Padding(

     padding: const EdgeInsets.all(8.0),

     child: Column(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

       Text(

        value,

        style: Theme.of(context).textTheme.titleLarge?.copyWith(

           fontWeight: FontWeight.bold,

           color: Theme.of(context).colorScheme.primary,

          ),

        textAlign: TextAlign.center,

       ),

       const SizedBox(height: 4),

       Text(

        label,

        textAlign: TextAlign.center,

        style: Theme.of(context).textTheme.bodySmall,

       ),

      ],

     ),

    ),

   ),

  );

 }

}