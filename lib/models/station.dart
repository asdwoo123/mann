import 'package:mann/constants.dart';

class Station {
  final String stationName;
  final String uuid;
  bool isConnect;
  bool isCamera;
  bool isPantilt;
  bool isRemote;
  Map<String, dynamic> data;

  Station({
    required this.stationName,
    required this.uuid,
    required this.isConnect,
    required this.isCamera,
    required this.isPantilt,
    required this.isRemote,
    required this.data,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationName: json['stationName'] ?? '',
      uuid: json['uuid'] ?? '',
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
      'uuid': uuid,
      'isConnect': isConnect,
      'isCamera': isCamera,
      'isPantilt': isPantilt,
      'isRemote': isRemote,
      'data': data,
    };
  }
}



