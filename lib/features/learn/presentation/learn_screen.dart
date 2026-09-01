import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../shared/widgets/lesson_project_preview_card.dart';
import 'widgets/learning_path_node.dart';
import 'widgets/learning_path_trail.dart';
import 'widgets/lesson_section_header_card.dart';
import 'widgets/pixel_scene_backdrop.dart';

const _pathSteps = [
  LearningPathStep(state: LearningPathNodeState.completed),
  LearningPathStep(state: LearningPathNodeState.completed),
  LearningPathStep(state: LearningPathNodeState.current),
  LearningPathStep(state: LearningPathNodeState.locked),
  LearningPathStep(state: LearningPathNodeState.locked),
  LearningPathStep(state: LearningPathNodeState.locked),
  LearningPathStep(state: LearningPathNodeState.locked),
];

/// The gamified "Learn" home tab: a scrolling learning path framed by a
/// fixed stats header and a fixed floating bottom navigation bar. Reached
/// after logging in or finishing profile creation.
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  /// Height of the white chrome band holding the status bar and stat pills.
  static const _headerHeight = 127.0;

  int _tabIndex = 0;

  static const _tabs = [
    AppBottomNavItem(icon: Icons.school_rounded, semanticLabel: 'O’qish'),
    AppBottomNavItem(
      icon: Icons.workspace_premium_rounded,
      semanticLabel: 'Yutuqlar',
    ),
    AppBottomNavItem(
      icon: Icons.person_outline_rounded,
      semanticLabel: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: AppDesignCanvas(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: _headerHeight,
              bottom: 0,
              child: _tabIndex == 0
                  ? const _LearnPathContent()
                  : const _ComingSoonPlaceholder(),
            ),
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: _headerHeight,
              child: _LearnHeader(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 34,
              child: Center(
                child: SizedBox(
                  width: 244,
                  child: AppBottomNavBar(
                    items: _tabs,
                    currentIndex: _tabIndex,
                    onTap: (index) => setState(() => _tabIndex = index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fixed white band carrying the gamification counters.
class _LearnHeader extends StatelessWidget {
  const _LearnHeader();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 68, 10, 15),
        child: Row(
          children: [
            Expanded(
              child: AppStatPill(
                icon: Icon(Icons.paid_rounded, color: AppColors.primary),
                value: '220',
              ),
            ),
            SizedBox(width: AppSpacing.medium),
            Expanded(
              child: AppStatPill(
                icon: Icon(Icons.vpn_key_rounded, color: AppColors.primary),
                value: '2',
              ),
            ),
            SizedBox(width: AppSpacing.medium),
            Expanded(
              child: AppStatPill(
                icon: Icon(Icons.water_drop_rounded, color: AppColors.primary),
                value: '3',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearnPathContent extends StatelessWidget {
  const _LearnPathContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: PixelSceneBackdrop(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            22,
            AppSpacing.screenHorizontal,
            140,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LessonSectionHeaderCard(
                category: 'Sun’iy intellektga kirish',
                title: '1. Prompt Engineeringga kirish',
                progress: 1,
              ),
              const SizedBox(height: 12),
              const LearningPathTrail(steps: _pathSteps),
              const SizedBox(height: 24),
              // The section project sits inset from the header cards above it.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 41),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.lessonCard,
                    boxShadow: AppShadows.card,
                  ),
                  child: const SizedBox(
                    height: 96,
                    child: LessonProjectPreviewCard(
                      label: 'Bo’lim loyihasi',
                      title: 'Bot',
                      imagePath: 'assets/images/curriculum/bot_project.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const LessonSectionHeaderCard(
                category: 'Sun’iy intellektga kirish',
                title: '2. Prompt Engineering qoidalari',
                progress: 0,
                isLocked: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoonPlaceholder extends StatelessWidget {
  const _ComingSoonPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.pageBackground,
      child: Center(child: Text('Tez orada', style: AppTypography.title)),
    );
  }
}
