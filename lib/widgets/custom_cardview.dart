import 'package:flutter/material.dart';
import 'package:mann/models/station.dart';
import 'package:mann/theme.dart';
import 'package:mann/widgets/custom_cameraview.dart';
import 'package:mann/widgets/custom_remotesheet.dart';
import 'package:mann/widgets/custom_sharesheet.dart';

class CustomCardView extends StatelessWidget {
  final Station station;

  const CustomCardView({Key? key, required this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 20,
          color: dividerGrey,
        ),
        Card(
          // margin: EdgeInsets.only(bottom: 20),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        station.stationName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    CustomRemoteSheet(station: station),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomCameraView(station: station),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('상태', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),),
                    const Spacer(),
                    Text(
                      (station.isConnect) ? 'Connect' : 'Disconnect',
                      style: const TextStyle(
                          fontSize: 14.0),
                    )
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: station.data.keys.toList().length,
                    itemBuilder: (BuildContext ctx, int idx) {
                      var key = station.data.keys.toList()[idx];
                      var value = station.data.values.toList()[idx];

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3.0, 0, 3.0),
                        child: Row(
                          children: [
                            Text(
                              key,
                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 14.0),
                            )
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }
}
