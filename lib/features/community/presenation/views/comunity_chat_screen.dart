import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/features/community/presenation/logic/message_cubit.dart';
import '../widgets/custom_text_field.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Community.communityChat.tr()), centerTitle: true),
      body: ChatScreenBody(controller: _controller),
    );
  }
}

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({super.key, required TextEditingController controller})
    : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            /// Messages
            Expanded(
              child: BlocBuilder<MessageCubit, MessageState>(
                buildWhen: (previous, current) {
                  return previous != current;
                },
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessageError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is MessageLoaded) {
                    final messages = state.messages;
                    if (messages.isEmpty) {
                      return const Center(child: Text("No messages yet"));
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe =
                            msg.id == FirebaseAuth.instance.currentUser?.email;
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.75,
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? (isDark ? Colors.deepPurpleAccent : Colors.blue)
                                  : (isDark
                                      ? Colors.grey[850]
                                      : Colors.grey[200]),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isMe ? 16 : 0),
                                bottomRight: Radius.circular(isMe ? 0 : 16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isMe || isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: isMe || isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: constraints.maxWidth < 600
                                        ? 14
                                        : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Start chatting..."));
                },
              ),
            ),

            /// Input
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.02,
                ),
                child: CustomTextField(
                  controller: _controller,
                  onSend: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<MessageCubit>().sendMessage(
                        _controller.text,
                      );
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
