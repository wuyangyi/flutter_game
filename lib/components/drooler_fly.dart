import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_game/game/box_game.dart';

import 'fly.dart';

/*
 * 流口水苍蝇
 */
class DroolerFly extends Fly {
  double get speed => game.tileSize * 1.5;

  DroolerFly(BoxGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/drooler-fly-1.png'));
    flyingSprite.add(Sprite('flies/drooler-fly-2.png'));
    deadSprite = Sprite('flies/drooler-fly-dead.png');
  }

}