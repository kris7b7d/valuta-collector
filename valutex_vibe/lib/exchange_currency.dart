import 'package:flutter/material.dart';

class ExchangeCurrency {
  static final ExchangeCurrency _singleton = ExchangeCurrency._internal();
  factory ExchangeCurrency() {
    return _singleton;
  }
  ExchangeCurrency._internal();

  List<CountryDetails> countryList =
      <CountryDetails>[]; // Data countries details
  Map currencyRates = {}; // Data exchange rates
  String _currencyInput = 'eur';
  num _amountInput = 1.0;
  //String currencySource = 'none'; // Source of exchange rates

  set currencyInput(String currency) {
    _currencyInput = currency;
  }

  set amountInput(num amount) {
    _amountInput = amount;
  }

  set favourites(List<String> favs) {
    countryList.forEach((CountryDetails country) {
      int order = favs.indexOf(country.countryName);
      country.order = order;
      country.fav = (order != -1);
    });
    countryList.sort((CountryDetails a, CountryDetails b) {
      if (a.fav && !b.fav) return -1;
      if (!a.fav && b.fav) return 1;
      if (a.order < b.order) return -1;
      if (a.order > b.order) return 1;
      if (a.countryNormName.toString().compareTo(b.countryNormName.toString()) <
          0) return -1;
      if (a.countryNormName.toString().compareTo(b.countryNormName.toString()) >
          0) return 1;
      return 0;
    });
  }

  List<String> get favourites {
    List<String> favs = [];
    countryList.forEach((CountryDetails country) {
      favs.add(country.countryName);
    });
    return favs;
  }

  set loadCountryList(List json) {
    json.forEach((entry) {
      if (entry['currencySymbol'] == null)
        debugPrint('${entry['countryName']} has no symbol');
      try {
        countryList.add(CountryDetails(
          countryName: entry['countryName'],
          countryNormName: entry['countryNormName'],
          flagCode: entry['flagCode'],
          currencyName: entry['currencyName'],
          currencyCode: entry['currencyCode'],
          currencySymbol:
              (entry['currencySymbol'] != null) ? entry['currencySymbol'] : '',
        ));
      } catch (e) {
        debugPrint("Error ${entry['countryName']}");
      }
    });
  }

  List<CountryDetails> searchCountries(input) {
    List<CountryDetails> result = countryList.where((country) {
      if (input == '') return country.fav;
      if (country.countryNormName.toString().contains(input.toLowerCase()))
        return true;
      if (country.currencyName.toLowerCase().contains(input.toLowerCase()))
        return true;
      if (country.currencyCode.toLowerCase().contains(input.toLowerCase()))
        return true;
      return false;
    }).toList();
    return result;
  }

  num exchange(String cInput, num aInput, String cOutput) {
    cOutput = cOutput.toUpperCase();
    cInput = cInput.toUpperCase();
    num aEuro;
    num aOutput;

    // Convert aInput cInput -> eur
    if (cInput == 'EUR') {
      aEuro = aInput;
    } else {
      aEuro = aInput / currencyRates[cInput];
    }
    // Convert amountEuro euro -> cOutput
    if (cOutput == 'EUR') {
      aOutput = aEuro;
    } else {
      aOutput = aEuro * currencyRates[cOutput];
    }
    return aOutput;
  }

  String normalizeAmount(num inRate, num inAmount) {
    num rate = inRate;
    num amount = inAmount;
    String strAmount;
    int approx = 0;

    if (rate >= 1000) {
      while (rate >= 1000) {
        rate /= 10;
        amount /= 10;
        approx--;
      }
      amount = amount.round();
      if (amount == 0) return '0';
      while (approx < 0) {
        amount *= 10;
        approx++;
      }
      return amount.toString();
    }
    if (rate < 1000) {
      while (rate < 1000) {
        rate *= 10;
        amount *= 10;
        approx++;
      }
      amount = amount.round().toDouble();
      while (approx > 0) {
        amount /= 10.0;
        approx--;
      }
      strAmount = amount.toString();
      int pos = strAmount.indexOf('.') + 3;
      pos = (strAmount.length > pos) ? pos : strAmount.length;
      if (pos != -1) strAmount = strAmount.substring(0, pos);
      return strAmount;
    }
    return amount.round().toString();
  }

  String getCurrentAmount(String currencyOutput) {
    num amountOutput = exchange(_currencyInput, _amountInput, currencyOutput);
    return normalizeAmount(currencyRates[currencyOutput], amountOutput);
  }

  num getMaxAmount(String currencyOutput) {
    num maxEuroAmount = 2000000;
    int digits = 0;
    if (currencyOutput.toUpperCase() == 'EUR') return 10000000;
    num maxAmount = exchange('EUR', maxEuroAmount, currencyOutput);
    digits = maxAmount.round().toString().length + 1;
    maxAmount = int.parse(1.toString().padRight(digits, '0'));
    return maxAmount;
  }
}

class CountryDetails {
  Key key;
  final String countryName;
  final String countryNormName;
  final String flagCode;
  final String currencyName;
  final String currencyCode;
  final String currencySymbol;
  int order;
  bool fav;

  CountryDetails({
    this.key,
    @required this.countryName,
    @required this.countryNormName,
    @required this.flagCode,
    @required this.currencyName,
    @required this.currencyCode,
    @required this.currencySymbol,
    this.order,
    this.fav,
  })  : assert(countryName != null),
        assert(countryNormName != null),
        assert(flagCode != null),
        assert(currencyName != null),
        assert(currencyCode != null),
        assert(currencySymbol != null);
}
