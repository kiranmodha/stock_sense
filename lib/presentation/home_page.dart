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
  int _counter = 0;
  bool isLoaded = false;

  ChartResponse? chartResponse;

  void _incrementCounter() {
    fetchData().then((value) {
      if (value) {
        setState(() {
          // Your code here
          _counter++;
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

  // Center buildBody(BuildContext context) {
  //   chartResponse!.chart.result[0].indicators.quote[0].open;
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         const Text(
  //           'You have pushed the button this many times:',
  //         ),
  //         if (isLoaded && chartResponse != null)
  //           Wrap(
  //             children: [
  //               Text(chartResponse!.chart.result[0].meta.symbol),
  //               Text(convertTimestampToDateTime(
  //                   chartResponse!.chart.result[0].timestamp[0])),
  //             ],
  //           ),
  //         Text(
  //           '$_counter',
  //           style: Theme.of(context).textTheme.headlineMedium,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Center buildBody(BuildContext context) {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         const Text(
  //           'You have pushed the button this many times:',
  //         ),
  //         if (isLoaded && chartResponse != null)
  //           Wrap(
  //             children: [
  //               ...List.generate(
  //                   5,
  //                   (index) => Column(children: [
  //                         Text(
  //                             'Timestamp ${index + 1}: ${convertTimestampToDateTime(chartResponse!.stockData!.stockData15Minutes!.timestamp[index])}'),
  //                         Text(
  //                             'Open ${index + 1}: ${chartResponse!.stockData!.stockData15Minutes!.open[index]}'),
  //                         Text(
  //                             'Close ${index + 1}: ${chartResponse!.stockData!.stockData15Minutes!.close[index]}'),
  //                       ])),
  //             ],
  //           ),

  //         Text(
  //           '$_counter',
  //           style: Theme.of(context).textTheme.headlineMedium,
  //         ),
  //       ],
  //     ),
  //   );
  // }

Center buildBody(BuildContext context) {
  return Center(
    child: ListView.builder(
      itemCount: chartResponse?.stockData?.stockData15Minutes?.timestamp.length ?? 0,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('Timestamp: ${convertTimestampToDateTime(chartResponse!.stockData!.stockData15Minutes!.timestamp[index])}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Open: ${chartResponse!.stockData!.stockData15Minutes!.open[index]}'),
                Text('Close: ${chartResponse!.stockData!.stockData15Minutes!.close[index]}'),
                Text('High: ${chartResponse!.stockData!.stockData15Minutes!.high[index]}'),
                Text('Low: ${chartResponse!.stockData!.stockData15Minutes!.low[index]}'),
                Text('Volume: ${chartResponse!.stockData!.stockData15Minutes!.volume[index]}'),
              ],
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
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

//import 'dart:core';

String convertTimestampToDateTime(int timestamp) {
  // Convert timestamp to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Add the IST offset (5 hours and 30 minutes)
  dateTime = dateTime.add(Duration(hours: 5, minutes: 30));

  // Format the DateTime to a human-readable string
  String formattedDateTime = dateTime.toLocal().toString();

  return formattedDateTime;
}

// void main() {
//   int timestamp = 1705463100;
//   String result = convertTimestampToDateTime(timestamp);
//   print(result);  // Output: 2024-01-17 09:15:00.000
// }
