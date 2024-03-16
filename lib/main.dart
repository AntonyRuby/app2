import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

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
      // Attach a listener to the deep link stream
      // This will listen for any incoming deep links
      // and handle them accordingly
      final initialLink = await getInitialLink();
      _handleDeepLink(initialLink); // Pass null safely, if needed
      linkStream.listen((String? link) {
        // Note the nullable type String?
        if (link != null && link.isNotEmpty) {
          _handleDeepLink(link);
        }
      }, onError: (err) {
        print('Error: $err');
      });
    } on PlatformException {
      print('Error initializing deep link listener.');
    }
  }

  // Modify the _handleDeepLink method in the ChildApp to include Dubai in the cities list
  void _handleDeepLink(String? link) {
    if (link != null) {
      Uri uri = Uri.parse(link);
      setState(() {
        selectedCountry = uri.queryParameters['country'] ?? '';
        if (selectedCountry == 'USA') {
          cities = ['New York', 'Los Angeles', 'Chicago'];
        } else if (selectedCountry == 'Canada') {
          cities = ['Toronto', 'Vancouver', 'Montreal'];
        } else if (selectedCountry == 'UK') {
          cities = ['London', 'Manchester', 'Birmingham'];
        } else if (selectedCountry == 'UAE') {
          cities = ['Abu Dhabi', 'Dubai', 'Sharjah'];
        } else {
          cities = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
