import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shapeshred/core/constants/app_colors.dart';
import 'package:shapeshred/features/coach/domain/entities/task_entity.dart';

class DailyTasksPage extends StatefulWidget {
  const DailyTasksPage({super.key});

  @override
  State<DailyTasksPage> createState() => _DailyTasksPageState();
}

class _DailyTasksPageState extends State<DailyTasksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Center(child: Text('Please login'));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title:
            const Text('Daily Tasks', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tasks')
            .where('assignedBy',
                isEqualTo: 'coach_demo_id') // Replace with actual coach ID
            .where('dueDate',
                isGreaterThanOrEqualTo:
                    DateTime.now().subtract(const Duration(days: 1)))
            .orderBy('dueDate', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.black));
          }

          final tasks = snapshot.data!.docs.map((doc) {
            return Task.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 80.sp, color: AppColors.grey300),
                  SizedBox(height: 16.h),
                  Text(
                    'No tasks for today!',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
        color: task.isCompleted ? AppColors.grey50 : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: task.isCompleted ? AppColors.grey200 : AppColors.black,
            width: 1),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (_) => _toggleTask(task),
            activeColor: AppColors.black,
            checkColor: AppColors.white,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight:
                        task.isCompleted ? FontWeight.w400 : FontWeight.w600,
                    color:
                        task.isCompleted ? AppColors.grey500 : AppColors.black,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.description.isNotEmpty)
                  Text(
                    task.description,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.grey600),
                  ),
                Text(
                  'Due: ${_formatDate(task.dueDate)}',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.grey400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTask(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _firestore
        .collection('tasks')
        .doc(task.id)
        .update({'isCompleted': updatedTask.isCompleted});
    setState(() {});
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
