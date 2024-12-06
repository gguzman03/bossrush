import 'package:basic/play_session/boss_rush.dart';
import 'package:basic/settings/settings.dart';
import 'package:basic/style/responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/my_button.dart';
import '../style/palette.dart';

class PauseScreen extends StatelessWidget {

  final BossRush game;
  const PauseScreen({required this.game, super.key});
  //const PauseScreen({super.key});
  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();
    return Scaffold(
        backgroundColor: palette.backgroundSettings,
        body: ResponsiveScreen(
            squarishMainArea: ListView(children: [
              _gap,
              Text("Paused",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Permanent Marker', fontSize: 55, height: 1)),
              //FIXME: placeholder layout for functionality
              _gap,
              ValueListenableBuilder<bool>(
                valueListenable: settings.soundsOn,
                builder: (context, soundsOn, child) => _SettingsLine(
                  'Sound FX',
                  Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off),
                  onSelected: settings.toggleSoundsOn,
                ),
              ),
              _gap,
              ValueListenableBuilder<bool>(
                valueListenable: settings.musicOn,
                builder: (context, musicOn, child) => _SettingsLine(
                  'Music',
                  Icon(musicOn ? Icons.music_note : Icons.music_off),
                  onSelected: settings.toggleMusicOn,
                ),
              ),

              _gap,
            ]),
            rectangularMenuArea: Expanded(
              child: Row(
                children: [
                  //resume button
                  MyButton(
                      onPressed: () {
                        //do nothing, resume engine, then pop 
                        GoRouter.of(context).pop();
                        game.resumeEngine();
                       
                      },
                      child: const Text("Resume")),

                  //quit button
                  MyButton(
                      onPressed: () {
                        while (GoRouter.of(context).canPop()) {
                          GoRouter.of(context).pop();
                        }
                      },
                      child: const Text("Quit"))
                ],
              ),
            )));
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
