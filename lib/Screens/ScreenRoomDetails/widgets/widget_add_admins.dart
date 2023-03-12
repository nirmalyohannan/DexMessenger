import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/widgets/search_result_tile.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/data/states/room_provider.dart';
import 'package:dex_messenger/utils/ScreenHome/get_recipent_Info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenAddAdmins extends StatelessWidget {
  ScreenAddAdmins({super.key, required this.roomID});

  final String roomID;
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              kGapHeight30,
              Text(
                "Add Admins",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              kGapHeight15,
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('roomChats')
                      .doc(roomID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    RoomInfoModel roomInfoModel =
                        RoomInfoModel.fromMap(snapshot.data!.data()!);

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: roomInfoModel.membersUID.length,
                        itemBuilder: (context, index) {
                          String recipentUID = roomInfoModel.membersUID[index];
                          return FutureBuilder(
                            future: getRecipentInfo(recipentUID),
                            builder: (context, snapshot) => !snapshot.hasData
                                ? const SizedBox()
                                : ListTile(
                                    title: SearchResultTile(
                                        recipentInfo: snapshot.data!,
                                        trailing: roomInfoModel.adminsUID
                                                .contains(recipentUID)
                                            ? CircleAvatar(
                                                backgroundColor: colorPrimary,
                                                child: IconButton(
                                                    onPressed: () {
                                                      context
                                                          .read<RoomProvider>()
                                                          .removeAdmin(
                                                              snapshot.data!
                                                                  .recipentUID,
                                                              roomID);
                                                    },
                                                    icon: Icon(
                                                      Icons.check,
                                                      color: colorTextPrimary,
                                                    )),
                                              )
                                            : ElevatedButton(
                                                child: const Text('Add'),
                                                onPressed: () {
                                                  context
                                                      .read<RoomProvider>()
                                                      .addAdmin(
                                                          recipentUID, roomID);
                                                },
                                              )),
                                  ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
