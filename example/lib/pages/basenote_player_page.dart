import 'package:better_player/better_player.dart';
import 'package:better_player_example/constants.dart';
import 'package:flutter/material.dart';

class BasenotePlayerPage extends StatefulWidget {
  @override
  _BasenotePlayerPageState createState() => _BasenotePlayerPageState();
}

class _BasenotePlayerPageState extends State<BasenotePlayerPage> {
  late BetterPlayerController _betterPlayerController;
  int _queueIndex = 0;
  final List<BetterPlayerDataSource> _queue = [];

  @override
  void initState() {
    final betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);

    _betterPlayerController.addEventsListener((p0) {
      print(p0.betterPlayerEventType);
    });

    final cacheConfiguration = BetterPlayerCacheConfiguration(
      useCache: true,
      preCacheSize: 10 * 1024 * 1024,
      maxCacheSize: 10 * 1024 * 1024,
      maxCacheFileSize: 10 * 1024 * 1024,
    );

    _queue.add(BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://videodelivery.net/9dd71b21e6694c84bb5f49e906668d01/manifest/video.m3u8",
      cacheConfiguration: cacheConfiguration,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: "Right There Beside You",
        author: "Bronze Radio Return",
        imageUrl: Constants.catImageUrl,
      ),
    ));

    _queue.add(BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://videodelivery.net/352b56abe8ffd9c01b5d498bb99db14d/manifest/video.m3u8",
      cacheConfiguration: cacheConfiguration,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: "Way Out West",
        author: "Shulman Smith",
        imageUrl: Constants.catImageUrl,
      ),
    ));

    _queue.add(BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://videodelivery.net/59b3abe0bcb40bd27bbba1d3646a0c8c/manifest/video.m3u8",
      cacheConfiguration: cacheConfiguration,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: "The Game",
        author: "RinRin",
        imageUrl: Constants.catImageUrl,
      ),
    ));

    _betterPlayerController.setupDataSource(_queue[0]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cache"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Player with cache enabled. To test this feature, first plays "
              "video, then leave this page, turn internet off and enter "
              "page again. You should be able to play video without "
              "internet connection.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
          TextButton(
            child: Text("Skip Next"),
            onPressed: skipNext,
          ),
          TextButton(
            child: Text("Skip Prev"),
            onPressed: skipPrev,
          ),
        ],
      ),
    );
  }

  void skipPrev() {
    if (!hasPrev()) {
      return;
    }
    _queueIndex--;
    _playInternal(_queue[_queueIndex]);
  }

  void skipNext() {
    if (!hasNext()) {
      return;
    }
    _queueIndex++;
    _playInternal(_queue[_queueIndex]);
  }

  bool hasPrev() {
    return _queueIndex > 0;
  }

  bool hasNext() {
    return _queueIndex < _queue.length - 1;
  }

  Future _playInternal(BetterPlayerDataSource source) async {
    if (_betterPlayerController.videoPlayerController != null &&
        (_betterPlayerController.isVideoInitialized() ?? false)) {
      await _betterPlayerController.pause();
    }

    await _betterPlayerController.setupDataSource(source);
    await _betterPlayerController.play();
  }
}
