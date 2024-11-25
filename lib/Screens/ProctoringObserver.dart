import 'package:flutter/material.dart';

class ProctoringObserver extends StatefulWidget {
  final Widget child;

  const ProctoringObserver({Key? key, required this.child}) : super(key: key);

  @override
  _ProctoringObserverState createState() => _ProctoringObserverState();
}

class _ProctoringObserverState extends State<ProctoringObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Navigate to login page if the app is paused or inactive
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login', // Replace with your login route
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
