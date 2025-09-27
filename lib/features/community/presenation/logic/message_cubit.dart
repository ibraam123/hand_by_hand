import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/features/community/data/repos/messages_repo.dart';

import '../../domain/entities/message_entitiy.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final CommunityChatRepository repository;


  MessageCubit(this.repository) : super(MessageInitial());

  void loadMessages() {
    emit(MessageLoading());
    repository.getMessages().listen((messages) {
      emit(MessageLoaded(messages));
    }, onError: (e) {
      emit(MessageError(e.toString()));
    });
  }

  Future<void> sendMessage(String text) async {
    await repository.sendMessage(text);
  }
}
