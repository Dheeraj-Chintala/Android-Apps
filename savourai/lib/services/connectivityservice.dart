import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  bool _isDialogShowing = false;

  Future<void> checkConnectivity(BuildContext context) async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    for (var result in results) {
      _showConnectivityStatus(context, result);
    }

    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      for (var result in results) {
        _showConnectivityStatus(context, result);
      }
    });
  }

  void _showConnectivityStatus(
    BuildContext context,
    ConnectivityResult result,
  ) {
    if (result == ConnectivityResult.none) {
      if (!_isDialogShowing) {
        _showNoConnectionDialog(context);
      }
    } else {
      if (_isDialogShowing) {
        _isDialogShowing = false;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void _showNoConnectionDialog(BuildContext context) {
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: LottieBuilder.asset('assets/noconnection.json'),
        );
      },
    );
  }
}
