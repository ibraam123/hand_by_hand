import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FullScreenAd extends StatefulWidget {
  const FullScreenAd({super.key});

  @override
  State<FullScreenAd> createState() => _FullScreenAdState();
}

class _FullScreenAdState extends State<FullScreenAd> {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // TEST ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Ad loaded successfully');
          _interstitialAd = ad;
          setState(() => _isAdReady = true);

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              setState(() => _isAdReady = false);
              _loadAd(); // prepare next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Failed to show: $error');
              ad.dispose();
              _loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Failed to load ad: $error');
          setState(() => _isAdReady = false);
        },
      ),
    );
  }

  void _showAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      setState(() => _isAdReady = false);
    } else {
      debugPrint('⏳ Ad not ready yet, please wait...');
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full-Screen Ad Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: _isAdReady ? _showAd : null,
          child: const Text('Show Interstitial Ad'),
        ),
      ),
    );
  }
}
