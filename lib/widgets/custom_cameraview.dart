import 'package:flutter/material.dart';
import 'package:mann/constants.dart';
import 'package:mann/models/station.dart';
import 'package:mann/services/network.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

final GlobalKey globalKey = GlobalKey();

class CustomCameraView extends StatelessWidget {
  final Station station;

  const CustomCameraView({
    super.key,
    required this.station
  });

  String get _cameraUrl {
    return '$hostName/camera/stream?id=${station.uuid}';
  }

  String get _remoteUrl {
    return '$hostName/remote/remote?id=${station.uuid}';
  }

  Size _getSize(GlobalKey key) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
  }

  void _handleTouchStart(
      LongPressStartDetails details, String remoteUrl, GlobalKey key) {

    Size size = _getSize(key);
    double width = size.width;
    double height = size.height;
    double x = details.localPosition.dx;
    double y = details.localPosition.dy;

    String action = (x < 90)
        ? 'left'
        : (x > width - 90)
        ? 'right'
        : (y < height / 2)
        ? 'top'
        : 'bottom';

    postHttpRequest(remoteUrl, {'action': action});
  }

  void _handleTouchEnd(LongPressEndDetails details, String remoteUrl) {
    postHttpRequest(_remoteUrl, {'action': 'stop'});
  }

  @override
  Widget build(BuildContext context) {
    return (station.isCamera) ? GestureDetector(
        onLongPressStart: (LongPressStartDetails details) {
          _handleTouchStart(details, _remoteUrl, globalKey);
        },
        onLongPressEnd: (LongPressEndDetails details) {
          _handleTouchEnd(details, _remoteUrl);
        },
        key: globalKey,
        child: Mjpeg(
          stream: _cameraUrl,
          isLive: true,
        )
    )
        : Container();
  }
}
