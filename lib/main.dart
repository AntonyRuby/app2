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
  String? authToken;
  String? userEmail;

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
      }, onError: (err) {
        // Show Snackbar with error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing deep link listener: $err'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } on PlatformException catch (e) {
      // Show Snackbar with platform exception message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initializing deep link listener: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Show Snackbar with generic exception message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initializing deep link listener: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleDeepLink(String? link) {
    if (link != null) {
      Uri uri = Uri.parse(link);
      authToken = uri.queryParameters['token'];
      userEmail = uri.queryParameters['email'];
      if (_isValidAuthToken(authToken)) {
        setState(() {
          selectedCountry = uri.queryParameters['country'] ?? '';
          _loadCities(selectedCountry);
        });
      } else {
        _showErrorSnackBar(
            'Invalid or missing authentication token. Access denied.');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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

  void _logOut() {
    setState(() {
      authToken = null;
      userEmail = null;
      selectedCountry = '';
      cities = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        hintColor: Colors.amber,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Cities in $selectedCountry')),
          actions: [
            if (authToken != null)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logOut,
              ),
          ],
        ),
        body: Center(
          child: selectedCountry.isEmpty
              ? const CircularProgressIndicator()
              : cities.isEmpty
                  ? const Text('No cities available')
                  : ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                            title: Text(
                              cities[index],
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
