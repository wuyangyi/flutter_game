import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_game/game/box_game.dart';

import 'fly.dart';

/*
 * 敏捷苍蝇
 */
class AgileFly extends Fly {
  double get speed => game.tileSize * 5;

  AgileFly(BoxGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/agile-fly-1.png'));
    flyingSprite.add(Sprite('flies/agile-fly-2.png'));
    deadSprite = Sprite('flies/agile-fly-dead.png');
  }

}