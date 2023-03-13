import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/Screens/ScreenRoomDetails/widgets/widget_add_admins.dart';
import 'package:dex_messenger/Screens/ScreenRoomDetails/widgets/widget_add_members.dart';
import 'package:dex_messenger/Screens/widgets/flight_shuttle_builder.dart';
import 'package:dex_messenger/Screens/widgets/search_result_tile.dart';
import 'package:dex_messenger/core/colors.dart';

import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/data/states/room_provider.dart';
import 'package:dex_messenger/utils/ScreenHome/get_recipent_Info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenRoomDetails extends StatelessWidget {
  const ScreenRoomDetails(
      {super.key, required this.roomID, required this.isAdmin});
  final String roomID;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('roomChats')
                  .doc(roomID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                RoomInfoModel roomInfoModel =
                    RoomInfoModel.fromMap(snapshot.data!.data()!);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _DpSection(roomID: roomID, roomInfoModel: roomInfoModel),
                      kGapHeight30,
                      isAdmin
                          ? Builder(builder: (context) {
                              TextEditingController textEditingController =
                                  TextEditingController(
                                      text: roomInfoModel.name);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: TextFormField(
                                  controller: textEditingController,
                                  onEditingComplete: () {
                                    context.read<RoomProvider>().changeRoomName(
                                        textEditingController.text.trim(),
                                        roomID);
                                  },
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  decoration: InputDecoration(
                                    hintText: 'Room Name',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: colorTextSecondary),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0, color: colorDisabledBG),
                                        borderRadius: kradiusMedium),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: colorPrimary),
                                        borderRadius: kradiusMedium),
                                    fillColor: colorSecondaryBG,
                                    filled: true,
                                  ),
                                ),
                              );
                            })
                          : Text(
                              roomInfoModel.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: colorPrimary),
                            ),
                      kGapHeight30,
                      _AddMemberAndAdminSection(
                          isAdmin: isAdmin, roomID: roomID),
                      Text(
                        'Members',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      _MembersListView(
                          roomInfoModel: roomInfoModel, isAdmin: isAdmin)
                    ],
                  ),
                );
              })),
    );
  }
}

class _MembersListView extends StatelessWidget {
  const _MembersListView({
    required this.roomInfoModel,
    required this.isAdmin,
  });

  final RoomInfoModel roomInfoModel;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: roomInfoModel.membersUID.length,
      itemBuilder: (context, index) => FutureBuilder(
          future: getRecipentInfo(roomInfoModel.membersUID[index]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            RecipentInfoModel recipentInfoModel = snapshot.data!;
            return SearchResultTile(
              recipentInfo: recipentInfoModel,
              subtitle: Visibility(
                visible: roomInfoModel.adminsUID
                    .contains(recipentInfoModel.recipentUID),
                child: const Text('Admin'),
              ),
              trailing: Visibility(
                visible: isAdmin,
                child: TextButton(
                    onPressed: () {
                      context.read<RoomProvider>().removeMember(
                          recipentInfoModel.recipentUID, roomInfoModel.roomID);
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.red),
                    )),
              ),
            );
          }),
    );
  }
}

class _AddMemberAndAdminSection extends StatelessWidget {
  const _AddMemberAndAdminSection({
    required this.isAdmin,
    required this.roomID,
  });

  final bool isAdmin;
  final String roomID;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isAdmin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                log('Add Members Button pressed');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenAddMembers(roomID: roomID),
                    ));
              },
              child: Text(
                'Add Members',
                style: TextStyle(color: colorPrimary),
              )),
          ElevatedButton(
              onPressed: () {
                log('Add Members Button pressed');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenAddAdmins(roomID: roomID),
                    ));
              },
              child: Text(
                'Add Admins',
                style: TextStyle(color: colorPrimary),
              )),
        ],
      ),
    );
  }
}

class _DpSection extends StatelessWidget {
  const _DpSection({
    required this.roomID,
    required this.roomInfoModel,
  });

  final String roomID;
  final RoomInfoModel roomInfoModel;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: roomID,
        flightShuttleBuilder: flightShuttleBuilder,
        child: ClipRRect(
          borderRadius: kradiusMedium,
          child: CachedNetworkImage(
            imageUrl: roomInfoModel.imageUrl,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            fit: BoxFit.cover,
          ),
        ));
  }
}
