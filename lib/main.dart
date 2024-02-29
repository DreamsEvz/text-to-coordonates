import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Extracteur de point GPS'),
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
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  List<dynamic> gpsPoint = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: LayoutBuilder(
          // Utilise LayoutBuilder pour obtenir les dimensions de l'écran
          builder: (BuildContext context, BoxConstraints constraints) {
            double widthPercent = 0.8; // Largeur en pourcentage de l'écran
            double calculatedWidth = constraints.maxWidth *
                widthPercent; // Calcule la largeur en fonction du pourcentage

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: calculatedWidth,
                  child: const Text(
                    'Entrez le texte duquel vous souhaitez extraire le(s) point(s) GPS :',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                SizedBox(
                  width: calculatedWidth,
                  child: TextField(
                    controller: _textFieldController,
                    focusNode: _textFieldFocusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _textFieldFocusNode.unfocus();
                    gpsPoint.clear();
                    final regex = RegExp(r'-?\d{1,2}\.\d+,\s*-?\d{1,3}\.\d+');
                    final matches = regex.allMatches(_textFieldController.text);

                    if (matches.isNotEmpty) {
                      for (final match in matches) {
                        gpsPoint.add(match.group(0));
                      }
                    } else {
                      gpsPoint.clear();
                    }
                  },
                  child: const Text('Extraire'),
                ),
                Column(
                  children: gpsPoint.map((point) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0,
                          right:
                              8.0), // Vous pouvez ajuster les valeurs de padding ici
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('$point'), // Affiche le point GPS
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy), // L'icône de copie
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text:
                                      point)); // Copie le point GPS dans le presse-papiers
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Copié dans le presse-papiers !')), // Affiche une confirmation
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
