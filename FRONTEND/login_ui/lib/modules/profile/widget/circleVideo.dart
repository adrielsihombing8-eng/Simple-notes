import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Circlevideo extends StatefulWidget {
  final String VideoPath;
  const Circlevideo({required this.VideoPath, super.key});

  @override
  State<Circlevideo> createState() => _CirclevideoState();
}

class _CirclevideoState extends State<Circlevideo> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.asset(widget.VideoPath)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        controller.setLooping(true);
        controller.play();
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 100,
        height: 100,
        child: controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
