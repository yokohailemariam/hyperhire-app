import 'package:flutter/material.dart';
import 'package:hyperhire_app/Widgets/chat_list_view.dart';
import 'package:hyperhire_app/Widgets/message_card.dart';
import 'package:hyperhire_app/Widgets/messages_text_input.dart';
import 'package:hyperhire_app/utils/constants.dart';
import 'package:hyperhire_app/utils/helper.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  late ScrollController scrollController;
  bool focus = false;
  bool isLoading = false;
  bool isSending = false;
  late FocusNode focusNode;
  List<MessageCard> messages = [];

  focusUpdate() => setState(() => focus = focusNode.hasFocus);

  @override
  void initState() {
    focusNode = FocusNode();
    scrollController = ScrollController();
    focusNode.addListener(focusUpdate);

    getChannel();
    super.initState();
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      ),
    );
  }

  void getChannel() async {
    try {
      setState(() => isLoading = true);

      await SendbirdChat.connect(
          'sendbird_desk_agent_id_5b6eaeb2-dba0-49da-8f4e-60d35a424dc7');

      final channel = await OpenChannel.getChannel(
          'sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211');
      await channel.enter();

      final query = PreviousMessageListQuery(
        channelType: channel.channelType,
        channelUrl: channel.channelUrl,
      );

      final msg = await query.next();

      for (var element in msg) {
        messages.add(
          MessageCard(
            name: element.sender?.nickname ?? "User",
            message: element.message,
            isMine: element.sender?.isCurrentUser == null ||
                    element.sender?.isCurrentUser == true
                ? true
                : false,
            day: toRelativeTime(element.createdAt),
            online: 1,
            isPhoto: element.sender?.isCurrentUser == null ||
                    element.sender?.isCurrentUser == true
                ? true
                : false,
            photoUrl: element.sender?.profileUrl ?? "",
            isActive: element.sender?.isActive ?? false,
          ),
        );
      }

      setState(() => isLoading = false);

      _scrollToBottom();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void sendMessage() async {
    try {
      setState(() {
        isSending = true;
      });
      final channel = await OpenChannel.getChannel(
          "sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211");
      await channel.enter();
      channel
          .sendUserMessage(UserMessageCreateParams(message: controller.text));

      setState(() {
        messages.add(
          MessageCard(
            name: '',
            message: controller.text,
            isMine: true,
            day: "1",
            online: 2,
            isPhoto: false,
            photoUrl: "",
            isActive: false,
          ),
        );
        isSending = false;
        controller.text = '';
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: AppColors.whiteIconColor,
            ),
          ),
          centerTitle: true,
          title: const Text(
            "강남스팟",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.whiteTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.pink,
                  strokeWidth: 1,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: ChatListView(
                    messages: messages,
                    scrollController: scrollController,
                  )),
                  if (isSending)
                    const LinearProgressIndicator(
                      color: AppColors.pink,
                    ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.whiteIconColor,
                        ),
                      ),
                      Expanded(
                          child: MessageTextInput(
                        focusNode: focusNode,
                        controller: controller,
                        sendMessage: sendMessage,
                      )),
                    ],
                  ),
                  const SizedBox(height: 16)
                ],
              ),
      ),
    );
  }
}
