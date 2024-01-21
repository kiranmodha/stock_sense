
class ChartResponse {
  final Chart chart;
  final Stock stock;

  ChartResponse({required this.chart}) : stock = _stock(chart);

  factory ChartResponse.fromJson(Map<String, dynamic> json) {
    return ChartResponse(
      chart: Chart.fromJson(json['chart']),
    );
  }

  static Stock _stock(Chart chart) {
    return Stock(
      symbol: chart.result[0].meta.symbol,
      exchangeName: chart.result[0].meta.exchangeName,
      instrumentType: chart.result[0].meta.instrumentType,
      timezone: chart.result[0].meta.timezone,
      exchangeTimezoneName: chart.result[0].meta.exchangeTimezoneName,
      regularMarketPrice: chart.result[0].meta.regularMarketPrice,
      chartPreviousClose: chart.result[0].meta.chartPreviousClose,
      previousClose: chart.result[0].meta.previousClose,
      timestamp: chart.result[0].timestamp,
      low: chart.result[0].indicators.quote[0].low,
      volume: chart.result[0].indicators.quote[0].volume,
      high: chart.result[0].indicators.quote[0].high,
      open: chart.result[0].indicators.quote[0].open,
      close: chart.result[0].indicators.quote[0].close,
    );
  }

  Meta meta() {
    return chart.result[0].meta;
  }

  List<Quote> quotes() {
    return chart.result[0].indicators.quote;
  }
}

class Chart {
  final List<Result> result;
  final dynamic error;

  Chart({required this.result, required this.error});

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(
      result: (json['result'] as List<dynamic>)
          .map((result) => Result.fromJson(result))
          .toList(),
      error: json['error'],
    );
  }
}

class Result {
  final Meta meta;
  final List<int> timestamp;
  final Indicators indicators;

  Result({
    required this.meta,
    required this.timestamp,
    required this.indicators,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      meta: Meta.fromJson(json['meta']),
      timestamp: (json['timestamp'] as List<dynamic>).cast<int>(),
      indicators: Indicators.fromJson(json['indicators']),
    );
  }
}

class Meta {
  final String currency;
  final String symbol;
  final String exchangeName;
  final String instrumentType;
  final int firstTradeDate;
  final int regularMarketTime;
  final int gmtoffset;
  final String timezone;
  final String exchangeTimezoneName;
  final double regularMarketPrice;
  final double chartPreviousClose;
  final double previousClose;
  final int scale;
  final int priceHint;
  final CurrentTradingPeriod currentTradingPeriod;
  final List<List<int>> tradingPeriods;
  final String dataGranularity;
  final String range;
  final List<String> validRanges;

  Meta({
    required this.currency,
    required this.symbol,
    required this.exchangeName,
    required this.instrumentType,
    required this.firstTradeDate,
    required this.regularMarketTime,
    required this.gmtoffset,
    required this.timezone,
    required this.exchangeTimezoneName,
    required this.regularMarketPrice,
    required this.chartPreviousClose,
    required this.previousClose,
    required this.scale,
    required this.priceHint,
    required this.currentTradingPeriod,
    required this.tradingPeriods,
    required this.dataGranularity,
    required this.range,
    required this.validRanges,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currency: json['currency'],
      symbol: json['symbol'],
      exchangeName: json['exchangeName'],
      instrumentType: json['instrumentType'],
      firstTradeDate: json['firstTradeDate'],
      regularMarketTime: json['regularMarketTime'],
      gmtoffset: json['gmtoffset'],
      timezone: json['timezone'],
      exchangeTimezoneName: json['exchangeTimezoneName'],
      regularMarketPrice: json['regularMarketPrice'].toDouble(),
      chartPreviousClose: json['chartPreviousClose'].toDouble(),
      previousClose: json['previousClose'].toDouble(),
      scale: json['scale'],
      priceHint: json['priceHint'],
      currentTradingPeriod:
          CurrentTradingPeriod.fromJson(json['currentTradingPeriod']),
      tradingPeriods: (json['tradingPeriods'] as List<dynamic>)
          .map((period) => (period as List<dynamic>).cast<int>())
          .toList(),
      dataGranularity: json['dataGranularity'],
      range: json['range'],
      validRanges: (json['validRanges'] as List<dynamic>).cast<String>(),
    );
  }
}

class CurrentTradingPeriod {
  final TradingPeriod pre;
  final TradingPeriod regular;
  final TradingPeriod post;

  CurrentTradingPeriod({
    required this.pre,
    required this.regular,
    required this.post,
  });

  factory CurrentTradingPeriod.fromJson(Map<String, dynamic> json) {
    return CurrentTradingPeriod(
      pre: TradingPeriod.fromJson(json['pre']),
      regular: TradingPeriod.fromJson(json['regular']),
      post: TradingPeriod.fromJson(json['post']),
    );
  }
}

class TradingPeriod {
  final String timezone;
  final int end;
  final int start;
  final int gmtoffset;

  TradingPeriod({
    required this.timezone,
    required this.end,
    required this.start,
    required this.gmtoffset,
  });

  factory TradingPeriod.fromJson(Map<String, dynamic> json) {
    return TradingPeriod(
      timezone: json['timezone'],
      end: json['end'],
      start: json['start'],
      gmtoffset: json['gmtoffset'],
    );
  }
}

