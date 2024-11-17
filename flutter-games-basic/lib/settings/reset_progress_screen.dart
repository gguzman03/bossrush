import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
//import '../style/responsive_screen.dart';
//import 'custom_name_dialog.dart';
//import 'settings.dart';

class ResetProgressScreen extends StatelessWidget {
  const ResetProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();
    return Scaffold(
        backgroundColor: palette.backgroundSettings,
        body: Center(
            child: Column(children: [
          Text("Reset Progress?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Permanent Marker', fontSize: 55, height: 1)),
          //TODO: implement buttons, one yes, one no
          //FIXME: change to grid structure

          SizedBox(
            width: 150,
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                //yes button

                MyButton(
                    onPressed: () {
                      context.read<PlayerProgress>().reset();
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.showSnackBar(
                        const SnackBar(
                            content: Text('Player progress has been reset.')),
                      );
                      GoRouter.of(context).pop();
                    },
                    child: const Text("Yes")),

                //no button
                MyButton(
                    onPressed: () {
                      //do nothing, then pop
                      GoRouter.of(context).pop();
                    },
                    child: const Text("No"))
              ],
            ),
          )
        ])));
  }
}
