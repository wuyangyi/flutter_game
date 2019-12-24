
import 'package:flutter_game/components/fly.dart';
import 'package:flutter_game/game/box_game.dart';

//苍蝇生成控制器
class FlySpawner {
  final BoxGame game;

  final int maxSpawnInterval = 3000; //产生苍蝇的最大时间间隔
  final int minSpawnInterval = 250; //产生苍蝇的最小时间间隔
  final int intervalChange = 3;
  final int maxFliesOnScreen = 7;
  int currentInterval; //当前产生苍蝇的时间间隔
  int nextSpawn; //下一个生成苍蝇的实际时间（以毫秒为单位）


  FlySpawner(this.game) {
    start();
    game.spawnFly();
  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {
    game.flies.forEach((Fly fly) => fly.isDead = true);
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch; //当前时间

    int livingFlies = 0; //当前活着的苍蝇数目
    game.flies.forEach((Fly fly) {
      if (!fly.isDead) livingFlies += 1;
    });

    if (nowTimestamp >= nextSpawn && livingFlies < maxFliesOnScreen) {
      game.spawnFly();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }
}