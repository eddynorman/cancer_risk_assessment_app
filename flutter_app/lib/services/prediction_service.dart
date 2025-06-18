import 'dart:math';

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

     List<double> means = [
      7.7083952968698535, 0.28823739436135554, 0.9710741892851581, 2.4630609897195375, 
      0.0693656817900463, 1.8877104966615572, 1.8170237065067407
    ];
    
    List<double> stds = [
      2.6114728947102632, 0.45288349623662755, 0.5417180583309804, 1.5078071311230858, 
      0.25385385464529087, 0.5026307176694195, 1.04315052792765
    ];
    print('Raw inputs before standardization: $inputs');

    // Only standardize if we have the correct number of parameters
    if (means.length == inputs.length && stds.length == inputs.length) {
      inputs = standardizeInputs(inputs, means, stds);
      print('Standardized inputs: $inputs');
    } else {
      print('Warning: Standardization skipped - mismatched dimensions');
      print('Input length: ${inputs.length}, means length: ${means.length}, stds length: ${stds.length}');
    }
    
    // Create output tensor
    var output = List<double>.filled(1, 0).reshape([1, 1]);
    
    // Run inference
    _breastCancerInterpreter.run(inputs.reshape([1, inputs.length]), output);
    print('breast cancer model raw output: ${output[0][0]}');
    
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
    
    // Apply standardization (StandardScaler equivalent)
    // These values should match what was used during model training
    List<double> means = [
      27.473764325751635, 2.3928970454374814, 16.92333089616198, 2.264788045447458, 
      0.14966294828664137, 1.4055782501297305, 0.4533857252880508, 0.6831584942814487, 
      2.482018082479788, 0.12267795697867474, 0.5120329646055359, 0.14515463596714517, 
      0.23469955919308844, 0.07893507359581546, 0.003451251078515962, 0.07807226082618647, 
      0.009490940465918895, 0.0008628127696289905, 0.010072462005995542, 0.0008628127696289905, 
      0.05122631996796917, 0.0008628127696289905, 0.0008628127696289905
    ];
    
    List<double> stds = [
      8.120375295511627, 1.0226480775542968, 2.072803396800414, 1.2902465254948503, 
      0.3414240817811708, 4.433104084564279, 1.760383955017597, 0.42886207408448707, 
      4.269884937687634, 0.30672304329208816, 1.7083351087909655, 0.3206611916996387, 
      0.56313913237941, 0.24585985639880167, 0.058645885998158495, 0.24437619391396384, 
      0.09695804512773191, 0.029361000046890653, 0.08275753778242374, 0.029361000046891197, 
      0.19265603689673444, 0.029361000046891104, 0.02936100004689063
    ];
    print('Raw inputs before standardization: $inputs');

    // Only standardize if we have the correct number of parameters
    if (means.length == inputs.length && stds.length == inputs.length) {
      inputs = standardizeInputs(inputs, means, stds);
      print('Standardized inputs: $inputs');
    } else {
      print('Warning: Standardization skipped - mismatched dimensions');
      print('Input length: ${inputs.length}, means length: ${means.length}, stds length: ${stds.length}');
    }
    
    // Create output tensor
    var output = List<double>.filled(1, 0).reshape([1, 1]);
    
    // Run inference
    _cervicalCancerInterpreter.run(inputs.reshape([1, inputs.length]), output);
    
    print('Cervical cancer model raw output: ${output[0][0]}');
    
    // If your model outputs a probability directly (0-1), convert to percentage
    // If it outputs logits, apply sigmoid first
    double probability;
    
    // Determine if sigmoid is needed based on the output range
    // If output is already between 0-1, it might be a probability
    // If output can be outside 0-1, it might be a logit needing sigmoid
    if (output[0][0] < 0 || output[0][0] > 1) {
      probability = _sigmoid(output[0][0]);
      print('Applied sigmoid, probability: $probability');
    } else {
      probability = output[0][0];
      print('Direct probability: $probability');
    }
    
    // Return as percentage (0-100)
    return probability * 100;
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

  List<double> standardizeInputs(List<double> inputs, List<double> means, List<double> stds) {
    List<double> standardized = [];
    for (int i = 0; i < inputs.length; i++) {
      standardized.add((inputs[i] - means[i]) / stds[i]);
    }
    return standardized;
  }

  double _sigmoid(double x) {
    return 1 / (1 + exp(-x));
  }

  double getProbability(double rawOutput) {
    return _sigmoid(rawOutput);
  }

  void dispose() {
    if (_initialized) {
      _breastCancerInterpreter.close();
      _cervicalCancerInterpreter.close();
    }
  }
}
