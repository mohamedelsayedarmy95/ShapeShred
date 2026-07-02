import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/features/ai/presentation/bloc/ai_chat_bloc.dart';
import 'package:shapeshred/features/ai/domain/entities/chat_message.dart';

class CoachChatPage extends StatefulWidget {
  const CoachChatPage({super.key});

  @override
  State<CoachChatPage> createState() => _CoachChatPageState();
}

class _CoachChatPageState extends State<CoachChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSurfaceLevel.background,
      appBar: AppBar(
        title: const Text('AI Coach'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AiChatBloc, AiChatState>(
              builder: (context, state) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(AppSpacing.screenPadding.w),
                  itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.messages.length) {
                      return _buildTypingIndicator();
                    }
                    final message = state.messages[index];
                    return _buildChatBubble(message);
                  },
                );
              },
            ),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isMe = message.role == ChatRole.user;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.75.sw),
        margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
        padding: EdgeInsets.all(AppSpacing.space16.w),
        decoration: BoxDecoration(
          color: isMe ? AppColorPalette.gray800 : AppSurfaceLevel.elevated,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
            bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
          ),
        ),
        child: Text(
          message.content,
          style: AppTypography.textTheme.bodyLarge?.copyWith(
            color: isMe ? AppColorPalette.pureWhite : AppTextColor.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.space16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppSurfaceLevel.elevated,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          '...',
          style: AppTypography.textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.space16.w),
      decoration: const BoxDecoration(
        color: AppSurfaceLevel.background,
        border: Border(top: BorderSide(color: AppColorPalette.gray200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: AppTypography.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Ask your coach...',
                  filled: true,
                  fillColor: AppSurfaceLevel.elevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusPill),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.space12.w),
            CircleAvatar(
              backgroundColor: AppColorPalette.gray900,
              child: IconButton(
                icon: const Icon(Icons.send, color: AppColorPalette.pureWhite),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    context.read<AiChatBloc>().add(MessageSent(text));
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
