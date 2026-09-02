import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../shared/widgets/lesson_project_preview_card.dart';
import '../../lesson/presentation/single_choice_lesson_screen.dart';
import 'widgets/course_modals.dart';
import 'widgets/learning_path_node.dart';
import 'widgets/learning_path_trail.dart';
import 'widgets/lesson_section_header_card.dart';
import 'widgets/pixel_scene_backdrop.dart';

/// Coordinates for the first visible section of the Figma learning path.
const _pathSteps = [
  LearningPathStep(state: LearningPathNodeState.completed, left: 155, top: 33),
  LearningPathStep(state: LearningPathNodeState.completed, left: 20, top: 164),
  LearningPathStep(state: LearningPathNodeState.completed, left: 155, top: 273),
  LearningPathStep(state: LearningPathNodeState.completed, left: 290, top: 382),
  LearningPathStep(state: LearningPathNodeState.current, left: 155, top: 489),
  LearningPathStep(state: LearningPathNodeState.locked, left: 20, top: 605),
  LearningPathStep(state: LearningPathNodeState.locked, left: 155, top: 714),
  LearningPathStep(state: LearningPathNodeState.locked, left: 290, top: 823),
  LearningPathStep(state: LearningPathNodeState.locked, left: 155, top: 932),
];

const _secondSectionSteps = [
  LearningPathStep(state: LearningPathNodeState.locked, left: 155, top: 0),
  LearningPathStep(state: LearningPathNodeState.locked, left: 20, top: 131),
  LearningPathStep(state: LearningPathNodeState.locked, left: 155, top: 240),
  LearningPathStep(state: LearningPathNodeState.locked, left: 290, top: 349),
];

/// The Figma Learn home: a path scene under fixed stats, a sticky section
/// card, and floating bottom navigation.
class LearnScreen extends StatefulWidget {
  const LearnScreen({this.onContinueCourse, super.key});

  /// Optional navigation override used by hosts and widget tests after the
  /// learner confirms "Davom ettirish".
  final VoidCallback? onContinueCourse;

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  static const _sectionHeaderTop = 148.0;
  static const _sectionHeaderHeight = 115.0;
  static const _firstSectionPathTop = 243.0;
  static const _secondSectionHeaderTop = _firstSectionPathTop + 1190;
  static const _secondSectionStickyOffset =
      _secondSectionHeaderTop - _sectionHeaderTop;

  int _tabIndex = 0;
  int _stickySectionIndex = 0;
  String _selectedCourse = 'Python Developer';
  late final ScrollController _learnScrollController;

  static const _tabs = [
    AppBottomNavItem(icon: Icons.school_rounded, semanticLabel: 'O’qish'),
    AppBottomNavItem(
      icon: Icons.workspace_premium_outlined,
      semanticLabel: 'Yutuqlar',
    ),
    AppBottomNavItem(
      icon: Icons.person_outline_rounded,
      semanticLabel: 'Profil',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _learnScrollController = ScrollController()
      ..addListener(_updateStickySection);
  }

  @override
  void dispose() {
    _learnScrollController
      ..removeListener(_updateStickySection)
      ..dispose();
    super.dispose();
  }

  void _updateStickySection() {
    final sectionIndex =
        _learnScrollController.offset >= _secondSectionStickyOffset ? 1 : 0;
    if (sectionIndex != _stickySectionIndex) {
      setState(() => _stickySectionIndex = sectionIndex);
    }
  }

  Future<void> _openCourseOverview() async {
    final action = await showCourseOverviewSheet(
      context,
      courseTitle: _selectedCourse,
    );
    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case CourseOverviewAction.changeCourse:
        final course = await showChangeCourseSheet(
          context,
          selectedCourse: _selectedCourse,
        );
        if (mounted && course != null) {
          setState(() => _selectedCourse = course);
        }
        return;
      case CourseOverviewAction.openCourse:
        await _openCourse();
        return;
    }
  }

