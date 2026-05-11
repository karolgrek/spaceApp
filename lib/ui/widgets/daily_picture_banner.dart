import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/daily_picture_provider.dart';
import 'package:space_app/ui/screens/daily_picture_screen.dart';

class DailyPictureBanner extends ConsumerWidget {
  const DailyPictureBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: InkWell(
        onTap: () {
          if (ref.read(apodProvider).hasError) {
            ref.invalidate(apodProvider);
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DailyPictureScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset('assets/images/nasa_logo.png', height: 40, width: 40),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Check out Astronomy\nPicture of the Day!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
