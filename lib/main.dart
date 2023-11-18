import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(PrevisaoTempoApp());

class PrevisaoTempoApp extends StatefulWidget {
  @override
  _PrevisaoTempoAppState createState() => _PrevisaoTempoAppState();
}

class _PrevisaoTempoAppState extends State<PrevisaoTempoApp> {
  String cidade = "";
  String temperatura = "";
  String descricao = "";

  TextEditingController previsaoController = TextEditingController();

  buscarPrevisaoTempo(cidade) async {
    //CHAVE API
    var apiKey = 'api';

    //CONVERTENDO STRING EM URL
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cidade&appid=$apiKey&units=metric&lang=pt_BR');

    //FAZENDO REQUISIÇÃO PARA A API
    var response = await http.get(url);

    //CONVERTENDO DE JSON PARA MAP
    var previsao = json.decode(response.body);

    setState(() {
      //INSERINDO OS VALORES NAS VARIAVEIS TEMPERATURA E DESCRICAO
      temperatura = previsao['main']['temp'].toString();
      descricao = previsao['weather'][0]['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Previsão do Tempo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Digite a cidade'),
                  controller: previsaoController,
                ),
                SizedBox(
                    height:
                        16.0), // Adicione um espaço entre o TextField e o botão
                ElevatedButton(
                  onPressed: () async {
                    buscarPrevisaoTempo(previsaoController.text);
                  },
                  child: Text('Buscar Previsão'),
                ),
                SizedBox(
                    height:
                        16.0), // Adicione um espaço entre o botão e o Texto da previsão
                if (temperatura.isNotEmpty && descricao.isNotEmpty)
                  Column(
                    children: [
                      Icon(
                        // Adicione um ícone para representar o estado do tempo
                        Icons.cloud, // Substitua pelo ícone adequado
                        size: 40.0,
                      ),
                      Text(
                        'Temperatura: $temperatura°C',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        descricao,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
