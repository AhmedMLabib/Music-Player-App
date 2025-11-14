import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Rx;
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SongsController {
  final player = AudioPlayer();
  playAudio(String path) async {
    await player.setAsset("assets/songs/$path");
    await player.play();
  }

  pauseAudio() async {
    await player.pause();
  }

  resumeAudio() async {
    await player.play();
  }

  Stream<DurationState> get durationStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        player.positionStream,
        player.durationStream,

        (position, total) =>
            DurationState(position: position, total: total ?? Duration.zero),
      );

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState({required this.position, required this.total});
}
