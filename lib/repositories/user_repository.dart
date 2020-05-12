import 'dart:convert';
import 'package:github_repo/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  Map<String, String> header = {
    'Accept': 'application/vnd.github.nebula-preview+json'
  };

  Future<List<User>> usersList(String search) async {
    String url = 'https://api.github.com/search/users?q=' + '$search';

    var response = await http.get(url, headers: header);
    print(url);
    print(response.statusCode);

    List<User> users = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      for (var item in body['items']) {
        User user = User.fromJson(item);
        users.add(user);
      }
    } else {
      print(response.statusCode);
    }

    return users;
  }
}
