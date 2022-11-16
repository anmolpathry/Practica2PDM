import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  Future<dynamic> postToAPI(recording)async {
    await dotenv.load(fileName: ".env");

    var api_token = dotenv.env['API_TOKEN'];
    print(api_token);

    return http.post(Uri.parse('https://api.audd.io/'), body: {
      "api_token": api_token ,
      "audio": recording,
      "return": 'apple_music,spotify,deezer',
      "method": 'recognize',
    });
  }
}