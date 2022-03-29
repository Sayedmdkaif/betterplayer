import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:better_player_example/constants.dart';
import 'package:flutter/material.dart';




class PlaceholderUntilPlayPage extends StatefulWidget {
  @override
  _PlaceholderUntilPlayPageState createState() =>
      _PlaceholderUntilPlayPageState();
}

class _PlaceholderUntilPlayPageState extends State<PlaceholderUntilPlayPage> {
  late BetterPlayerController _betterPlayerController;
  StreamController<bool> _placeholderStreamController =
      StreamController.broadcast();
  bool _showPlaceholder = true;

  CustomPainter? kaifPainter;

  @override
  void dispose() {
    _placeholderStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      fit: BoxFit.contain,
      placeholder: _buildVideoPlaceholder(),
      showPlaceholderUntilPlay: true,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      Constants.elephantDreamVideoUrl,
    );
    //i have passed OpenPainter() to draw object on full screen page and its optional
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration,painter:OpenPainter());
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _setPlaceholderVisibleState(false);
      }
    });
    super.initState();
  }

  void _setPlaceholderVisibleState(bool hidden) {
    _placeholderStreamController.add(hidden);
    _showPlaceholder = hidden;
  }

  ///_placeholderStreamController is used only to refresh video placeholder
  ///widget.
  Widget _buildVideoPlaceholder() {
    return StreamBuilder<bool>(
      stream: _placeholderStreamController.stream,
      builder: (context, snapshot) {
        return _showPlaceholder
            ? Image.network(Constants.placeholderUrl)
            : const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Placeholder until play"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Normal player with placeholder shown until video is started.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              CustomPaint(
                foregroundPainter: OpenPainter(),
                child: BetterPlayer(
                  controller: _betterPlayerController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    var a=size.width;

    var paint1 = Paint()
      ..color = Colors.blue
      ..strokeWidth=1
      ..style = PaintingStyle.stroke;





    /// Creates an offset. The first argument sets [dx], the horizontal component,
    /// and the second sets [dy], the vertical component.
    //  canvas.drawRect(Offset(100, 100) & Size(200, 200), paint1);
    canvas.drawRect(Offset(a/2,30) & Size(40, 40), paint1);
    canvas.drawRect(Offset(a/3,30) & Size(40, 40), paint1);
    canvas.drawRect(Offset(a/4.8,30) & Size(40, 40), paint1);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}