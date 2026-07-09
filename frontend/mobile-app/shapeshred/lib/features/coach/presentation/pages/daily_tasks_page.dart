import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/features/coach/domain/entities/task.dart';

class DailyTasksPage extends StatefulWidget {
  const DailyTasksPage({super.key});

  @override
  State<DailyTasksPage> createState() => _DailyTasksPageState();
}

class _DailyTasksPageState extends State<DailyTasksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _coachId = 'coach_demo_id';

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: AppColorPalette.pureWhite,
        body: Center(
          child: Text(
            'Please login first',
            style: AppTypography.bodyLarge,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColorPalette.pureWhite,
      appBar: AppBar(
        title: Text(
          'Daily Tasks',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColorPalette.gray900,
          ),
        ),
        backgroundColor: AppColorPalette.pureWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColorPalette.gray900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tasks')
            .where('assignedBy', isEqualTo: _coachId)
            .orderBy('dueDate', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading tasks',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppTextColor.secondary,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColorPalette.gray900,
              ),
            );
          }

          final tasks = snapshot.data!.docs.map((doc) {
            return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          if (tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: AppColorPalette.gray300,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No tasks for today!',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColorPalette.gray500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your coach will assign tasks to help you stay on track.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppTextColor.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskItem(task);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: task.isCompleted ? AppColorPalette.gray50 : AppColorPalette.pureWhite,
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(
          color: task.isCompleted ? AppColorPalette.gray200 : AppColorPalette.gray900,
          width: task.isCompleted ? 1 : 2,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleTask(task),
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted
                    ? AppColorPalette.gray900
                    : AppColorPalette.pureWhite,
                border: Border.all(
                  color: task.isCompleted
                      ? AppColorPalette.gray900
                      : AppColorPalette.gray400,
                  width: 2,
                ),
              ),
              child: task.isCompleted
                  ? Icon(
                      Icons.check,
                      color: AppColorPalette.pureWhite,
                      size: 16.sp,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: task.isCompleted ? FontWeight.w400 : FontWeight.w600,
                    color: task.isCompleted ? AppColorPalette.gray500 : AppColorPalette.gray900,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.description.isNotEmpty)
                  Text(
                    task.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppTextColor.secondary,
                    ),
                  ),
                Text(
                  'Due: ${_formatDate(task.dueDate)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColorPalette.gray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update({
      'isCompleted': !task.isCompleted,
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
