import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/constants/app_colors.dart';

class MealLoggerPage extends StatefulWidget {
  const MealLoggerPage({super.key});

  @override
  State<MealLoggerPage> createState() => _MealLoggerPageState();
}

class _MealLoggerPageState extends State<MealLoggerPage> {
  final _formKey = GlobalKey<FormState>();
  String _mealType = 'Breakfast';
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();

  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Log Meal', style: TextStyle(color: AppColors.black)),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.go('/nutrition'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              Text(
                'Add Meal',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black),
              ),
              SizedBox(height: 8.h),
              Text(
                'Log your meal details below.',
                style: TextStyle(fontSize: 14.sp, color: AppColors.grey500),
              ),
              SizedBox(height: 32.h),
              DropdownButtonFormField<String>(
                initialValue: _mealType,
                decoration: InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.black, width: 2),
                  ),
                ),
                items: _mealTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _mealType = value!),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.black, width: 2),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Enter food name' : null,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Calories (kcal)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.black, width: 2),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Enter calories' : null,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Meal logged successfully!')),
                      );
                      context.go('/nutrition');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                  ),
                  child: Text('Save Meal',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
