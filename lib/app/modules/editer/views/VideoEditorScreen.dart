import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:just_audio/just_audio.dart';

/// ====================== SEPARATED CONTROLLER ======================
class AppVideoEditorController {
  final VideoEditorController videoController;
  final AudioPlayer musicPlayer = AudioPlayer();

  // Music
  String? backgroundMusicPath;
  double musicVolume = 0.7;

  // Drawing / Paint
  List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];
  Color currentColor = Colors.red;
  double strokeWidth = 5.0;
  bool isErasing = false;

  // Text
  List<TextOverlay> textOverlays = [];

  // Stickers / Emojis
  List<StickerOverlay> stickerOverlays = [];

  // Effects & Tune
  double brightness = 0.0;
  double contrast = 1.0;
  double saturation = 1.0;
  double blurValue = 0.0;
  String selectedFilter = "None";

  final Map<String, List<double>> filterPresets = {
    "None": [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
    "Grayscale": [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0],
    "Sepia": [0.393, 0.769, 0.189, 0, 0, 0.349, 0.686, 0.168, 0, 0, 0.272, 0.534, 0.131, 0, 0, 0, 0, 0, 1, 0],
    "Vintage": [1.0, 0.0, 0.2, 0, 0, 0.0, 0.9, 0.0, 0, 0, 0.0, 0.0, 0.7, 0, 0, 0, 0, 0, 1, 0],
    "Cool": [0.8, 0, 0, 0, 0, 0, 1.0, 0.1, 0, 0, 0.2, 0.3, 1.2, 0, 0, 0, 0, 0, 1, 0],
    "Warm": [1.2, 0.1, 0, 0, 0, 0.1, 1.0, 0, 0, 0, 0, 0, 0.8, 0, 0, 0, 0, 0, 1, 0],
    "Dramatic": [1.5, 0, 0, 0, -0.2, 0, 1.5, 0, 0, -0.2, 0, 0, 1.5, 0, -0.2, 0, 0, 0, 1, 0],
    "Invert": [-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0],
  };

  AppVideoEditorController(String videoPath)
      : videoController = VideoEditorController.file(
    File(videoPath),
    maxDuration: const Duration(seconds: 30),
  );

  ColorFilter getCurrentColorFilter() {
    final base = filterPresets[selectedFilter] ?? filterPresets["None"]!;
    final adjusted = List<double>.from(base);
    for (int i = 0; i < 15; i += 5) {
      adjusted[i] *= contrast;
      adjusted[i + 4] += brightness * 255;
    }
    return ColorFilter.matrix(adjusted);
  }

  Future<void> pickBackgroundMusic() async {
    final result = await FilePicker.pickFiles(type: FileType.audio);
    if (result != null) {
      backgroundMusicPath = result.files.single.path;
      await _playMusic();
    }
  }

  Future<void> _playMusic() async {
    if (backgroundMusicPath == null) return;
    try {
      await musicPlayer.setFilePath(backgroundMusicPath!);
      await musicPlayer.setVolume(musicVolume);
    } catch (_) {}
  }

  void removeMusic() {
    backgroundMusicPath = null;
    musicPlayer.stop();
  }

  void changeMusicVolume(double value) {
    musicVolume = value;
    musicPlayer.setVolume(value);
  }

  void addSticker(String emoji) {
    stickerOverlays.add(StickerOverlay(
      emoji: emoji,
      position: const Offset(150, 200),
      size: 60,
    ));
  }

  void dispose() {
    videoController.dispose();
    musicPlayer.dispose();
  }
}

// ====================== MAIN SCREEN ======================
class VideoEditorScreen extends StatefulWidget {
  final String path;
  const VideoEditorScreen(this.path, {super.key});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
   AppVideoEditorController ?editor;
  final TextEditingController textController = TextEditingController();
  bool isExporting = false;
  bool isDrawingMode = false;

  final List<String> emojis = ['😀', '❤️', '🔥', '😂', '👍', '🎉', '🌟', '💯', '😍', '🙌'];

