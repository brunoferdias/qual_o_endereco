import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class Cep extends StatefulWidget {
  const Cep({Key? key}) : super(key: key);

  @override
  State<Cep> createState() => _CepState();
}

class _CepState extends State<Cep> {

  bool _isLoading = false;

  //Variavel para exibir o cep na interface
  String resultado = "Seu CEP irá aparecer aqui...";

  //Controller para pegar o texto do textfield
  TextEditingController txtcep = TextEditingController();


  Future<void> buscacep() async {

    HapticFeedback.heavyImpact();

    bool resultInternet = await InternetConnectionChecker().hasConnection;

    if (resultInternet == true) {
      //1 passo - recuperar o CEP
      String cep = txtcep.text.replaceAll(".", '');
      String cepFinal = cep.toString().replaceAll('-', '');

      //2 passo - definir a URL
      String url = "https://viacep.com.br/ws/${cepFinal}/json/";

      //3 passo - criar uma variavel que vai armazenar a resposta da requisição
      http.Response response;

      //4 passo - efetuar a requisição para a url utilizando o comando get
      response = await http.get(Uri.parse(url));

      //Agora para exibir no nosso app a resposta, precisamos converter
      //em um objeto JSON, para isso vamos utilizar o convert
      Map<String, dynamic> dados = json.decode(
          response.body);

      if(dados["erro"] == true){

        setState(() {
          resultado = "CEP inválido";
        });

        setState(() {
          _isLoading = false;
        });

      }else{

        setState(() {
          _isLoading = false;
        });

        String logradouro = dados["logradouro"];
        String complemento = dados["complemento"];
        String bairro = dados["bairro"];
        String localidade = dados["localidade"];
        String uf = dados["uf"];

        if(complemento == ""){
          complemento = " - - ";
        }

        String endereco =
            "Rua: $logradouro \n"
            "Bairro: $bairro \n"
            "Complemento: $complemento \n"
            "Cidade: $localidade \n"
            "Estado: $uf";

        setState(() {
          resultado = endereco;
        });
      }
    } else {

      setState(() {
        resultado = "Internet fraca para realizar a consulta!";
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Sinal de internet insuficiente para realizar a consulta!',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _resetarCampo() {

    setState(() {
      _isLoading = false;
    });

    txtcep.clear();
    setState(() {
      resultado = "Seu CEP irá aparecer aqui";
    });

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    };

  }

  var formatCEP = MaskTextInputFormatter(
      mask: '##.###-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);





  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }//Esconde o teclado ao clicar em outro lugar!!!!!!!!!!!!!!!!
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text('Qual o Endereço?'),
          backgroundColor: Colors.blue.shade700,
          centerTitle: true,
        ),
        backgroundColor: Colors.yellow.shade400,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Column(

              children: [

                TextFormField(
                  controller: txtcep,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(onPressed: () {
                        _resetarCampo();
                      },icon: Icon(Icons.cancel_outlined),),
                      labelText: "Insira o CEP aqui 🗺"
                  ),
                  style: TextStyle(fontSize: 30,color: Colors.blueAccent),
                  inputFormatters: [formatCEP],
                ),

                SizedBox(height: 20,),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
                  ),
                    onPressed: (){

                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      if(txtcep.text == null || txtcep.text == ''){

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                        'Você não digitou nada, digite o CEP desejado!',
                        style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.red,
                        ));

                        setState(() {
                          _isLoading = false;
                        });

                      }else if(txtcep.text.length != 10){

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                            'Está faltando algum número!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ));

                        setState(() {
                          _isLoading = false;
                        });

                      }else{

                        buscacep();

                        setState(() {
                          _isLoading = true;
                        });

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Consultar',style: TextStyle(fontSize: 25),),
                    )
                ),

                SizedBox(height: 20,),


            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    width: 2
                ),
                borderRadius: BorderRadius.circular(18),
                color: Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: _isLoading? CircularProgressIndicator():Text(
                  resultado,
                  style: TextStyle(
                    fontSize: 25,

                  ),
                ),
              ),
            ),

                SizedBox(height: 25,),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
