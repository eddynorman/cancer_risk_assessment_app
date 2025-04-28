import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String cancerType;
  final double riskScore;

  const ResultScreen({super.key, required this.cancerType, required this.riskScore});

  String _getRiskLevel() {
    if (riskScore < 0.3) {
      return 'Low';
    } else if (riskScore < 0.7) {
      return 'Moderate';
    } else {
      return 'High';
    }
  }

  Color _getRiskColor() {
    if (riskScore < 0.3) {
      return Colors.green;
    } else if (riskScore < 0.7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getRecommendation() {
    if (riskScore < 0.3) {
      return 'Continue with regular screenings as recommended by your healthcare provider.';
    } else if (riskScore < 0.7) {
      return 'Consider discussing your risk factors with your healthcare provider and possibly increasing screening frequency.';
    } else {
      return 'Please consult with your healthcare provider as soon as possible to discuss your risk factors and develop a monitoring plan.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final riskLevel = _getRiskLevel();
    final riskColor = _getRiskColor();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Risk Assessment Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${cancerType.capitalize()} Cancer Risk Assessment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: riskColor, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Risk Level: $riskLevel',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Score: ${(riskScore * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Recommendation:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _getRecommendation(),
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Disclaimer: This assessment is based on the information provided and should not replace professional medical advice.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Return to Home', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}