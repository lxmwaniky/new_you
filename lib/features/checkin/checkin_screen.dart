import 'package:flutter/material.dart';
import '../../main.dart';
import 'widgets/streak_card.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-In'), centerTitle: true),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          final isCheckedIn = appState.isCheckedInToday;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              children: [
                StreakCard(count: appState.streakCount),
                const SizedBox(height: 48),
                Text(
                  isCheckedIn
                      ? 'You\'re all set for today!'
                      : 'Consistency is key',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You have checked in ${appState.totalCheckIns} unique days total.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 64),
                // Premium Check-In Button
                GestureDetector(
                  onTap: isCheckedIn
                      ? null
                      : () {
                          appState.addCheckIn(true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Check-in successful! Keep it up.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: isCheckedIn
                          ? Colors.grey[300]
                          : Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: isCheckedIn
                          ? []
                          : [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isCheckedIn
                              ? Icons.verified_rounded
                              : Icons.done_all_rounded,
                          size: 64,
                          color: isCheckedIn ? Colors.grey[600] : Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isCheckedIn ? 'CHECKED IN' : 'CHECK IN',
                          style: TextStyle(
                            color: isCheckedIn
                                ? Colors.grey[600]
                                : Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
