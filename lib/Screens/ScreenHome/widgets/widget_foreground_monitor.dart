import 'package:flutter/material.dart';

class ForegroundMonitor extends StatefulWidget {
  const ForegroundMonitor({super.key});

  @override
  State<ForegroundMonitor> createState() => _ForegroundMonitorState();
}

class _ForegroundMonitorState extends State<ForegroundMonitor>
    with WidgetsBindingObserver {
  bool isInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      isInForeground = (state == AppLifecycleState.resumed);
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
