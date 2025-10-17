import 'dart:async';

import 'package:dart_assincronismo/api_key.dart';
import 'package:http/http.dart';
import 'dart:convert';

StreamController<String> streamController = StreamController<String>();

void main() {
  StreamSubscription streamSubscription = streamController.stream.listen((
    String info,
  ) {
    print(info);
  });
  requestData();
  requestDataAsync();
  sendDataAsync({
    "id": "NEW001",
    "name": "Flutter",
    "lastName": "Dart",
    "balance": 5000,
  });
}

requestData() {
  String url =
      "https://gist.githubusercontent.com/fredespindola/b04d557496cb526a8bdd1f3e058058ec/raw/2e3269bfe6ba7e4e15a88132f1b1ccd510cb7d2b/accounts.json";
  Future<Response> futureResponse = get(Uri.parse(url));
  futureResponse.then((Response response) {
    streamController.add(
      "$DateTime.now() | Requisição de leitura (usando then).",
    );
  });
}

Future<List<dynamic>> requestDataAsync() async {
  String url =
      "https://gist.githubusercontent.com/fredespindola/b04d557496cb526a8bdd1f3e058058ec/raw/2e3269bfe6ba7e4e15a88132f1b1ccd510cb7d2b/accounts.json";
  Response response = await get(Uri.parse(url));
  streamController.add("$DateTime.now() | Requisição de leitura.");
  return json.decode(response.body);
}

sendDataAsync(Map<String, dynamic> mapAccount) async {
  List<dynamic> listAccounts = await requestDataAsync();
  listAccounts.add(mapAccount);
  String content = json.encode(listAccounts);

  String url = "https://api.github.com/gists/b04d557496cb526a8bdd1f3e058058ec";

  Response response = await post(
    Uri.parse(url),
    headers: {"Authorization": "Bearer $githubApiKey"},
    body: json.encode({
      "description": "account.json",
      "public": true,
      "files": {
        "accounts.json": {"content": content},
      },
    }),
  );
  if (response.statusCode.toString()[0] == "2") {
    streamController.add(
      "$DateTime.now() | Requisição de adição bem sucedida (${mapAccount["name"]}]).",
    );
  } else {
    streamController.add(
      "$DateTime.now() | Requisição falhou (${mapAccount["name"]}]).",
    );
  }
}
