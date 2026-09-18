import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final navBarHeight = MediaQuery.of(context).padding.bottom;
    
    return Container(
      height: 60 + navBarHeight,
      decoration: const BoxDecoration(
        color: AppTheme.cardBackground,
        border: Border(top: BorderSide(color: AppTheme.cardBorder, width: 1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.grid_view, 0, AppTheme.accentTeal),
                _buildNavItem(Icons.show_chart, 1, AppTheme.accentGreen),
                _buildNavItem(Icons.person, 2, AppTheme.primaryPurple),
                _buildNavItem(Icons.access_time, 3, AppTheme.accentOrange),
                _buildNavItem(Icons.star, 4, AppTheme.accentYellow),
              ],
            ),
          ),
          if (navBarHeight > 0) SizedBox(height: navBarHeight),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color color) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected ? color : AppTheme.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}

