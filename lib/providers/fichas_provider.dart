import 'package:http/http.dart' as http;

class FichasProvider {
  final url =
      'https://flutter-chat-e1a40.firebaseio.com/fichas/jovannyrch/fichas.json';

  Future<List<dynamic>> getFichas() async {
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
