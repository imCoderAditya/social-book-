// video_post_item.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPostItem extends StatefulWidget {
  final String videoUrl;

  final bool isCurrentSlide;

  const VideoPostItem({
    super.key,
    required this.videoUrl,
  
    required this.isCurrentSlide,
  });

  @override
  State<VideoPostItem> createState() => _VideoPostItemState();
}

class _VideoPostItemState extends State<VideoPostItem> {
  late VideoPlayerController _controller;
  final GlobalKey _key = GlobalKey();
  bool _showControls = false;
  bool _userPaused = false; // Track if user manually paused

  @override
  void initState() {
    super.initState();

    

    _initializeVideo();
  }


  void _initializeVideo() {
  _controller = VideoPlayerController.networkUrl(
    Uri.parse(widget.videoUrl),
  );

  _controller.initialize().then((_) {
    if (mounted) {
      setState(() {});
      _checkVisibilityAndPlay();
    }
  }).catchError((error) {
    if (mounted) {
      setState(() {}); // UI update to show error
      debugPrint("Video Init Error: $error");
    }
  });

  _controller.addListener(_videoListener);
}

  @override
  void didUpdateWidget(VideoPostItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // When carousel slides change
    if (oldWidget.isCurrentSlide != widget.isCurrentSlide) {
      if (!widget.isCurrentSlide) {
        // Not the current slide anymore - pause immediately
        if (_controller.value.isPlaying) {
          _controller.pause();
        }
        _userPaused = false; // Reset user pause state
      } else {
        // Became the current slide - check visibility
        _checkVisibilityAndPlay();
      }
    }
  }

  @override
  void dispose() {
    // widget.scrollController.removeListener(_handleScroll);
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _videoListener() {
    if (mounted) {
      setState(() {});
    }
  }


  void _checkVisibilityAndPlay() {
    final context = _key.currentContext;
    if (context == null || !_controller.value.isInitialized) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final position = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final widgetHeight = box.size.height;

    final widgetTop = position.dy;
    final widgetBottom = widgetTop + widgetHeight;

    final visibleTop = widgetTop.clamp(0.0, screenHeight);
    final visibleBottom = widgetBottom.clamp(0.0, screenHeight);

    final visibleHeight = visibleBottom - visibleTop;
    final visiblePercent = (visibleHeight / widgetHeight) * 100;

    if (visiblePercent > 50 && widget.isCurrentSlide && !_userPaused) {
      if (!_controller.value.isPlaying) {
        _controller
          ..setLooping(true)
          ..play();
      }
    } else {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _userPaused = true; // User manually paused
        _showControls = true;
      } else {
        _controller.play();
        _userPaused = false; // User manually played
        _showControls = false;
      }
    });

    // Hide controls after 2 seconds if playing
    if (_controller.value.isPlaying) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _controller.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _onVideoTap() {
    setState(() {
      _showControls = !_showControls;
    });

    // Auto-hide controls after 3 seconds if video is playing
    if (_showControls && _controller.value.isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _controller.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if there is an error
  final bool hasError = _controller.value.hasError;

  if (hasError) {
    return Container(
      height: 280,
      width: double.infinity,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 40),
          const SizedBox(height: 10),
          const Text("Video failed to load", style: TextStyle(color: Colors.white)),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _initializeVideo(); // Retry loading
              });
            },
            icon: const Icon(Icons.refresh, color: Colors.blue),
            label: const Text("Retry", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: _onVideoTap,
      child: Container(
        key: _key,
        color: Colors.black,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            
            // Play/Pause button overlay
            AnimatedOpacity(
              opacity: _showControls || !_controller.value.isPlaying ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _controller.value.isPlaying 
                        ? Icons.pause 
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),

            // Progress indicator at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white10,
                ),
                padding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}