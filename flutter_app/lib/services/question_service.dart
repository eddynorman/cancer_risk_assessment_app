import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  Future<List<Question>> loadBreastCancerQuestions() async {
    final String response = await rootBundle.loadString('assets/data/breast_qns.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Question.fromJson(json)).toList();
  }
  
  Future<List<Question>> loadCervicalCancerQuestions() async {
    final String response = await rootBundle.loadString('assets/data/cervical_qns.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Question.fromJson(json)).toList();
  }
  
  // Helper method to convert answers to a format suitable for the model
  Map<String, dynamic> prepareAnswersForModel(List<Question> questions) {
    Map<String, dynamic> modelInput = {};
    
    for (var question in questions) {
      // Skip questions without answers
      if (question.answer == null) {
        // Use default value if available
        if (question.defaultValue != null) {
          modelInput[question.fieldName] = question.defaultValue;
        } else if (question.required) {
          // For required fields without default, use appropriate fallback
          if (question.type == 'boolean') {
            modelInput[question.fieldName] = question.falseValue ?? 0.0;
          } else if (question.type == 'number') {
            modelInput[question.fieldName] = 0.0;
          } else {
            modelInput[question.fieldName] = "";
          }
        }
        continue;
      }
      
      // Add the answer to the model input
      modelInput[question.fieldName] = question.answer;
    }
    
    return modelInput;
  }
}
