import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_tastebud/core/config/service_locator.dart';
import 'connectivity_service.dart';

class ConnectivityListenerWidget extends StatelessWidget {
  final Widget child;

  const ConnectivityListenerWidget({super.key, required this.child});

  void _showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection',
              style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          content: Text(
            'This app requires an internet connection. Please check your connection and try again.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Call the method to check the connectivity status again
                getIt<ConnectivityCubit>().checkConnectivity();
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityStatus>(
      listener: (context, status) {
        if (status == ConnectivityStatus.disconnected) {
          _showNoInternetDialog(context);
        } else if (status == ConnectivityStatus.connected) {
          // Dismiss the dialog when the connection is restored
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      child: child,
    );
  }
}
