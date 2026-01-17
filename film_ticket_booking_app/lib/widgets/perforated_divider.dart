// lib/widgets/perforated_divider.dart
import 'package:flutter/material.dart';
// If you defined theme_config.dart, you might import it here
// import 'package:movie_booking_app/config/theme_config.dart';

class PerforatedDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const PerforatedDivider({
    super.key, 
    this.color = const Color(0xFFE0E0E0), // Default light gray/white for contrast on a dark background or faint on white
    this.dashWidth = 8.0, 
    this.dashSpace = 6.0
  });

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder gets the constraints of the parent, allowing the divider
    // to adapt to any screen width.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the total width the dashes need to fill
        // Subtract a bit (e.g., 20) if you had specific padding in the parent,
        // but here we use the full width and let Row's MainAxisAlignment handle spacing.
        final double fullWidth = constraints.constrainWidth(); 
        
        // Calculate how many dashes (and spaces) fit
        final double dashCount = (fullWidth / (dashWidth + dashSpace));

        return Padding(
          // Horizontal padding ensures the dashes don't touch the sides of the ticket card
          padding: const EdgeInsets.symmetric(horizontal: 10.0), 
          child: Row(
            // Distribute the dashes evenly across the available space
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount.toInt(), (_) {
              return SizedBox(
                width: dashWidth,
                height: 2, // Thickness of the divider line
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}