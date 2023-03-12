import 'dart:developer';
import 'dart:io';

import 'package:dex_messenger/Screens/ScreenRoomChat/screen_room_chat.dart';
import 'package:dex_messenger/Screens/widgets/dex_button.dart';
import 'package:dex_messenger/Screens/widgets/dex_routes.dart';
import 'package:dex_messenger/core/colors.dart';
import 'package:dex_messenger/core/presentaion_constants.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';

import 'package:dex_messenger/data/states/room_provider.dart';
import 'package:dex_messenger/data/states/recent_room_chat_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ScreenCreateRoom extends StatelessWidget {
  const ScreenCreateRoom({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<RoomProvider>().init();
    });

    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: kScreenPaddingAllMedium,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Create Room',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: colorTextSecondary),
            ),
            kGapHeight30,
            const _DpSection(),
            kGapHeight30,
            const _RoomNameSection(),
            //-------------------------------------------------
            kGapHeight10,
            const RoomTypeSection(),
            kGapHeight30,
            DexButton(
              child: const Text('Create Room'),
              onPressed: () async {
                RoomInfoModel? roomInfoModel =
                    await context.read<RoomProvider>().createRoom();
                if (context.mounted && roomInfoModel != null) {
                  context
                      .read<RecentRoomChatProvider>()
                      .roomInfoModelMap[roomInfoModel.roomID] = roomInfoModel;
                  Navigator.pushReplacement(
                      context,
                      dexRouteSlideFromLeft(
                          nextPage: ScreenRoomChat(
                        roomID: roomInfoModel.roomID,
                        isAdmin: true,
                      )));
                } else {
                  log('create Room returned Null roomInfoModel or context isnt mounted');
                }
              },
            )
          ],
        ),
      ),
    )));
  }
}

class RoomTypeSection extends StatefulWidget {
  const RoomTypeSection({
    super.key,
  });

  @override
  State<RoomTypeSection> createState() => _RoomTypeSectionState();
}

class _RoomTypeSectionState extends State<RoomTypeSection> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: kradiusMedium,
          child: CupertinoTabBar(
              onTap: (value) {
                setState(() {
                  currentIndex = value;
                });
                if (value == 0) {
                  context.read<RoomProvider>().isBroadcastRoom = false;
                } else {
                  context.read<RoomProvider>().isBroadcastRoom = true;
                }
              },
              currentIndex: currentIndex,
              backgroundColor: colorSecondaryBG,
              border: Border.all(width: 0, style: BorderStyle.none),
              items: const [
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.userGroup)),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.towerBroadcast))
              ]),
        ),
        kGapHeight30,
        //-----------------------------------

        currentIndex == 0
            ? const _PublicRoomDescription()
            : const _BroadcastRoomDescription()
      ],
    );
  }
}

class _PublicRoomDescription extends StatelessWidget {
  const _PublicRoomDescription();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LottieBuilder.network(
            'https://assets9.lottiefiles.com/packages/lf20_p5yomfw6.json',
            width: MediaQuery.of(context).size.width / 2.2),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Public Room',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                  'Everyone can send messages and see other participants in Public Room!',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: colorTextSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _BroadcastRoomDescription extends StatelessWidget {
  const _BroadcastRoomDescription();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LottieBuilder.network(
            'https://assets9.lottiefiles.com/packages/lf20_wk7nynfq.json',
            width: MediaQuery.of(context).size.width / 2.2),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Broadcast Room',
                  style: Theme.of(context).textTheme.titleMedium),
              Text('Only admins can send messages and see other participants.',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: colorTextSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomNameSection extends StatelessWidget {
  const _RoomNameSection();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        context.read<RoomProvider>().roomName = value;
      },
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        hintText: 'Room Name',
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: colorTextSecondary),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: colorDisabledBG),
            borderRadius: kradiusMedium),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: colorPrimary),
            borderRadius: kradiusMedium),
        fillColor: colorSecondaryBG,
        filled: true,
      ),
    );
  }
}

class _DpSection extends StatelessWidget {
  const _DpSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(builder: (context, createRoom, _) {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: kradiusCircular,
            child: createRoom.dpFile == null
                ? Image.asset(
                    'assets/roomDp.png',
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    createRoom.dpFile!,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.cover,
                  ),
          ),
          Visibility(
            visible: createRoom.isUploadingDP,
            child: SizedBox(
                height: MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2,
                child: CircularProgressIndicator(
                  color: colorPrimary,
                  strokeWidth: 6,
                )),
          ),
          GestureDetector(
            onTap: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? xFile =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              if (xFile != null) {
                if (context.mounted) {
                  createRoom.setDpFile = File(xFile.path);
                  createRoom.dpUrl = await createRoom.uploadDp();
                }
              } else {
                log("xFile is null");
              }
            },
            child: CircleAvatar(
              backgroundColor: colorPrimary,
              child: Icon(
                Icons.add_a_photo,
                color: colorTextPrimary,
              ),
            ),
          )
        ],
      );
    });
  }
}
