import 'package:mann/constants.dart';

class Station {
  final String stationName;
  final String connectIp;
  bool isConnect;
  bool isCamera;
  bool isPantilt;
  bool isRemote;
  Map<String, dynamic> data;

  Station({
    required this.stationName,
    required this.connectIp,
    required this.isConnect,
    required this.isCamera,
    required this.isPantilt,
    required this.isRemote,
    required this.data,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationName: json['stationName'] ?? '',
      connectIp: '$host?id=${json["uuid"]}',
      isConnect: json['isConnect'] ?? false,
      isCamera: json['isCamera'] ?? false,
      isPantilt: json['isPantilt'] ?? false,
      isRemote: json['isRemote'] ?? false,
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationName': stationName,
      'connectIp': connectIp,
      'isConnect': isConnect,
      'isCamera': isCamera,
      'isPantilt': isPantilt,
      'isRemote': isRemote,
      'data': data,
    };
  }
}



