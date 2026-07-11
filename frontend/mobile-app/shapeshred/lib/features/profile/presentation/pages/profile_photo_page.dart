import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/atoms/premium_button.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePhotoPage extends StatefulWidget {
  const ProfilePhotoPage({super.key});

  @override
  State<ProfilePhotoPage> createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _currentPhotoUrl;
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentPhoto();
  }

  Future<void> _loadCurrentPhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && mounted) {
      setState(() {
        _currentPhotoUrl = doc.data()?['photoUrl'] as String?;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    HapticHelper.light();

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
        HapticHelper.light();
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to pick image: ${e.toString()}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onError,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Upload to Firebase Storage
      final fileName =
          'profile_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child(user.uid)
          .child(fileName);

      await ref.putFile(_selectedImage!);
      final downloadUrl = await ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'photoUrl': downloadUrl,
        'photoUpdatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        HapticHelper.successImpact();
        setState(() {
          _currentPhotoUrl = downloadUrl;
          _selectedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile photo updated successfully!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onTertiary,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to upload photo: ${e.toString()}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onError,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _removePhoto() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Remove from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'photoUrl': null,
        'photoUpdatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        HapticHelper.successImpact();
        setState(() {
          _currentPhotoUrl = null;
          _selectedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile photo removed',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onTertiary,
              ),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      HapticHelper.error();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to remove photo: ${e.toString()}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onError,
              ),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTextColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Photo',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppSpacing.space32.h),

              // Photo Preview
              Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.radiusCircle),
                  border: Border.all(
                    color: AppColors.outline,
                    width: 2,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusCircle),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _currentPhotoUrl != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppRadius.radiusCircle),
                            child: CachedNetworkImage(
                              imageUrl: _currentPhotoUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _buildPlaceholder(),
                            ),
                          )
                        : _buildPlaceholder(),
              ),
              SizedBox(height: AppSpacing.space24.h),

              // Photo Options
              if (_selectedImage == null) ...[
                Text(
                  'Choose a photo',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.space16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPhotoOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    SizedBox(width: AppSpacing.space16.w),
                    _buildPhotoOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ] else ...[
                // Selected Image Actions
                Text(
                  'Review your photo',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.space16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionOption(
                      icon: Icons.close,
                      label: 'Cancel',
                      color: AppColors.error,
                      onColor: AppColors.onError,
                      onTap: () {
                        setState(() => _selectedImage = null);
                        HapticHelper.light();
                      },
                    ),
                    SizedBox(width: AppSpacing.space16.w),
                    _buildActionOption(
                      icon: Icons.check,
                      label: 'Upload',
                      color: AppColors.success,
                      onColor: AppColors.onTertiary,
                      onTap: _uploadPhoto,
                      isLoading: _isUploading,
                    ),
                  ],
                ),
              ],
              SizedBox(height: AppSpacing.space32.h),

              // Remove Current Photo
              if (_currentPhotoUrl != null && _selectedImage == null)
                PremiumButton(
                  label: 'Remove Current Photo',
                  onPressed: _removePhoto,
                  isLoading: _isLoading,
                  fullWidth: true,
                  isDestructive: true,
                ),

              SizedBox(height: AppSpacing.space16.h),

              // Tips
              Container(
                padding: EdgeInsets.all(AppSpacing.space16.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppTextColors.secondary,
                          size: 20.sp,
                        ),
                        SizedBox(width: AppSpacing.space8.w),
                        Text(
                          'Tips for a great profile photo',
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space12.h),
                    _buildTip('Use good lighting'),
                    _buildTip('Show your face clearly'),
                    _buildTip('Keep it professional'),
                    _buildTip('Use a simple background'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 80.sp,
            color: AppTextColors.tertiary,
          ),
          SizedBox(height: AppSpacing.space8.h),
          Text(
            'No photo',
            style: AppTypography.bodyMedium.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space24.w,
          vertical: AppSpacing.space16.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: AppTextColors.primary,
            ),
            SizedBox(height: AppSpacing.space8.h),
            Text(
              label,
              style: AppTypography.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    Color? onColor,
    bool isLoading = false,
  }) {
    final foreground = onColor ?? AppColors.onPrimary;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space24.w,
          vertical: AppSpacing.space16.h,
        ),
        decoration: BoxDecoration(
          color: isLoading ? AppColors.surfaceVariant : color,
          borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Column(
                children: [
                  Icon(
                    icon,
                    size: 32.sp,
                    color: foreground,
                  ),
                  SizedBox(height: AppSpacing.space8.h),
                  Text(
                    label,
                    style: AppTypography.labelMedium.copyWith(
                      color: foreground,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space4.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16.sp,
            color: AppTextColors.secondary,
          ),
          SizedBox(width: AppSpacing.space8.w),
          Text(
            tip,
            style: AppTypography.bodySmall.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
