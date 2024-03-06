import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int duration = 0;
  int elapsed = 0;

  @override
  void initState() {
    super.initState();
    android.setMethodCallHandler((call) async {
      if (call.method == 'tick')
        setState(() {
          int secondsLeft = call.arguments[0];
          int secondsTotal = call.arguments[1];
          elapsed = secondsTotal - secondsLeft;
          duration = secondsTotal;
        });
    });
    android.invokeMethod('getProgress').then((args) => setState(() {
          int secondsLeft = args[0];
          int secondsTotal = args[1];
          elapsed = secondsTotal - secondsLeft;
          duration = secondsTotal;
        }));
  }

  get minutes => ((duration - elapsed) ~/ 60).toString().padLeft(2, '0');
  get seconds => ((duration - elapsed) % 60).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 32.0),
                Text(
                  "$minutes:$seconds",
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    android.invokeMethod('add');
                    setState(() {
                      if (duration == 0)
                        duration += 61; // Immediately show progress at first.
                      else
                        duration += 60;
                      if (elapsed == 0 || elapsed > duration) elapsed = 1;
                    });
                  },
                  child: const Text('+1 min'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const platform = MethodChannel('com.presley.flexify/android');
          platform.invokeMethod('stop');
          setState(() {
            duration = 0;
            elapsed = 0;
          });
        },
        child: const Icon(Icons.stop),
      ),
    );
  }
}
