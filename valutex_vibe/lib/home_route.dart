import 'package:flutter/material.dart';
import 'currency.dart';

class HomeRoute extends StatelessWidget {
  final activeCountryCurrencyNames = <String>[
    'Europe',
    'United States of America',
    'Thailand',
    'Vietnam',
  ]; //<Currency>[];
  double baseValue = 1.0;

  Widget _buildCurrencyWidgets(List<Widget> currencies) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        return currencies[index];
      },
      itemCount: currencies.length * 2 - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Currency> _activeCountryCurrencyWidgets = <Currency>[];

    for (var i = 0; i < activeCountryCurrencyNames.length; i++) {
      _activeCountryCurrencyWidgets.add(Currency(
        countryName: activeCountryCurrencyNames[i],
        flagCode: 'eu',
        currencyName: 'euro',
        currencyCode: 'eur',
        currencySymbol: '€',
      ));
    }

    final appBar = AppBar(
      title: Text('Currency converter'),
      actions: <Widget>[
        new IconButton(
            icon: new Icon(Icons.playlist_add),
            onPressed: () => debugPrint("Add element!")),
        new IconButton(
            icon: new Icon(Icons.wrap_text),
            onPressed: () => debugPrint("Sort element!")),
        new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () => debugPrint('Refresh'))
      ],
    );

    final listView = _buildCurrencyWidgets(_activeCountryCurrencyWidgets);

    /*final body = Container(
      child: Currency(
        countryName: 'Italy',
        flagCode: 'IT',
        currencyName: 'Euro',
        currencyCode: 'EUR',
        currencySymbol: '€',
      ),
    );*/

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
