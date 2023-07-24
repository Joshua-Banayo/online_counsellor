import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/core/components/widgets/smart_dialog.dart';
import 'package:online_counsellor/models/session_model.dart';
import 'package:online_counsellor/styles/colors.dart';
import '../../../../../core/components/widgets/custom_input.dart';
import '../../../../../models/session_messages_model.dart';
import '../../../../../services/firebase_fireStore.dart';
import '../../../../../services/firebase_storage.dart';
import '../../../../../state/data_state.dart';

class ImagePreviewPage extends ConsumerStatefulWidget {
  const ImagePreviewPage(this.imageUrls, this.session, {super.key});
  final File imageUrls;
  final SessionModel? session;

  @override
  ConsumerState<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends ConsumerState<ImagePreviewPage> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            //close button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.black))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: FileImage(widget.imageUrls), fit: BoxFit.cover)),
            )),

            const SizedBox(height: 10),
            //add caption and send button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      hintText: 'Type caption',
                      controller: _captionController,
                      onChanged: (value) {},
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                sendMessages();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: primaryColor,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )

            //send button
          ]),
        ),
      ),
    );
  }

  void sendMessages() async {
    //show loading
    CustomDialog.showLoading(
      message: 'Sending media files...',
    );

    String mediaUrls = await CloudStorageServices.sendFile(
        widget.imageUrls, widget.session!.id!);
    var session = widget.session!;

    //send message to firebase firestore
    var uid = ref.watch(userProvider).id;
    var receiverId =
        uid == session.userId ? session.counsellorId! : session.userId;
    var receiverName =
        uid == session.userId ? session.counsellorName! : session.userName;
    var receiverImage =
        uid == session.userId ? session.counsellorImage! : session.userImage!;
    SessionMessagesModel messagesModel = SessionMessagesModel();
    messagesModel.message = _captionController.text;
    messagesModel.type = 'image';
    messagesModel.senderId = uid;
    messagesModel.senderName = ref.watch(userProvider).name;
    messagesModel.senderImage = ref.watch(userProvider).profile;
    messagesModel.receiverId = receiverId;
    messagesModel.receiverName = receiverName;
    messagesModel.receiverImage = receiverImage;
    messagesModel.isRead = false;
    messagesModel.mediaFile = mediaUrls;
    messagesModel.createdAt = DateTime.now().millisecondsSinceEpoch;
    messagesModel.id = FireStoreServices.getDocumentId('',
        collection: FirebaseFirestore.instance
            .collection('sessions')
            .doc(session.id)
            .collection('messages'));
    messagesModel.sessionId = session.id;
    var result = await FireStoreServices.addSessionMessages(messagesModel);
    if (result) {
      setState(() {
        _captionController.clear();
      });
      //close loading
      CustomDialog.dismiss();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
