part of 'message_cubit.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageLoading extends MessageState {

}
final class MessageLoaded extends MessageState {
  final List<MessageEntity> messages;
  MessageLoaded(this.messages);

}

final class MessageError extends MessageState {
  final String message;
  MessageError(this.message);
}
