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
      _breastCancerInterpreter = await Interpreter.fromAsset(
        'assets/models/breast_cancer_model.tflite',
      );
      _cervicalCancerInterpreter = await Interpreter.fromAsset(
        'assets/models/cervical_cancer_model.tflite',
      );
      _initialized = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<double> predictBreastCancerRisk(List<Question> questions) async {
    await initialize();

    // Converting answers to a format suitable for our model
    List<double> inputs = _prepareBreastCancerInputs(questions);

    List<double> means = [
      7.7083952968698535,
      0.28823739436135554,
      0.9710741892851581,
      2.4630609897195375,
      0.0693656817900463,
      1.8877104966615572,
      1.8170237065067407,
    ];

    List<double> stds = [
      2.6114728947102632,
      0.45288349623662755,
      0.5417180583309804,
      1.5078071311230858,
      0.25385385464529087,
      0.5026307176694195,
      1.04315052792765,
    ];

    // Only standardize if we have the correct number of parameters
    if (means.length == inputs.length && stds.length == inputs.length) {
      inputs = standardizeInputs(inputs, means, stds);
    }

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
        inputs.add(
          question.answer == true || question.answer == 1.0 ? 1.0 : 0.0,
        );
      } else if (question.type == 'number') {
        inputs.add(double.tryParse(question.answer.toString()) ?? 0.0);
      } else if (question.type == 'string' && question.options != null) {
        final index = question.options!.indexOf(question.answer);
        inputs.add(index.toDouble());
      }
    }

    return inputs;
  }

  Future<double> predictCervicalCancerRisk(List<Question> questions) async {
    await initialize();

    // Convert answers to a format suitable for your model
    List<double> inputs = _prepareCervicalCancerInputs(questions);

    // Apply standardization (StandardScaler equivalent)
    // These values should match what was used during model training
    List<double> means = [
      27.112454655380894, 2.4099153567110037, 16.86154776299879, 2.2273276904474004, 
      0.1487303506650544, 1.2462691579625151, 0.4630068177733978, 0.6989117291414753, 
      2.0383729154074968, 0.1003627569528416, 0.4612696493349456, 0.09552599758162031, 
      0.1608222490931076
    ];

    List<double> stds = [
      8.467916669235091, 1.0924821112179741, 2.333292306018365, 1.4451948460056407, 
      0.3558224746360246, 4.126823866333211, 2.2483634318223578, 0.4587309930775861, 
      3.641969156693785, 0.3004830676921188, 1.8447483441615602, 0.29394009826435147, 
      0.538270148873986
    ];
    // Step 1: Extract continuous inputs (0–12)
    List<double> continuousInputs = inputs.sublist(0, 13);

    // Step 2: Standardize only the continuous inputs
    List<double> standardizedContinuous = [];
    // Only standardize if we have the correct number of parameters
    if (means.length == continuousInputs.length &&
        stds.length == continuousInputs.length) {
      standardizedContinuous = standardizeInputs(
        continuousInputs,
        means,
        stds,
      );
    } 
    // Step 3: Get binary inputs (13–22)
    List<double> binaryInputs = inputs.sublist(13, 23);

    // Step 4: Merge them back together
    List<double> finalInputs = [...standardizedContinuous, ...binaryInputs];
    
    // Create output tensor
    var output = List<double>.filled(1, 0).reshape([1, 1]);

    // Run inference
    _cervicalCancerInterpreter.run(finalInputs.reshape([1, finalInputs.length]), output);

    // If your model outputs a probability directly (0-1), convert to percentage
    // If it outputs logits, apply sigmoid first
    double probability;

    // Determine if sigmoid is needed based on the output range
    // If output is already between 0-1, it might be a probability
    // If output can be outside 0-1, it might be a logit needing sigmoid
    if (output[0][0] < 0 || output[0][0] > 1) {
      probability = _sigmoid(output[0][0]);
    } else {
      probability = output[0][0];
    }

    return probability;
  }

  List<double> _prepareCervicalCancerInputs(List<Question> questions) {
    List<double> inputs = [];

    for (var question in questions) {
      if (question.type == 'boolean') {
        inputs.add(
          question.answer == true || question.answer == 1.0 ? 1.0 : 0.0,
        );
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

  List<double> standardizeInputs(
    List<double> inputs,
    List<double> means,
    List<double> stds,
  ) {
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
