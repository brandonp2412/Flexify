import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  String generateTitleText(int duration, int elapsed) {
    final minutes = ((duration - elapsed) ~/ 60).toString().padLeft(2, '0');
    final seconds = ((duration - elapsed) % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final duration = appState.secondsTotal ?? 0;
    final elapsed = (duration) - (appState.secondsLeft ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            progressWidget(context, duration, elapsed),
            textWidget(context, duration, elapsed),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const platform = MethodChannel('com.presley.flexify/android');
          platform.invokeMethod('stop');
        },
        child: const Icon(Icons.stop),
      ),
    );
  }

  SizedBox progressWidget(BuildContext context, int duration, int elapsed) {
    return SizedBox(
      height: 300,
      width: 300,
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.round,
        value: duration == 0 ? 0 : elapsed / duration,
        strokeWidth: 20,
        backgroundColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Column textWidget(BuildContext context, int duration, int elapsed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 32.0),
        Text(
          generateTitleText(duration, elapsed),
          style: TextStyle(
            fontSize: 50.0,
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            android.invokeMethod('add');
            /* TODO: Make update show immediately */
          },
          child: const Text('+1 min'),
        ),
      ],
    );
  }
}