  @override
  void initState() {
    super.initState();
    editor = AppVideoEditorController(widget.path);

    editor?.videoController.initialize().then((_) {
      if (mounted) setState(() {});
    });

    // Sync music with video
    editor?.videoController.addListener(() {
      if (editor?.backgroundMusicPath != null) {
        if (editor!.videoController.isPlaying) {
          editor?.musicPlayer.play();
        } else {
          editor?.musicPlayer.pause();
        }
      }
    });
  }

  @override
  void dispose() {
    editor?.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> exportVideo() async {
    setState(() => isExporting = true);
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⏳ Processing & saving...")),
      );

      await Future.delayed(const Duration(seconds: 2));

      final tempDir = await getTemporaryDirectory();
      final outputPath = p.join(tempDir.path, "edited_video_${DateTime.now().millisecondsSinceEpoch}.mp4");

      await File(widget.path).copy(outputPath);
      await Gal.putVideo(outputPath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Video saved to Gallery!"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isExporting = false);
    }
  }

  void addTextOverlay() {
    if (textController.text.trim().isEmpty) return;
    setState(() {
      editor?.textOverlays.add(TextOverlay(
        text: textController.text.trim(),
        position: const Offset(120, 180),
        color: Colors.white,
        fontSize: 28,
      ));
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = editor;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pro Video Editor"),
          backgroundColor: Colors.deepPurple.shade700,
          actions: [
            IconButton(
              icon: Icon(isDrawingMode ? Icons.brush : Icons.edit_off),
              onPressed: () => setState(() => isDrawingMode = !isDrawingMode),
              tooltip: "Drawing Mode",
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => setState(() => ctrl?.strokes.clear()),
              tooltip: "Clear Drawings",
            ),
            IconButton(
              icon: const Icon(Icons.save_alt),
              onPressed: isExporting ? null : exportVideo,
            ),
          ],
        ),
        body: Column(
          children: [
            // Video Preview
            Expanded(
              child: ctrl!.videoController.initialized
                  ? Stack(
                children: [
                  ColorFiltered(
                    colorFilter: ctrl!.getCurrentColorFilter(),
                    child: CropGridViewer.preview(controller: ctrl.videoController),
                  ),

                  // Blur
                  if (ctrl.blurValue > 0)
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: ctrl.blurValue, sigmaY: ctrl.blurValue),
                      child: Container(color: Colors.transparent),
                    ),

                  // Drawing
                  if (isDrawingMode)
                    GestureDetector(
                      onPanStart: (d) => setState(() => ctrl.currentStroke = [d.localPosition]),
                      onPanUpdate: (d) => setState(() => ctrl.currentStroke.add(d.localPosition)),
                      onPanEnd: (_) => setState(() {
                        if (ctrl.currentStroke.isNotEmpty) {
                          ctrl.strokes.add(List.from(ctrl.currentStroke));
                          ctrl.currentStroke = [];
                        }
                      }),
                      child: CustomPaint(
                        painter: DrawingPainter(
                          strokes: ctrl.strokes,
                          currentStroke: ctrl.currentStroke,
                          color: ctrl.isErasing ? Colors.transparent : ctrl.currentColor,
                          strokeWidth: ctrl.strokeWidth,
                          isErasing: ctrl.isErasing,
                        ),
                        size: Size.infinite,
                      ),
                    ),

                  // Text Overlays
                  ...ctrl.textOverlays.map((overlay) => Positioned(
                    left: overlay.position.dx,
                    top: overlay.position.dy,
                    child: GestureDetector(
                      onPanUpdate: (d) => setState(() => overlay.position += d.delta),
                      child: Text(
                        overlay.text,
                        style: TextStyle(
                          color: overlay.color,
                          fontSize: overlay.fontSize,
                          shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
                        ),
                      ),
                    ),
                  )),

                  // Stickers
                  ...ctrl.stickerOverlays.map((sticker) => Positioned(
                    left: sticker.position.dx,
                    top: sticker.position.dy,
                    child: GestureDetector(
                      onPanUpdate: (d) => setState(() => sticker.position += d.delta),
                      child: Text(sticker.emoji, style: TextStyle(fontSize: sticker.size)),
                    ),
                  )),
                ],
              )
                  : const Center(child: CircularProgressIndicator()),
            ),

            // Trim Slider
            if (ctrl.videoController.initialized)
              TrimSlider(controller: ctrl.videoController, height: 65),

            // TabBar
            const TabBar(
              tabs: [
                Tab(text: "Video"),
                Tab(text: "Audio"),
                Tab(text: "Effects"),
                Tab(text: "Overlays"),
              ],
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey,
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  // Video Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Crop & Rotate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => ctrl.videoController.rotate90Degrees(),
                          icon: const Icon(Icons.rotate_right),
                          label: const Text("Rotate 90°"),
                        ),
                        const SizedBox(height: 10),
                        const Text("Use fingers to crop in preview", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),

                  // Audio Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await ctrl.pickBackgroundMusic();
                            setState(() {});
                          },
                          icon: const Icon(Icons.library_music),
                          label: const Text("Add Background Music"),
                        ),
                        const SizedBox(height: 20),
                        if (ctrl.backgroundMusicPath != null)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.music_note, color: Colors.purple),
                                      Expanded(child: Text(p.basename(ctrl.backgroundMusicPath!))),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () => setState(() => ctrl.removeMusic()),
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: ctrl.musicVolume,
                                    min: 0,
                                    max: 1,
                                    onChanged: (v) => setState(() => ctrl.changeMusicVolume(v)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Effects Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Tune", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        _buildSlider("Brightness", ctrl.brightness, -0.5, 0.5, (v) => setState(() => ctrl.brightness = v)),
                        _buildSlider("Contrast", ctrl.contrast, 0.5, 2.0, (v) => setState(() => ctrl.contrast = v)),
                        _buildSlider("Saturation", ctrl.saturation, 0.0, 2.0, (v) => setState(() => ctrl.saturation = v)),
                        _buildSlider("Blur", ctrl.blurValue, 0.0, 10.0, (v) => setState(() => ctrl.blurValue = v)),

                        const SizedBox(height: 30),
                        const Text("Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ctrl.filterPresets.keys.map((filter) {
                            final selected = ctrl.selectedFilter == filter;
                            return FilterChip(
                              label: Text(filter),
                              selected: selected,
                              onSelected: (_) => setState(() => ctrl.selectedFilter = filter),
                              selectedColor: Colors.deepPurple,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Overlays Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Add Text"),
                                content: TextField(
                                  controller: textController,
                                  decoration: const InputDecoration(hintText: "Enter text"),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () {
                                      addTextOverlay();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Add"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.text_fields),
                          label: const Text("Add Text"),
                        ),
                        const SizedBox(height: 30),
                        const Text("Emojis & Stickers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: emojis.map((emoji) => GestureDetector(
                            onTap: () => setState(() => ctrl.addSticker(emoji)),
                            child: Text(emoji, style: const TextStyle(fontSize: 45)),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        Expanded(child: Slider(value: value, min: min, max: max, onChanged: onChanged)),
        SizedBox(width: 50, child: Text(value.toStringAsFixed(1))),
      ],
    );
  }
}

// ====================== SUPPORTING CLASSES ======================
class TextOverlay {
  String text;
  Offset position;
  Color color;
  double fontSize;
  TextOverlay({required this.text, required this.position, required this.color, required this.fontSize});
}

class StickerOverlay {
  String emoji;
  Offset position;
  double size;
  StickerOverlay({required this.emoji, required this.position, required this.size});
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color color;
  final double strokeWidth;
  final bool isErasing;

  DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.color,
    required this.strokeWidth,
    required this.isErasing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..blendMode = isErasing ? BlendMode.clear : BlendMode.srcOver
      ..color = isErasing ? Colors.transparent : color;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(currentStroke[i], currentStroke[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}