class Indicators {
  final List<Quote> quote;

  Indicators({required this.quote});

  factory Indicators.fromJson(Map<String, dynamic> json) {
    return Indicators(
      quote: (json['quote'] as List<dynamic>)
          .map((quote) => Quote.fromJson(quote))
          .toList(),
    );
  }
}

class Quote {
  final List<double> low;
  final List<int> volume;
  final List<double> high;
  final List<double> open;
  final List<double> close;

  Quote({
    required this.low,
    required this.volume,
    required this.high,
    required this.open,
    required this.close,
  });

  // factory Quote.fromJson(Map<String, dynamic> json) {
  //   return Quote(
  //     low: (json['low'] as  List<dynamic>).cast<double>(),
  //     volume: (json['volume'] as List<dynamic>).cast<int>(),
  //     high: (json['high'] as List<dynamic>).cast<double>(),
  //     open: (json['open'] as List<dynamic>).cast<double>(),
  //     close: (json['close'] as List<dynamic>).cast<double>(),
  //   );
  // }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      low: (json['low'] as List<dynamic>)
          .map((e) => e ?? double.nan) // to take care on null value
          .cast<double>()
          .toList(),
      volume: (json['volume'] as List<dynamic>)
          .map((e) => e ?? 0)
          .cast<int>()
          .toList(),
      high: (json['high'] as List<dynamic>)
          .map((e) => e ?? double.nan)
          .cast<double>()
          .toList(),
      open: (json['open'] as List<dynamic>)
          .map((e) => e ?? double.nan)
          .cast<double>()
          .toList(),
      close: (json['close'] as List<dynamic>)
          .map((e) => e ?? double.nan)
          .cast<double>()
          .toList(),
    );
  }
}

class Stock {
  final String symbol;
  final String exchangeName;
  final String instrumentType;
  final String timezone;
  final String exchangeTimezoneName;
  final double regularMarketPrice;
  final double chartPreviousClose;
  final double previousClose;
  final List<int> timestamp;
  final List<double?> low;
  final List<int?> volume;
  final List<double?> high;
  final List<double?> open;
  final List<double?> close;
  Data15Minutes data15Minutes;

  Stock({
    required this.symbol,
    required this.exchangeName,
    required this.instrumentType,
    required this.timezone,
    required this.exchangeTimezoneName,
    required this.regularMarketPrice,
    required this.chartPreviousClose,
    required this.previousClose,
    required this.timestamp,
    required this.low,
    required this.volume,
    required this.high,
    required this.open,
    required this.close,
  }) : data15Minutes = Data15Minutes(
            timestamp: [], low: [], volume: [], high: [], open: [], close: []) {
    populateData_15Minutes(this);
  }

  double? maxNonNull(List<double?> values) {
    values = values.where((value) => value != null).cast<double>().toList();
    return values.isNotEmpty ? values.reduce((a, b) => a! > b! ? a : b) : null;
  }

  double? minNonNull(List<double?> values) {
    values = values.where((value) => value != null).cast<double>().toList();
    return values.isNotEmpty ? values.reduce((a, b) => a! < b! ? a : b) : null;
  }

  double? firstNonNull(List<double?> values) {
    values = values.where((value) => value != null).cast<double>().toList();
    return values.isNotEmpty ? values.first : null;
  }

  double? lastNonNull(List<double?> values) {
    values = values.where((value) => value != null).cast<double>().toList();
    return values.isNotEmpty ? values.last : null;
  }

  int? sumNonNull(List<int?> values) {
    values = values.where((value) => value != null).cast<int>().toList();
    return values.isNotEmpty ? values.reduce((a, b) => a! + b!) : 0;
  }

  void populateData_15Minutes(Stock data) {
    List<int> timestamp = [];
    List<double?> low = [];
    List<int?> volume = [];
    List<double?> high = [];
    List<double?> open = [];
    List<double?> close = [];

    for (int i = 0; i < data.timestamp.length; i += 15) {
      int endIndex =
          (i + 15 <= data.timestamp.length ? i + 15 : data.timestamp.length);

      List<int> chunkTimeStamp = data.timestamp.sublist(i, endIndex);
      timestamp.add(chunkTimeStamp.first);

      List<double?> chunkLow = data.low.sublist(i, endIndex);
      low.add(minNonNull(chunkLow));

      List<int?> chunkVolume = data.volume.sublist(i, endIndex);
      volume.add(sumNonNull(chunkVolume));

      List<double?> chunkHigh = data.high.sublist(i, endIndex);
      high.add(maxNonNull(chunkHigh));

      List<double?> chunkOpen = data.open.sublist(i, endIndex);
      open.add(firstNonNull(chunkOpen));

      List<double?> chunkClose = data.close.sublist(i, endIndex);
      close.add(lastNonNull(chunkClose));
    }

    data15Minutes = Data15Minutes(
      timestamp: timestamp,
      low: low,
      volume: volume,
      high: high,
      open: open,
      close: close,
    );
  }
}

class Data15Minutes {
  final List<int> timestamp;
  final List<double?> low;
  final List<int?> volume;
  final List<double?> high;
  final List<double?> open;
  final List<double?> close;

  Data15Minutes({
    required this.timestamp,
    required this.low,
    required this.volume,
    required this.high,
    required this.open,
    required this.close,
  });
}
