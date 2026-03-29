import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../main.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            // Prominent Streak Section
            _BentoSection(
              title: 'Current Streak',
              value: '${appState.streakCount}',
              unit: 'Days',
              icon: Icons.local_fire_department_rounded,
              color: Colors.orange,
              isLarge: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BentoSection(
                    title: 'Journals',
                    value: '${appState.journals.length}',
                    icon: Icons.history_edu_rounded,
                    color: Colors.blueAccent,
                    onTap: () => context.push('/account/journal'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _BentoSection(
                    title: 'Triggers',
                    value: '${appState.triggers.length}',
                    icon: Icons.warning_rounded,
                    color: Colors.amber[700]!,
                    onTap: () => context.push('/account/triggers'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _BentoSection(
              title: 'Active Goals',
              value: '${appState.goals.length}',
              icon: Icons.stars_rounded,
              color: Colors.deepPurpleAccent,
              onTap: () => context.push('/account/goals'),
            ),
          ],
        );
      },
    );
  }
}

class _BentoSection extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isLarge;

  const _BentoSection({
    required this.title,
    required this.value,
    this.unit,
    required this.icon,
    required this.color,
    this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isLarge ? 160 : 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: isLarge
                ? _buildLargeLayout(context)
                : _buildSmallLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: -2,
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    unit!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 48, color: color),
        ),
      ],
    );
  }

  Widget _buildSmallLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: color),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -1,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
