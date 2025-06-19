import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String cancerType;
  final double riskScore;

  const ResultScreen({super.key, required this.cancerType, required this.riskScore});

  String _getRiskLevel() {
    if (riskScore < 0.3) {
      return 'Low Risk';
    } else if (riskScore < 0.7) {
      return 'Moderate Risk';
    } else {
      return 'High Risk';
    }
  }

  Color _getRiskColor() {
    if (riskScore < 0.3) {
      return Colors.blue; // More distinct and accessible than green
    } else if (riskScore < 0.7) {
      return Colors.orange; // Moderate and noticeable
    } else {
      return Colors.red; // High urgency
    }
  }

  String _getRecommendation() {
    if (riskScore < 0.3) {
      return 'The $cancerType risk is currently low. Encourage continued awareness and general health maintenance. No immediate follow-up required unless symptoms appear.';
    } else if (riskScore < 0.7) {
      return 'The $cancerType risk is moderate. Discuss risk factors with the patient. If possible, schedule a follow-up in 3–6 months or recommend local clinical assessment.';
    } else {
      return 'The $cancerType risk is high. Strongly advise referral to the nearest available facility for diagnostic evaluation. Early intervention is crucial.';
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