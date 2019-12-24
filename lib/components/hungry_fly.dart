import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_game/game/box_game.dart';

import 'fly.dart';

/*
 * 饥饿的苍蝇
 */
class HungryFly extends Fly {
  HungryFly(BoxGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1.1, game.tileSize * 1.1);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/hungry-fly-1.png'));
    flyingSprite.add(Sprite('flies/hungry-fly-2.png'));
    deadSprite = Sprite('flies/hungry-fly-dead.png');
  }

}