import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/question.dart';
//import 'dart:ffi';


class PredictionService {
  late Interpreter _breastCancerInterpreter;
  late Interpreter _cervicalCancerInterpreter;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      _breastCancerInterpreter = await Interpreter.fromAsset('assets/models/breast_cancer_model.tflite');
      // Uncomment when you have the cervical cancer model
      _cervicalCancerInterpreter = await Interpreter.fromAsset('assets/models/cervical_cancer_model.tflite');
      _initialized = true;
    } catch (e) {
      print('Error loading model: $e');
      rethrow;
    }
  }

  Future<double> predictBreastCancerRisk(List<Question> questions) async {
    await initialize();
    
    // Convert answers to a format suitable for your model
    List<double> inputs = _prepareBreastCancerInputs(questions);
    
    // Create output tensor
    var output = List<double>.filled(1, 0).reshape([1, 1]);
    
    // Run inference
    _breastCancerInterpreter.run(inputs.reshape([1, inputs.length]), output);
    
    return output[0][0];
  }

  List<double> _prepareBreastCancerInputs(List<Question> questions) {
    List<double> inputs = [];
    
    for (var question in questions) {
      if (question.type == 'boolean') {
        inputs.add(question.answer == true ? 1.0 : 0.0);
      } else if (question.type == 'number') {
        inputs.add(double.tryParse(question.answer.toString()) ?? 0.0);
      } else if (question.type == 'string' && question.options != null) {
        // Convert string options to one-hot encoding or numerical values
        // This depends on how your model expects the data
        final index = question.options!.indexOf(question.answer);
        inputs.add(index.toDouble());
      }
    }
    
    return inputs;
  }

  // Similar method for cervical cancer prediction
  Future<double> predictCervicalCancerRisk(List<Question> questions) async {
    await initialize();
    
    // Convert answers to a format suitable for your model
    List<double> inputs = _prepareCervicalCancerInputs(questions);
    
    // Create output tensor
    var output = List<double>.filled(1, 0).reshape([1, 1]);
    
    // Run inference
    _breastCancerInterpreter.run(inputs.reshape([1, inputs.length]), output);
    
    return output[0][0];
  }

  List<double> _prepareCervicalCancerInputs(List<Question> questions) {
    List<double> inputs = [];
    
    for (var question in questions) {
      if (question.type == 'boolean') {
        inputs.add(question.answer == true ? 1.0 : 0.0);
      } else if (question.type == 'number') {
        inputs.add(double.tryParse(question.answer.toString()) ?? 0.0);
      } else if (question.type == 'string' && question.options != null) {
        // Convert string options to one-hot encoding or numerical values
        // This depends on how your model expects the data
        final index = question.options!.indexOf(question.answer);
        inputs.add(index.toDouble());
      }
    }
    
    return inputs;
  }

  void dispose() {
    if (_initialized) {
      _breastCancerInterpreter.close();
      _cervicalCancerInterpreter.close();
    }
  }
}
