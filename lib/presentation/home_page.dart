import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_sense/chart_response.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;

  ChartResponse? chartResponse;

  void _incrementCounter() {
    fetchData().then((value) {
      if (value) {
        setState(() {
          // Your code here
          isLoaded = true;
        });
      }
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    );
  }

  Center buildBody(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: chartResponse?.stock.data15Minutes.timestamp.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Text(convertTimestampToTime(
                  chartResponse!.stock.data15Minutes.timestamp[index])),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Column(
                        children: [
                          Text('open'),
                          Text('high'),
                          Text('low'),
                          Text('close'),
                          Text('volume')
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(children: [
                        Text(formatDouble(
                            chartResponse!.stock.data15Minutes.open[index])),
                        Text(formatDouble(
                            chartResponse!.stock.data15Minutes.high[index])),
                        Text(formatDouble(
                            chartResponse!.stock.data15Minutes.low[index])),
                        Text(formatDouble(
                            chartResponse!.stock.data15Minutes.close[index])),
                        Text(
                            '${chartResponse!.stock.data15Minutes.volume[index]}'),
                      ])
                    ],
                  )
                ],
              ),
              trailing: (chartResponse!.stock.data15Minutes.close[index]! <
                      chartResponse!.stock.data15Minutes.open[index]!)
                  ? const Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                    ),
            ),
          );
        },
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

  Future<bool> fetchData() async {
    const String url =
        'https://query2.finance.yahoo.com/v8/finance/chart/HDFCBANK.NS';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);
        chartResponse = ChartResponse.fromJson(data);
        return true;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }

  String getISTFromTimeStamp(int timeStamp) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).toUtc();
    final istDateTime = dateTime.add(const Duration(hours: 5, minutes: 30));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(istDateTime);
  }

  String convertTimestampToDateTime(int timestamp) {
    // Convert timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    // Add the IST offset (5 hours and 30 minutes)
    // dateTime = dateTime.add(const Duration(hours: 5, minutes: 30));
    // Format the DateTime to a human-readable string
    String formattedDateTime = dateTime.toLocal().toString();
    return formattedDateTime;
  }

//To get data in CSV format
//https://query1.finance.yahoo.com/v7/finance/download/HDFCBANK.NS?period1=1673974171;period2=1705510171;interval=1d;events=history;includeAdjustedClose=true
}

String convertTimestampToDateTime(int timestamp) {
  // Convert timestamp to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Add the IST offset (5 hours and 30 minutes)
  dateTime = dateTime.add(Duration(hours: 5, minutes: 30));

  // Format the DateTime to a human-readable string
  String formattedDateTime = dateTime.toLocal().toString();

  return formattedDateTime;
}

String convertTimestampToTime(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  String formattedTime = DateFormat('HH:mm').format(dateTime);
  return formattedTime;
}

String formatDouble(double? value) {
  return value!.toStringAsFixed(2);
}
