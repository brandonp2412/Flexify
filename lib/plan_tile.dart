import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/start_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanTile extends StatelessWidget {
  const PlanTile({
    super.key,
    required this.plan,
    required this.weekday,
    required this.index,
    required this.navigatorKey,
    required this.refresh,
  });

  final Plan plan;
  final String weekday;
  final int index;
  final GlobalKey<NavigatorState> navigatorKey;
  final Future<void> Function() refresh;

  List<InlineSpan> getChildren(BuildContext context) {
    List<InlineSpan> result = [];

    final split = plan.days.split(',');
    for (int index = 0; index < split.length; index++) {
      final day = split[index];
      result.add(
        TextSpan(
          text: day.trim(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: weekday == day.trim() ? FontWeight.bold : null,
                decoration:
                    weekday == day.trim() ? TextDecoration.underline : null,
              ),
        ),
      );
      if (index < split.length - 1)
        result.add(
            TextSpan(text: ", ", style: Theme.of(context).textTheme.bodyLarge));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsState>();
    Widget title = const Text("Daily");
    if (plan.title?.isNotEmpty == true)
      title = Text(plan.title!);
    else if (plan.days.split(',').length < 7)
      title = RichText(text: TextSpan(children: getChildren(context)));

    return ListTile(
      title: title,
      subtitle: Text(plan.exercises.split(',').join(', ')),
      trailing: Visibility(
        visible: settingsState.showReorder,
        child: ReorderableDragStartListener(
            index: index, child: const Icon(Icons.drag_handle)),
      ),
      onTap: () {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => StartPlanPage(
              plan: plan,
              refresh: refresh,
            ),
          ),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPlanPage(
                          plan: plan.toCompanion(false),
                        ),
                      ),
                    );
                    await refresh();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete this plan?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () async {
                                Navigator.pop(context);
                                await db.delete(db.plans).delete(plan);
                                await refresh();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
