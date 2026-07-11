import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shapeshred/core/design_system/tokens/colors.dart';
import 'package:shapeshred/core/design_system/tokens/spacing.dart';
import 'package:shapeshred/core/design_system/tokens/typography.dart';
import 'package:shapeshred/core/design_system/tokens/radius.dart';
import 'package:shapeshred/core/design_system/tokens/motion.dart';
import 'package:shapeshred/core/design_system/atoms/premium_card.dart';
import 'package:shapeshred/core/services/advanced_analytics_service.dart';
import 'package:shapeshred/core/services/preferences_service.dart';
import 'package:shapeshred/features/training/data/workout_history_repository.dart';
import 'dart:math' as math;

class SuperUltraPremiumAnalyticsDetailPage extends StatefulWidget {
  const SuperUltraPremiumAnalyticsDetailPage({super.key});

  @override
  State<SuperUltraPremiumAnalyticsDetailPage> createState() =>
      _SuperUltraPremiumAnalyticsDetailPageState();
}

class _SuperUltraPremiumAnalyticsDetailPageState
    extends State<SuperUltraPremiumAnalyticsDetailPage>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  Map<String, dynamic>? _trendAnalysis;
  Map<String, dynamic>? _prediction;
  List<Map<String, dynamic>> _recommendations = [];
  Map<String, dynamic>? _recoveryStatus;
  List<Map<String, dynamic>> _workoutHistory = [];
  late final WorkoutHistoryRepository _workoutRepository;

  // Animation controllers for premium effects
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeServices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    _workoutRepository = FirebaseWorkoutHistoryRepository(
      firestore: FirebaseFirestore.instance,
      userId: user.uid,
    );

    await _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Get real workout data from repository
      final workoutSnapshot =
          await _workoutRepository.getWorkoutHistory().first;
      _workoutHistory = workoutSnapshot;

      // Analyze performance trends
      _trendAnalysis = await AdvancedAnalyticsService.analyzePerformanceTrends(
          _workoutHistory);

      // Predict next workout
      _prediction =
          await AdvancedAnalyticsService.predictNextWorkout(_workoutHistory);

      // Get user preferences for recommendations
      final String primaryGoal =
          await PreferencesService.getUserGoal() ?? 'build_muscle';
      final String fitnessLevel =
          await PreferencesService.getFitnessLevel() ?? 'intermediate';

      // Generate recommendations
      _recommendations = await AdvancedAnalyticsService.generateRecommendations(
        _workoutHistory,
        primaryGoal,
        fitnessLevel,
      );

      // Assess recovery status (using last 3 workouts)
      final List<Map<String, dynamic>> recentWorkouts =
          _workoutHistory.take(3).toList();
      _recoveryStatus =
          await AdvancedAnalyticsService.assessRecoveryStatus(recentWorkouts);
    } catch (e) {
      // In a real app, show error message
      debugPrint('Error loading analytics: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
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
          'Analytics Dashboard',
          style: AppTypography.headlineSmall.copyWith(
            color: AppTextColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadAnalyticsData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.screenPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWellnessScoreCard(),
                    SizedBox(height: AppSpacing.space24.h),
                    _buildTrendCard(),
                    SizedBox(height: AppSpacing.space24.h),
                    _buildPredictionCard(),
                    SizedBox(height: AppSpacing.space24.h),
                    _buildRecommendationsCard(),
                    SizedBox(height: AppSpacing.space24.h),
                    _buildRecoveryCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWellnessScoreCard() {
    // Calculate a holistic wellness score based on available data
    final double wellnessScore = _calculateWellnessScore();

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnimation.value,
        child: PremiumCard(
          padding: EdgeInsets.all(AppSpacing.cardPadding.w),
          hasBorder: true,
          child: Column(
            children: [
              Text(
                'Your Wellness Score',
                style: AppTypography.titleMedium.copyWith(
                  color: AppTextColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.space8.h),
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    startAngle: 0,
                    endAngle: 2 * math.pi,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.tertiary,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    wellnessScore.toStringAsFixed(0),
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space12.h),
              Text(
                _getWellnessLabel(wellnessScore),
                style: AppTypography.bodyLarge.copyWith(
                  color: _getWellnessColor(wellnessScore),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateWellnessScore() {
    // Simple algorithm for demonstration - in reality this would be more complex
    double score = 50.0; // Base score

    if (_trendAnalysis != null) {
      final String trend = _trendAnalysis!['trend'] as String? ?? 'unknown';
      switch (trend) {
        case 'strong_improvement':
          score += 20;
          break;
        case 'moderate_improvement':
          score += 15;
          break;
        case 'maintenance':
          score += 10;
          break;
        case 'potential_overtraining':
          score -= 10;
          break;
        case 'plateau_detected':
          score += 5;
          break;
        case 'needs_attention':
          score += 0;
          break;
        default:
          score += 0;
      }
    }

    if (_recoveryStatus != null) {
      final String riskLevel = _recoveryStatus!['riskLevel'] as String? ?? 'moderate';
      switch (riskLevel) {
        case 'low':
          score += 15;
          break;
        case 'moderate':
          score += 10;
          break;
        case 'high':
          score -= 10;
          break;
        default:
          score += 0;
      }
    }

    // Ensure score stays within 0-100
    return score.clamp(0.0, 100.0);
  }

  String _getWellnessLabel(double score) {
    if (score >= 90) return 'Peak Performance';
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Fair';
    return 'Needs Attention';
  }

  Color _getWellnessColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildTrendCard() {
    return AnimatedContainer(
      duration: AppDurations.substantial,
      curve: AppCurves.premiumFluid,
      child: PremiumCard(
        padding: EdgeInsets.all(AppSpacing.cardPadding.w),
        hasBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Trend',
              style: AppTypography.titleMedium.copyWith(
                color: AppTextColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.space16.h),
            _buildTrendContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendContent() {
    if (_trendAnalysis == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final String trend = _trendAnalysis!['trend'] as String? ?? 'unknown';
    final double volumeChange =
        (_trendAnalysis!['volumeChange'] as num?)?.toDouble() ?? 0.0;
    final double intensityChange =
        (_trendAnalysis!['intensityChange'] as num?)?.toDouble() ?? 0.0;
    final bool isPlateau = _trendAnalysis!['isPlateau'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trend description with animated icon
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _floatAnimation.value * 20),
            child: Row(
              children: [
                Icon(
                  _getTrendIcon(trend),
                  color: _getTrendColor(trend),
                  size: 24.sp,
                ),
                SizedBox(width: AppSpacing.space8.w),
                Expanded(
                  child: Text(
                    _getTrendDescription(trend),
                    style: AppTypography.bodyLarge.copyWith(
                      color: _getTrendColor(trend),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.space12.h),
        // Enhanced line chart with glow effect
        SizedBox(
          height: 140.h,
          child: GlowingLineChart(
            workoutHistory: _workoutHistory,
            glowColor: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        SizedBox(height: AppSpacing.space12.h),
        // Metrics with pulsating effect
        Wrap(
          spacing: AppSpacing.space16.w,
          runSpacing: AppSpacing.space8.h,
          children: [
            _buildPulsingMetricCard(
                'Volume Change', volumeChange.toStringAsFixed(2), _pulseAnimation),
            _buildPulsingMetricCard(
                'Intensity Change',
                '${(intensityChange * 100).toStringAsFixed(1)}%',
                _pulseAnimation),
            _buildPulsingMetricCard(
                'Plateau Detected', isPlateau ? 'Yes' : 'No', _pulseAnimation),
          ],
        ),
      ],
    );
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'strong_improvement':
        return Icons.trending_up;
      case 'moderate_improvement':
        return Icons.trending_up;
      case 'maintenance':
        return Icons.dashboard;
      case 'potential_overtraining':
        return Icons.warning;
      case 'plateau_detected':
        return Icons.horizontal_rule;
      case 'needs_attention':
        return Icons.info;
      default:
        return Icons.analytics;
    }
  }

  String _getTrendDescription(String trend) {
    switch (trend) {
      case 'strong_improvement':
        return 'Strong improvement in both volume and intensity!';
      case 'moderate_improvement':
        return 'Good progress! Consider increasing intensity for continued gains.';
      case 'maintenance':
        return 'Maintaining fitness level. Try varying your routine for growth.';
      case 'potential_overtraining':
        return 'Volume decreasing significantly. Consider rest or reduced intensity.';
      case 'plateau_detected':
        return 'You\'ve hit a plateau! Try varying volume and intensity.';
      case 'needs_attention':
        return 'Performance may be plateauing. Try changing your routine.';
      default:
        return 'Insufficient data to determine trend.';
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'strong_improvement':
      case 'moderate_improvement':
        return AppColors.success;
      case 'plateau_detected':
      case 'needs_attention':
        return AppColors.warning;
      case 'potential_overtraining':
        return AppColors.error;
      default:
        return AppTextColors.secondary;
    }
  }

  Widget _buildPulsingMetricCard(
      String label, String value, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.scale(
        scale: animation.value,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.space12.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
            border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTextColors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.space4.h),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppTextColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    return AnimatedContainer(
      duration: AppDurations.substantial,
      curve: AppCurves.premiumFluid,
      child: PremiumCard(
        padding: EdgeInsets.all(AppSpacing.cardPadding.w),
        hasBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Next Workout Prediction',
              style: AppTypography.titleMedium.copyWith(
                color: AppTextColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.space16.h),
            _prediction == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPredictionItem(
                          'Suggested Volume', _prediction!['suggestedVolume']?.toString() ?? 'N/A'),
                      SizedBox(height: AppSpacing.space8.h),
                      _buildPredictionItem(
                          'Suggested Intensity (RPE)',
                          (_prediction!['suggestedIntensity'] as num?)?.toStringAsFixed(1) ?? 'N/A'),
                      SizedBox(height: AppSpacing.space8.h),
                      _buildPredictionItem(
                          'Confidence',
                          (_prediction!['confidence'] as num?)?.toStringAsFixed(2) ?? '0.00'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionItem(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppTextColors.secondary,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppTextColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsCard() {
    return AnimatedContainer(
      duration: AppDurations.substantial,
      curve: AppCurves.premiumFluid,
      child: PremiumCard(
        padding: EdgeInsets.all(AppSpacing.cardPadding.w),
        hasBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: AppTypography.titleMedium.copyWith(
                color: AppTextColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.space16.h),
            _recommendations.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recommendations.length,
                    itemBuilder: (context, index) {
                      final rec = _recommendations[index];
                      return _RecommendationItemWithAnimation(
                        index: index,
                        icon: (rec['icon'] as IconData?) ?? Icons.tips_and_updates,
                        title: (rec['title'] as String?) ?? 'Recommendation',
                        description: (rec['description'] as String?) ?? '',
                        priority: (rec['priority'] as String?) ?? 'medium',
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryCard() {
    return AnimatedContainer(
      duration: AppDurations.substantial,
      curve: AppCurves.premiumFluid,
      child: PremiumCard(
        padding: EdgeInsets.all(AppSpacing.cardPadding.w),
        hasBorder: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recovery Status',
              style: AppTypography.titleMedium.copyWith(
                color: AppTextColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.space16.h),
            _recoveryStatus == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRiskLevelIndicator(),
                      SizedBox(height: AppSpacing.space12.h),
                      Text(
                        'Recommendations:',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTextColors.primary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.space8.h),
                      if (_recoveryStatus != null && _recoveryStatus!['recommendations'] != null) ...[
                        for (var rec in _recoveryStatus!['recommendations'] as List<dynamic>)
                          Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.space4.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: _getRiskColor(_recoveryStatus!['riskLevel']),
                                ),
                                SizedBox(width: AppSpacing.space8.w),
                                Expanded(
                                  child: Text(
                                    rec.toString(),
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppTextColors.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskLevelIndicator() {
    final String riskLevel = _recoveryStatus!['riskLevel'] as String? ?? 'unknown';
    final Color riskColor = _getRiskColor(riskLevel);

    return Container(
      padding: EdgeInsets.all(AppSpacing.space12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            riskColor.withValues(alpha: 0.1),
            riskColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusMedium),
        border: Border.all(color: riskColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield,
            color: riskColor,
            size: 20.sp,
          ),
          SizedBox(width: AppSpacing.space8.w),
          Expanded(
            child: Text(
              'Risk Level: $riskLevel',
              style: AppTypography.bodyLarge.copyWith(
                color: riskColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(dynamic riskLevel) {
    switch (riskLevel) {
      case 'high':
        return AppColors.error;
      case 'moderate':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppTextColors.secondary;
    }
  }
}

// Custom widget for animated recommendation item
class _RecommendationItemWithAnimation extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String description;
  final String priority;

  const _RecommendationItemWithAnimation({
    required this.index,
    required this.icon,
    required this.title,
    required this.description,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 50)),
      curve: Curves.easeInOut,
      builder: (context, double opacity, child) => Opacity(
        opacity: opacity,
        child: child,
      ),
      child: _RecommendationItem(
        icon: icon,
        title: title,
        description: description,
        priority: priority,
      ),
    );
  }
}

// Enhanced recommendation item with priority coloring
class _RecommendationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String priority;

  const _RecommendationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final Color priorityColor = {
          'high': AppColors.error,
          'medium': AppColors.warning,
          'low': AppColors.info,
        }[priority] ??
        AppTextColors.secondary;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: priorityColor),
          SizedBox(width: AppSpacing.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTextColors.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.space4.h),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppTextColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced line chart with glow effect
class GlowingLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> workoutHistory;
  final Color glowColor;

  const GlowingLineChart({
    super.key,
    required this.workoutHistory,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    if (workoutHistory.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Calculate volume for each workout
    final List<double> volumes = workoutHistory.map((workout) {
      double volume = 0.0;
      for (final exercise in (workout['exercises'] as List? ?? const [])) {
        final double weight =
            (exercise['weight'] as num?)?.toDouble() ?? 0.0;
        final double reps =
            (exercise['reps'] as num?)?.toDouble() ?? 0.0;
        final double sets =
            (exercise['set'] as num?)?.toDouble() ?? 0.0;
        volume += weight * reps * sets;
      }
      return volume;
    }).toList();

    return CustomPaint(
      size: Size.fromHeight(120.h),
      painter: _GlowingLineChartPainter(volumes, glowColor),
    );
  }
}

class _GlowingLineChartPainter extends CustomPainter {
  final List<double> values;
  final Paint _linePaint;
  final Paint _pointPaint;
  final Paint _glowPaint;
  final Paint _gridPaint;

  _GlowingLineChartPainter(this.values, Color glowColor)
      : _linePaint = Paint()
          ..color = AppColors.primary
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        _pointPaint = Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill,
        _glowPaint = Paint()
          ..color = glowColor
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        _gridPaint = Paint()
          ..color = AppColors.outline.withValues(alpha: 0.2)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final double width = size.width;
    final double height = size.height;
    const double padding = 20.0; // Space for labels
    final double chartWidth = width - 2 * padding;
    final double chartHeight = height - 2 * padding;

    // Find min and max values for scaling
    double minVal = values.reduce(math.min);
    double maxVal = values.reduce(math.max);
    if (maxVal == minVal) {
      maxVal = minVal + 1; // Avoid division by zero
    }

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final double y = padding + (chartHeight * (1 - i / 4));
      canvas.drawLine(
        Offset(padding, y),
        Offset(width - padding, y),
        _gridPaint,
      );
    }

    // Draw vertical grid lines (for each point)
    for (int i = 0; i < values.length; i++) {
      final double x = padding + (chartWidth * i / (values.length - 1));
      canvas.drawLine(
        Offset(x, padding),
        Offset(x, height - padding),
        _gridPaint,
      );
    }

    // Draw glow effect first (behind the line)
    final List<Offset> glowPoints = [];
    for (int i = 0; i < values.length; i++) {
      final double x = padding + (chartWidth * i / (values.length - 1));
      final double normalized = (values[i] - minVal) / (maxVal - minVal);
      final double y = padding + (chartHeight * (1 - normalized));
      glowPoints.add(Offset(x, y));
    }

    // Draw glow path
    if (glowPoints.length >= 2) {
      final Path glowPath = Path()..moveTo(glowPoints[0].dx, glowPoints[0].dy);
      for (int i = 1; i < glowPoints.length; i++) {
        glowPath.lineTo(glowPoints[i].dx, glowPoints[i].dy);
      }
      canvas.drawPath(glowPath, _glowPaint);
    }

    // Draw the line chart
    final List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final double x = padding + (chartWidth * i / (values.length - 1));
      final double normalized = (values[i] - minVal) / (maxVal - minVal);
      final double y = padding + (chartHeight * (1 - normalized));
      points.add(Offset(x, y));
    }

    // Draw lines between points
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], _linePaint);
    }

    // Draw points with glow
    for (final Offset point in points) {
      // Draw outer glow
      canvas.drawCircle(point, 5.0, _glowPaint);
      // Draw inner point
      canvas.drawCircle(point, 3.0, _pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}