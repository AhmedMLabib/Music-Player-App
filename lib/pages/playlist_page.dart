import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controllers/songs_controller.dart';
import 'package:get/get.dart' hide Rx;

class PlaylistPage extends StatefulWidget {
  PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final box = Hive.box('favoritesBox');
  final playList = Get.arguments[0] as String;
  final songs = [].obs;
  final currentIndex = 0.obs;
  var first = true;
  final shuffle = false.obs;

  final loopOne = false.obs;

  final songController = SongsController();
  final favorites = [].obs;

  void toggleFavorite(String item) {
    List favorites = box.get('favorites', defaultValue: []);
    if (favorites.contains(item)) {
      favorites.remove(item);
    } else {
      favorites.add(item);
    }
    box.put('favorites', favorites);
    loadFav();
  }

  void loadFav() {
    List fav = box.get('favorites', defaultValue: []);
    if (playList == "Favorite") {
      songs.clear();
      songs.addAll(fav);
    }
    favorites.clear();
    favorites.addAll(fav);
  }

  @override
  void initState() {
    super.initState();
    songController.player.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        if (loopOne.value) {
          // don't change index
        } else if (shuffle.value) {
          currentIndex.value = Random().nextInt(songs.length);
        } else {
          if (currentIndex.value < songs.length - 1) {
            currentIndex.value++;
          } else {
            currentIndex.value = 0;
          }
        }
        songController.playAudio(songs[currentIndex.value]);
      }
    });
    songs.clear();
    songs.addAll(Get.arguments[1] as List);
    loadFav();
  }

  @override
  dispose() {
    songController.player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 21, 21),
      appBar: AppBar(
        title: Text(
          playList,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 21, 21, 21),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(
        () => SafeArea(
          child: songs.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final item = songs[index];
                          return Obx(
                            () => ListTile(
                              tileColor: index == currentIndex.value
                                  ? const Color.fromARGB(255, 57, 57, 57)
                                  : const Color.fromARGB(255, 21, 21, 21),
                              title: Text(
                                "${index + 1}) ${songs[index].split(".")[0]}",
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  favorites.contains(item)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: favorites.contains(item)
                                      ? Colors.red
                                      : null,
                                ),
                                onPressed: () => toggleFavorite(item),
                              ),

                              onTap: () async {
                                first = false;
                                currentIndex.value = index;
                                songController.playAudio(
                                  songs[currentIndex.value],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      color: Color.fromARGB(255, 36, 35, 35),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),

                            child: Obx(
                              () => Text(
                                songs[currentIndex.value].split(".")[0],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => IconButton(
                                  color: shuffle.value
                                      ? Colors.amber
                                      : Colors.white,
                                  disabledColor: Colors.grey,
                                  icon: const Icon(Icons.shuffle, size: 18),
                                  onPressed: () =>
                                      shuffle.value = !shuffle.value,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.skip_previous, size: 35),
                                onPressed: () {
                                  if (currentIndex == 0) {
                                    currentIndex.value = songs.length - 1;
                                  } else {
                                    currentIndex.value--;
                                  }
                                  songController.playAudio(
                                    songs[currentIndex.value],
                                  );
                                },
                              ),

                              StreamBuilder<PlayerState>(
                                stream: songController.player.playerStateStream,
                                builder: (context, snapshot) {
                                  final playing =
                                      snapshot.data?.playing ?? false;
                                  return IconButton(
                                    icon: Icon(
                                      playing
                                          ? Icons.pause_circle
                                          : Icons.play_circle,
                                      color: playing
                                          ? Colors.amber
                                          : Colors.white,
                                      size: 50,
                                    ),
                                    onPressed: () {
                                      if (first) {
                                        songController.playAudio(
                                          songs[currentIndex.value],
                                        );
                                        first = false;
                                        return;
                                      }
                                      playing
                                          ? songController.pauseAudio()
                                          : songController.resumeAudio();
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.skip_next, size: 35),
                                onPressed: () {
                                  if (currentIndex.value == songs.length - 1) {
                                    currentIndex.value = 0;
                                  } else {
                                    currentIndex.value++;
                                  }
                                  songController.playAudio(
                                    songs[currentIndex.value],
                                  );
                                },
                              ),

                              Spacer(),
                              Obx(
                                () => IconButton(
                                  color: loopOne.value
                                      ? Colors.amber
                                      : Colors.white,

                                  icon: const Icon(Icons.loop, size: 18),
                                  onPressed: () =>
                                      loopOne.value = !loopOne.value,
                                ),
                              ),
                            ],
                          ),

                          StreamBuilder<DurationState>(
                            stream: songController.durationStream,
                            builder: (context, snapshot) {
                              final durationState = snapshot.data;
                              final progress =
                                  durationState?.position ?? Duration.zero;
                              final total =
                                  durationState?.total ?? Duration.zero;
                              return Column(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Colors.amber,
                                      inactiveTrackColor: Colors.grey,
                                      thumbColor: Colors.white,
                                      trackHeight: 1,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 27,
                                      ),
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max: total.inMilliseconds.toDouble(),
                                      value: progress.inMilliseconds
                                          .toDouble()
                                          .clamp(
                                            0,
                                            total.inMilliseconds.toDouble(),
                                          ),
                                      onChanged: (value) {
                                        songController.player.seek(
                                          Duration(milliseconds: value.toInt()),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      right: 27,
                                      left: 27,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          songController.formatDuration(
                                            progress,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          songController.formatDuration(total),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    "Playlist Is Empty",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
