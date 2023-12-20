import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget  {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> cryptoData = [];
  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async{
    final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false'));
    if (response.statusCode == 200) {
      setState(() {
        cryptoData = json.decode(response.body);
      });
    }
    else {
      throw Exception("Falha ao carregar dados.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161820),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Crypto App", 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cryptoData.length,
        itemBuilder: (context, index) {
          final crypto = cryptoData[index];
          final name = crypto['name'];
          final symbol = crypto['symbol'];
          final image = crypto['image'];
          final price = crypto['current_price'];
          final priceChange = crypto['price_change_24h'];
          return ListTile(
            textColor: Colors.white,
            leading: Image.network(image),
            title: Text('$name - $symbol'),
            subtitle: Text("Change: \$${priceChange.toStringAsFixed(2)}"),
            trailing: Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(
              color: Colors.cyan, 
              fontWeight: FontWeight.bold,
              fontSize: 15),
            ),
          );
        }
      ),
    );
  }
} 