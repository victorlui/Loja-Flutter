import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loja_virtual/models/cep_address.dart';

const token = '0c95955132ed68a93ddbe00d36268525';

class CepAbertoService {
  Future<CepAddress> getAddressFromCep(String cep) async {
    //removar caracteres
    final cepFormater = cep.replaceAll('.', '').replaceAll('-', '');
     //print(cepFormater);
   
    final url = 'https://www.cepaberto.com/api/v3/cep?cep=$cepFormater';
    //final url = 'https://viacep.com.br/ws/$cepFormater/json/';
    final Dio dio = new Dio();

    //adicionando o token na requisição
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

   try {
      final response = await dio.get<Map<String,dynamic>>(url);
      final CepAddress address = CepAddress.fromMap(response.data);

      return address;

    } on DioError catch (e) {
      return Future.error('$e Erro ao buscar CEP, Verifica sua internet');
    }
  }
}
