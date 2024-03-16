import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedCountry = '';
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    try {
      final initialLink = await getInitialLink();
      _handleDeepLink(initialLink);
      linkStream.listen((String? link) {
        if (link != null && link.isNotEmpty) {
          _handleDeepLink(link);
        }
      }, onError: (err) {});
    } on PlatformException {
      print('Error initializing deep link listener.');
    }
  }

  void _handleDeepLink(String? link) {
    if (link != null) {
      Uri uri = Uri.parse(link);
      String? authToken = uri.queryParameters['token'];
      if (_isValidAuthToken(authToken)) {
        setState(() {
          selectedCountry = uri.queryParameters['country'] ?? '';
          _loadCities(selectedCountry);
        });
      } else {
        print('Invalid or missing authentication token. Access denied.');
      }
    }
  }

  bool _isValidAuthToken(String? authToken) {
    // Simulated token validation
    return authToken == 'sample_auth_token';
  }

  void _loadCities(String country) {
    if (country == 'USA') {
      cities = ['New York', 'Los Angeles', 'Chicago'];
    } else if (country == 'Canada') {
      cities = ['Toronto', 'Vancouver', 'Montreal'];
    } else if (country == 'UK') {
      cities = ['London', 'Manchester', 'Birmingham'];
    } else if (country == 'UAE') {
      cities = ['Abu Dhabi', 'Dubai', 'Sharjah'];
    } else {
      cities = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cities in $selectedCountry'),
        ),
        body: Center(
          child: selectedCountry.isEmpty
              ? const Text('Waiting for country selection...')
              : ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cities[index]),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
