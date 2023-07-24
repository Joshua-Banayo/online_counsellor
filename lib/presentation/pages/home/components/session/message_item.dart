import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_counsellor/models/session_messages_model.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../../core/functions.dart';
import '../../../../../state/data_state.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';

class MessageItem extends ConsumerStatefulWidget {
  const MessageItem({super.key, this.message});
  final SessionMessagesModel? message;

  @override
  ConsumerState<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends ConsumerState<MessageItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var message = widget.message;
    var uid = ref.watch(userProvider).id;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message!.senderId == uid
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.senderId != uid)
                CircleAvatar(
                    backgroundImage: message.senderImage != null
                        ? NetworkImage(message.senderImage!)
                        : null),
              Container(
                  padding: const EdgeInsets.all(10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: message.senderId == uid
                          ? primaryColor.withOpacity(0.1)
                          : secondaryColor.withOpacity(0.1)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      message.type == 'text'
                          ? Text(
                              message.message!,
                              style: normalText(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            )
                          : message.type == 'image'
                              ? InkWell(
                                  onTap: () {
                                    sendToTransparentPage(
                                        context,
                                        Container(
                                          color: Colors.white.withOpacity(.8),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                                message.mediaFile!,
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            }),
                                          ),
                                        ));
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        message.mediaFile!,
                                        height: 250,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        },
                                      ),
                                      Text(
                                        message.message!,
                                        style: normalText(
                                          fontSize: 13,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    //play button when audio is not playing and pause button when audio is playing
                                    InkWell(
                                      onTap: () {
                                        if (ref.watch(audioPlayerProvider)) {
                                          ref
                                              .read(
                                                  audioPlayerProvider.notifier)
                                              .pauseAudio();
                                        } else {
                                          ref
                                              .read(
                                                  audioPlayerProvider.notifier)
                                              .playAudio(
                                                  message.mediaFile!, ref);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: primaryColor, width: 2),
                                        ),
                                        child: Icon(
                                          ref.watch(audioPlayerProvider)
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: primaryColor,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              '${ref.watch(audioPlayerDurationProvider).inMinutes}:${ref.watch(audioPlayerDurationProvider).inSeconds % 60}',
                                              style: normalText(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          LinearPercentIndicator(
                                            lineHeight: 10,
                                            percent: ref.watch(
                                                audioPlayerTimerProvider),
                                            progressColor: Colors.green,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: message.senderId == uid
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            message.createdAt != null
                                ? getNumberOfTime(message.createdAt!)
                                : '',
                            style: normalText(
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (message.senderId == uid)
                            Icon(
                              message.isRead! ? Icons.done_all : Icons.done,
                              size: 15,
                              color:
                                  message.isRead! ? primaryColor : Colors.grey,
                            )
                        ],
                      )
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
