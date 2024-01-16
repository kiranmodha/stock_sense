import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  String _text = "";

  void _incrementCounter() {
    access_token();
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
      floatingActionButton:
          buildFloatingActionButton(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Center buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(_text),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    );
  }

  void callApi() async {
    var url = Uri.https('apiconnect.angelbroking.com',
        'rest/secure/angelbroking/market/v1/quote/');

    var headers = {
      'X-PrivateKey': 'OTnz1SyD',
      'Accept': 'application/json',
      'X-SourceID': 'WEB',
      'X-ClientLocalIP': '192.168.168.168',
      'X-ClientPublicIP': '106.193.147.98',
      'X-MACAddress': 'fe80::216e:6507:4b90:3719',
      'X-UserType': 'USER',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJ1c2VybmFtZSI6IkQ4OD MiLCJyb2xlcyI6MCwidXNlcnR5cGUiOiJVU0VSIiwia WF0IjoxNTk5NzEyNjk4LCJleHAiOjE1OTk3MjE2OTh 9.qHZEkOMokMktybarQO3m4NMRVQlF0vvN7rh2lC Rkjd2sCYBq3JnOq0yWWOS5Ux_H0pvvt4-ibSmb5H JoKJHOUw',
      'Content-Type': 'application/json'
    };

    var payload = {
      "mode": "FULL",
      "exchangeTokens": {
        "NSE": ["3045"]
      }
    };

    print('hello');
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    //return response.body;
    setState(() {
      _text = response.body;
    });
  }

  void callApi1() async {
    // Replace 'YOUR_API_KEY' with your actual API key
    var apiKey = 'OTnz1SyDPI_KEY';
    var url = Uri.https('apiconnect.angelbroking.com',
        'rest/secure/angelbroking/market/v1/quote/');

    var headers = {
      'X-PrivateKey': apiKey,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var payload = {
      "mode": "FULL",
      "exchangeTokens": {
        "NSE": ["12322"] // Replace with the desired stock symbol
      }
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      // Process the response data as needed
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
    setState(() {
      _text = response.body;
    });
  }

  void access_token() async {
    var apiKey = 'OTnz1SyDPI_KEY';
    var authUrl = Uri.parse(
        'https://apiconnect.angelbroking.com/rest/auth/angelbroking/user/v1/loginByPassword');

    var authHeaders = {
      'Content-Type': 'application/json',
    };

    var authPayload = {
      'clientcode': 'kiranmodha@gmail.com',
      'password': 'Angel1234',
      'appid': 'TradingApp',
      'apikey': apiKey,
    };

    var authResponse = await http.post(
      authUrl,
      headers: authHeaders,
      body: jsonEncode(authPayload),
    );

    if (authResponse.statusCode == 200) {
      var authToken = jsonDecode(authResponse.body)['data']['accessToken'];
      print('Authentication successful. Token: $authToken');

      // Now you can use authToken in your subsequent requests
    } else {
      print('Authentication error: ${authResponse.statusCode}');
      print('Response body: ${authResponse.body}');
    }

        setState(() {
      _text = authResponse.body;
    });
  }
}
