// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:basic/play_session/boss_rush.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../game_internals/score.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class LoseGameScreen extends StatelessWidget {
  final Score score;

  const LoseGameScreen({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gap,
            const Center(
              child: Text(
                'You Lost...',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            // Center(
            //   child: Text(
            //     'Score: ${score.score}\n'
            //     'Time: ${score.formattedTime}',
            //     style: const TextStyle(
            //         fontFamily: 'Permanent Marker', fontSize: 20),
            //   ),
            // ),
          ],
        ),
        rectangularMenuArea: 
            Row(
                  children: [
                    MyButton(
                      onPressed: () {
                        //FIXME: really dumb placeholder way to get the "reset game" logic down, 
                        //if a better solution is found before the deadline, use it
                        while (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          }
                        GoRouter.of(context).go("/play");
                      },
                      child: const Text('Try Again'),
                    ),
                    MyButton(
                      onPressed: () {
                          while (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          }
                      },
                      child: const Text('Quit'),
                    ),                
            ],
          ),
        )
      
    );
  }
}
