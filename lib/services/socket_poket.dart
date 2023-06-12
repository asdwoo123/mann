import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketsPocket {
  final List<IO.Socket> sockets = [];

  static final SocketsPocket _instance = SocketsPocket._internal();

  factory SocketsPocket() => _instance;

  SocketsPocket._internal();

  void addSocket(IO.Socket socket) {
    sockets.add(socket);
  }

  void removeSocket(IO.Socket socket) {
    sockets.remove(socket);
  }

  List<IO.Socket> getSockets() {
    return sockets;
  }
}