import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_game/game/box_game.dart';

import 'fly.dart';

/*
 * 猛男苍蝇
 */
class MachoFly extends Fly {
  double get speed => game.tileSize * 2.5;

  MachoFly(BoxGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1.35, game.tileSize * 1.35);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/macho-fly-1.png'));
    flyingSprite.add(Sprite('flies/macho-fly-2.png'));
    deadSprite = Sprite('flies/macho-fly-dead.png');
  }

}