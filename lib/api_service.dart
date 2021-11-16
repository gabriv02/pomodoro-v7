import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'info.dart';

class ApiService {
  final String url =
      'https://pomodoroapp20211114235511.azurewebsites.net/api/People';
  Client client = Client();

  // GET FUNCTION
  Future<List<Info>> getInfo() async {
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('EXITO: ' + jsonResponse['entries'][0]['API']);

      return (jsonResponse['entries'] as List)
          .map((e) => Info.fromJSON(e))
          .toList();
    }
    throw Exception('Error al llamar al API');
  }

  Future<Info> getInfoId(int id) async {
    var response = await http.get(Uri.parse(url + '/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('EXITO: ' + jsonResponse['entries'][0]['API']);

      return Info.fromJSON(jsonDecode(response.body));
    }
    throw Exception('Error al llamar al API');
  }

  Future<void> postInfo(Info info) async {
    Map data = {
      'api': 0,
      'name': info.name.toString(),
      'tarea': info.tarea.toString(),
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    //if (response.statusCode != 201) throw Exception('Fallo al crear persona');
  }

  Future<void> putInfo(int? api, Info info) async {
    Map data = {
      'api': api,
      'name': info.name.toString(),
      'tarea': info.tarea.toString(),
    };

    final response = await http.put(
      Uri.parse(url + '/$api'),
      headers: {
        //"Accept": "text/plain",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 204) throw Exception('Hubo falla');
  }

  Future<void> deleteInfo(int? api) async {
    print("id $api");
    final response = await http.delete(
      Uri.parse(url + '/$api'),
      headers: {
        //"Accept": "text/plain",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 204) throw Exception('Hubo falla');
  }
}
