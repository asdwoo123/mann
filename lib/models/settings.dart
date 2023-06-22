import 'package:flutter/material.dart';

class CameraSettings {
  bool active;
  int width;
  int height;
  int fps;
  String encoding;
  int quality;
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController fpsController = TextEditingController();

  CameraSettings({
    required this.active,
    required this.width,
    required this.height,
    required this.fps,
    required this.encoding,
    required this.quality,
  });

  factory CameraSettings.fromJson(Map<String, dynamic> json) {
    CameraSettings cameraSettings = CameraSettings(
      active: json['active'] ?? false,
      width: json['width'] ?? 1280,
      height: json['height'] ?? 960,
      fps: json['fps'] ?? 15,
      encoding: json['encoding'] ?? 'JPEG',
      quality: json['quality'] ?? 7,
    );
    cameraSettings.widthController.text = cameraSettings.width.toString();
    cameraSettings.heightController.text = cameraSettings.height.toString();
    cameraSettings.fpsController.text = cameraSettings.fps.toString();

    return cameraSettings;
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'width': width,
      'height': height,
      'fps': fps,
      'encoding': encoding,
      'quality': quality,
    };
  }
}

class PantiltSettings {
  bool active;
  int length;
  int speed;
  TextEditingController lengthController = TextEditingController();
  TextEditingController speedController = TextEditingController();

  PantiltSettings({
    required this.active,
    required this.length,
    required this.speed,
  });

  factory PantiltSettings.fromJson(Map<String, dynamic> json) {
    PantiltSettings pantiltSettings = PantiltSettings(
      active: json['active'] ?? false,
      length: json['length'] ?? 10,
      speed: json['speed'] ?? 1000,
    );
    pantiltSettings.lengthController.text = pantiltSettings.length.toString();
    pantiltSettings.speedController.text = pantiltSettings.speed.toString();

    return pantiltSettings;
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'length': length,
      'speed': speed,
    };
  }
}

class RemoteSettings {
  bool active;
  String start;
  String reset;
  String stop;
  String light;
  TextEditingController startController = TextEditingController();
  TextEditingController resetController = TextEditingController();
  TextEditingController stopController = TextEditingController();
  TextEditingController lightController = TextEditingController();

  RemoteSettings({
    required this.active,
    required this.start,
    required this.reset,
    required this.stop,
    required this.light,
  });

  factory RemoteSettings.fromJson(Map<String, dynamic> json) {
    RemoteSettings remoteSettings = RemoteSettings(
      active: json['active'] ?? false,
      start: json['start'] ?? '',
      reset: json['reset'] ?? '',
      stop: json['stop'] ?? '',
      light: json['light'] ?? '',
    );
    remoteSettings.startController.text = remoteSettings.start;
    remoteSettings.resetController.text = remoteSettings.reset;
    remoteSettings.stopController.text = remoteSettings.stop;
    remoteSettings.lightController.text = remoteSettings.light;

    return remoteSettings;
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'start': start,
      'reset': reset,
      'stop': stop,
      'light': light,
    };
  }
}

class SaveSettings {
  bool active;
  String table;
  String complete;
  List<Field> fields;
  TextEditingController tableController = TextEditingController();
  TextEditingController completeController = TextEditingController();

  SaveSettings({
    required this.active,
    required this.table,
    required this.complete,
    required this.fields,
  });

  factory SaveSettings.fromJson(Map<String, dynamic> json) {
    List<Field> fieldsList = [];
    if (json['fields'] != null) {
      json['fields'].forEach((v) {
        fieldsList.add(Field.fromJson(v));
      });
    }

    SaveSettings saveSettings = SaveSettings(
      active: json['active'] ?? false,
      table: json['table'] ?? '',
      complete: json['complete'] ?? '',
      fields: fieldsList,
    );
    saveSettings.tableController.text = saveSettings.table;
    saveSettings.completeController.text = saveSettings.complete;

    return saveSettings;
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'table': table,
      'complete': complete,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }
}

class Field {
  String name;
  String nodeId;
  TextEditingController nameController = TextEditingController();
  TextEditingController nodeIdController = TextEditingController();

  Field({
    required this.name,
    required this.nodeId,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    Field field = Field(
      name: json['name'] ?? '',
      nodeId: json['nodeId'] ?? '',
    );
    field.nameController.text = field.name;
    field.nodeIdController.text = field.nodeId;

    return field;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nodeId': nodeId,
    };
  }
}

class Node {
  String name;
  String nodeId;
  bool visible;
  TextEditingController nameController = TextEditingController();
  TextEditingController nodeIdController = TextEditingController();

  Node({
    required this.name,
    required this.nodeId,
    required this.visible,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    Node node = Node(
      name: json['name'] ?? '',
      nodeId: json['nodeId'] ?? '',
      visible: json['visible'] ?? false,
    );
    node.nameController.text = node.name;
    node.nodeIdController.text = node.nodeId;

    return node;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nodeId': nodeId,
      'visible': visible,
    };
  }
}

class Settings {
  final String ip;
  final String headOffice;
  final String branchOffice;
  String projectName;
  String stationName;
  String endpoint;
  CameraSettings camera;
  PantiltSettings pantilt;
  RemoteSettings remote;
  SaveSettings save;
  List<Node> node;
  TextEditingController projectController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController endpointController = TextEditingController();

  Settings({
    required this.ip,
    required this.headOffice,
    required this.branchOffice,
    required this.projectName,
    required this.stationName,
    required this.endpoint,
    required this.camera,
    required this.pantilt,
    required this.remote,
    required this.save,
    required this.node,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    Settings settings = Settings(
      ip: json['ip'] ?? '',
      headOffice: json['headOffice'] ?? '',
      branchOffice: json['branchOffice'] ?? '',
      projectName: json['projectName'] ?? '',
      stationName: json['stationName'] ?? '',
      endpoint: json['endpoint'] ?? '',
      camera: CameraSettings.fromJson(json['camera']),
      pantilt: PantiltSettings.fromJson(json['pantilt']),
      remote: RemoteSettings.fromJson(json['remote']),
      save: SaveSettings.fromJson(json['save']),
      node: List<Node>.from(json['nodeInfo'].map((x) => Node.fromJson(x))),
    );
    settings.projectController.text = settings.projectName;
    settings.stationController.text = settings.stationName;
    settings.endpointController.text = settings.endpoint;

    return settings;
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'headOffice': headOffice,
      'branchOffice': branchOffice,
      'projectName': projectName,
      'stationName': stationName,
      'endpoint': endpoint,
      'camera': camera.toJson(),
      'pantilt': pantilt.toJson(),
      'remote': remote.toJson(),
      'save': save.toJson(),
      'node': node.map((n) => n.toJson()).toList(),
    };
  }
}