  Future<void> _openCourse() async {
    final shouldContinue = await showCourseOpenDialog(
      context,
      courseTitle: _selectedCourse,
    );
    if (shouldContinue && mounted) {
      final onContinueCourse = widget.onContinueCourse;
      if (onContinueCourse != null) {
        onContinueCourse();
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const SingleChoiceLessonScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: AppDesignCanvas(
        child: Stack(
          children: [
            if (_tabIndex == 0)
              const Positioned.fill(
                child: RepaintBoundary(
                  child: IgnorePointer(
                    child: PixelSceneBackdrop(child: SizedBox.expand()),
                  ),
                ),
              ),
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _tabIndex == 0
                    ? _LearnMap(
                        key: const ValueKey('learn-map'),
                        controller: _learnScrollController,
                        onStepTap: (_) => _openCourse(),
                      )
                    : const _ComingSoonPlaceholder(
                        key: ValueKey('non-learn-tab'),
                      ),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 128,
              child: _StatsHeader(),
            ),
            if (_tabIndex == 0)
              Positioned(
                left: 20,
                top: _sectionHeaderTop,
                width: 390,
                height: _sectionHeaderHeight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _stickySectionIndex == 0
                      ? Semantics(
                          key: const ValueKey('first-section-header'),
                          button: true,
                          label: 'Kursni ko’rish',
                          child: GestureDetector(
                            key: const ValueKey('learn-course-section'),
                            behavior: HitTestBehavior.opaque,
                            onTap: _openCourseOverview,
                            child: const LessonSectionHeaderCard(
                              category: 'Sun’iy intellektga kirish',
                              title: '1. Prompt Engineeringga kirish',
                              progress: 1,
                            ),
                          ),
                        )
                      : const LessonSectionHeaderCard(
                          key: ValueKey('second-section-header'),
                          category: 'Sun’iy intellektga kirish',
                          title: '2. Prompt Engineering qoidalari',
                          progress: 0,
                          isLocked: true,
                        ),
                ),
              ),
            Positioned(
              left: 98,
              bottom: 34,
              width: 234,
              height: 78,
              child: AppBottomNavBar(
                items: _tabs,
                currentIndex: _tabIndex,
                onTap: (index) => setState(() => _tabIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 52, 10, 10),
        child: Row(
          children: [
            Expanded(
              child: AppStatPill(
                icon: Image.asset(
                  'assets/images/learn/coin.png',
                  fit: BoxFit.contain,
                ),
                value: '220',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppStatPill(
                icon: Image.asset(
                  'assets/images/learn/key.png',
                  fit: BoxFit.contain,
                ),
                value: '2',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppStatPill(
                icon: Image.asset(
                  'assets/images/learn/fire.png',
                  fit: BoxFit.contain,
                ),
                value: '3',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearnMap extends StatelessWidget {
  const _LearnMap({
    required this.controller,
    required this.onStepTap,
    super.key,
  });

  final ScrollController controller;
  final ValueChanged<int> onStepTap;

  static const _firstSectionPathTop = 243.0;
  static const _firstProjectTop = _firstSectionPathTop + 1056;
  static const _secondSectionHeaderTop = _firstSectionPathTop + 1190;
  static const _secondSectionPathTop = _secondSectionHeaderTop + 135;
  // Extra bottom space lets the final nodes remain reachable once the second
  // section header has reached the fixed header position.
  static const _height = 2460.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('learn-path-scroll'),
      controller: controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: SizedBox(
        width: 430,
        height: _height,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: _firstSectionPathTop,
              width: 430,
              height: 1042,
              child: LearningPathTrail(
                steps: _pathSteps,
                height: 1042,
                onStepTap: onStepTap,
              ),
            ),
            Positioned(
              left: 61,
              top: _firstProjectTop,
              width: 308,
              height: 114,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.card,
                  boxShadow: AppShadows.card,
                ),
                child: const LessonProjectPreviewCard(
                  label: 'Bo’lim loyihasi',
                  title: 'Bot',
                  imagePath: 'assets/images/curriculum/bot_project.png',
                ),
              ),
            ),
            const Positioned(
              left: 20,
              top: _secondSectionHeaderTop,
              width: 390,
              height: 115,
              child: LessonSectionHeaderCard(
                key: ValueKey('scroll-second-section-header'),
                category: 'Sun’iy intellektga kirish',
                title: '2. Prompt Engineering qoidalari',
                progress: 0,
                isLocked: true,
              ),
            ),
            const Positioned(
              left: 0,
              top: _secondSectionPathTop,
              width: 430,
              height: 459,
              child: LearningPathTrail(steps: _secondSectionSteps, height: 459),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonPlaceholder extends StatelessWidget {
  const _ComingSoonPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.pageBackground,
      child: Center(child: Text('Tez orada', style: AppTypography.title)),
    );
  }
}
