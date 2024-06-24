import 'package:crypto_price_list/models/coin_model.dart';
import 'package:crypto_price_list/providers/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CryptoListWidget extends StatefulWidget {
  const CryptoListWidget({super.key});

  @override
  State<CryptoListWidget> createState() => _CryptoListWidgetState();
}

class _CryptoListWidgetState extends State<CryptoListWidget> {
  int pageNumber = 0;
  bool buttonDisabled = true;
  int limit = 10;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final repository = Repository();
    await repository.getAllCoins(pageNumber, limit);
  }

  void _incrementPageNumber() {
    setState(() {
      pageNumber = pageNumber + limit;
      buttonDisabled = false;
    });
    _loadData();
  }

  void _decrementPageNumber() {
    setState(() {
      pageNumber = pageNumber - limit;
      if (pageNumber <= 0) {
        pageNumber = 0;
        buttonDisabled = true;
      } else {
        buttonDisabled = false;
      }
    });
    _loadData();
  }

  void _sort() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Name'),
                ),
                Expanded(
                  child: Text('Price'),
                ),
                Expanded(
                  child: Text(
                    '24h',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          Expanded(
            child: FutureBuilder<List<CoinModel>>(
              future: Repository().getAllCoins(pageNumber, limit),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CoinModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final coin = snapshot.data![index];
                      return Column(
                        children: [
                          _buildCoinItem(context, coin),
                          const SizedBox(
                            height: 12.0,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          _buildItemNavigation(context),
        ],
      ),
    );
  }

  Widget _buildCoinItem(BuildContext context, CoinModel coin) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    'https://www.coinlore.com/img/50x50/${coin.nameid}.png',
                    width: 25.0,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const Icon(
                        Icons.question_mark_rounded,
                        size: 25.0,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        coin.name,
                        maxLines: 5,
                      ),
                      Text(
                        coin.symbol,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              coin.price_usd,
            ),
          ),
          Expanded(
            child: Text(
              coin.percent_change_24h,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: double.parse(coin.percent_change_24h) < 0
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemNavigation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: buttonDisabled ? null : _decrementPageNumber,
            icon: Icon(
              Icons.skip_previous_outlined,
              color: buttonDisabled ? Colors.grey : Colors.black,
            ),
          ),
          DropdownButton(
            value: limit,
            onChanged: (int? value) {
              setState(() {
                limit = value!;
              });
              _loadData();
            },
            items: <int>[10, 20, 30, 40, 50].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              );
            }).toList(),
          ),
          IconButton(
            onPressed: _incrementPageNumber,
            icon: const Icon(Icons.skip_next_outlined, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
