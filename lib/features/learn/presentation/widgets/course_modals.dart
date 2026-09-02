import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../curriculum/presentation/widgets/course_progress_item.dart';

enum CourseOverviewAction { changeCourse, openCourse }

Future<CourseOverviewAction?> showCourseOverviewSheet(
  BuildContext context, {
  required String courseTitle,
}) {
  return showModalBottomSheet<CourseOverviewAction>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.textPrimary.withValues(alpha: 0.12),
    constraints: const BoxConstraints(maxWidth: 430),
    builder: (context) => SizedBox(
      height: 859,
      child: _CourseOverviewSheet(courseTitle: courseTitle),
    ),
  );
}

Future<String?> showChangeCourseSheet(
  BuildContext context, {
  required String selectedCourse,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.textPrimary.withValues(alpha: 0.12),
    constraints: const BoxConstraints(maxWidth: 430),
    builder: (context) => SizedBox(
      height: 859,
      child: _ChangeCourseSheet(selectedCourse: selectedCourse),
    ),
  );
}

Future<bool> showCourseOpenDialog(
  BuildContext context, {
  required String courseTitle,
}) async {
  return await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Kurs oynasini yopish',
        barrierColor: AppColors.textPrimary.withValues(alpha: 0.12),
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: CourseOpenCard(courseTitle: courseTitle),
            ),
          ),
        ),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.14),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ) ??
      false;
}

class _CourseOverviewSheet extends StatelessWidget {
  const _CourseOverviewSheet({required this.courseTitle});

  final String courseTitle;

  static const _modules = [
    CourseModuleData(isCurrent: true),
    CourseModuleData(),
    CourseModuleData(),
    CourseModuleData(),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.modalSheetTop,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 138,
            child: Stack(
              children: [
                Positioned(
                  left: 12,
                  top: 11,
                  child: IconButton(
                    key: const ValueKey('course-overview-close'),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 25,
                    color: AppColors.textSecondary,
                    tooltip: 'Yopish',
                  ),
                ),
                Positioned(
                  left: AppSpacing.screenHorizontal,
                  top: 64,
                  child: Text(
                    'Kurs',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.screenHorizontal,
                  top: 91,
                  child: Text(
                    courseTitle,
                    style: AppTypography.title.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: AppSpacing.screenHorizontal,
                  top: 66,
                  child: _RedoButton(
                    onTap: () =>
                        Navigator.of(context)
                            .pop(CourseOverviewAction.changeCourse),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              key: const ValueKey('course-overview-list'),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              physics: const BouncingScrollPhysics(),
              itemCount: _modules.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.controlGap),
              itemBuilder: (context, index) => CourseProgressItem(
                key: ValueKey('course-progress-item-$index'),
                module: _modules[index],
                showConnector: index < _modules.length - 1,
                onTap: () =>
                    Navigator.of(context).pop(CourseOverviewAction.openCourse),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RedoButton extends StatelessWidget {
  const _RedoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Kursni almashtirish',
      child: Material(
        color: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.input,
          side: BorderSide(color: AppColors.outline),
        ),
        child: InkWell(
          key: const ValueKey('course-overview-redo'),
          onTap: onTap,
          borderRadius: AppRadius.input,
          child: const SizedBox.square(
            dimension: 44,
            child: Icon(
              Icons.sync_rounded,
              size: 24,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangeCourseSheet extends StatefulWidget {
  const _ChangeCourseSheet({required this.selectedCourse});

  final String selectedCourse;

  @override
  State<_ChangeCourseSheet> createState() => _ChangeCourseSheetState();
}

class _ChangeCourseSheetState extends State<_ChangeCourseSheet> {
  static const _courses = [
    'Python Developer',
    'Prompt Engineering',
    'Prompt Engineering',
    'Prompt Engineering',
    'Prompt Engineering',
  ];

  late String _selectedCourse = widget.selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.modalSheetTop,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 69,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  top: 68,
                  child: ColoredBox(color: AppColors.subtleOutline),
                ),
                Positioned(
                  left: 12,
                  top: 8,
                  child: IconButton(
                    key: const ValueKey('change-course-close'),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 25,
                    color: AppColors.textSecondary,
                    tooltip: 'Yopish',
                  ),
                ),
                Text(
                  'Kursni tanlang',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              key: const ValueKey('change-course-list'),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              physics: const BouncingScrollPhysics(),
              itemCount: _courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final course = _courses[index];
                return _CourseSelectionCard(
                  key: ValueKey('course-selection-$index'),
                  title: course,
                  isSelected:
                      course == _selectedCourse &&
                      (course != 'Prompt Engineering' || index == 1),
                  onTap: () {
                    setState(() => _selectedCourse = course);
                    Navigator.of(context).pop(course);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseSelectionCard extends StatelessWidget {
  const _CourseSelectionCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(AppSpacing.card),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.outline,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.sectionTitle.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Bo’limlar',
                    style: AppTypography.label.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Text('0/20', style: AppTypography.label),
                ],
              ),
              const SizedBox(height: 8),
              const AppLinearProgressBar(
                value: 0,
                height: 12,
                fillColor: AppColors.primary,
                trackColor: AppColors.mutedSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The centered confirmation card shown when a course step is opened.
class CourseOpenCard extends StatelessWidget {
  const CourseOpenCard({required this.courseTitle, super.key});

  final String courseTitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.card,
      child: Container(
        height: 183,
        padding: const EdgeInsets.all(AppSpacing.card),
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseTitle,
              style: AppTypography.sectionTitle.copyWith(
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Bo’limlar',
                  style: AppTypography.label.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Text('0/20', style: AppTypography.label),
              ],
            ),
            const SizedBox(height: 8),
            const AppLinearProgressBar(
              value: 0,
              height: 12,
              fillColor: AppColors.primary,
              trackColor: AppColors.mutedSurface,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Davom ettirish',
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );
  }
}
