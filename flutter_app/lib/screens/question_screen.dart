import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import '../widgets/question_widget.dart';
import 'result_screen.dart';
import '../services/prediction_service.dart';

class QuestionScreen extends StatefulWidget {
  final String cancerType;

  const QuestionScreen({super.key, required this.cancerType});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final QuestionService _questionService = QuestionService();
  final PredictionService _predictionService = PredictionService();
  List<Question> _questions = [];
  bool _isLoading = true;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      if (widget.cancerType == 'breast') {
        _questions = await _questionService.loadBreastCancerQuestions();
      } else {
        _questions = await _questionService.loadCervicalCancerQuestions();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading questions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions. Please try again.')),
      );
    }
  }

  void _answerQuestion(dynamic answer) {
    setState(() {
      _questions[_currentQuestionIndex].answer = answer;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _submitAnswers();
      }
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitAnswers() async {
    try {
      double riskScore;
      if (widget.cancerType == 'breast') {
        riskScore = await _predictionService.predictBreastCancerRisk(_questions);
      } else {
        riskScore = await _predictionService.predictCervicalCancerRisk(_questions);
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            cancerType: widget.cancerType,
            riskScore: riskScore,
          ),
        ),
      );
    } catch (e) {
      print('Error predicting risk: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to calculate risk. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cancerType.capitalize()} Cancer Risk Assessment'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? Center(child: Text('No questions available.'))
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: (_currentQuestionIndex + 1) / _questions.length,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: QuestionWidget(
                              question: _questions[_currentQuestionIndex],
                              onAnswer: _answerQuestion,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentQuestionIndex > 0)
                              ElevatedButton(
                                onPressed: _previousQuestion,
                                child: Text('Previous'),
                              )
                            else
                              SizedBox(),
                            if (_currentQuestionIndex < _questions.length - 1)
                              ElevatedButton(
                                onPressed: () {
                                  if (_questions[_currentQuestionIndex].answer != null) {
                                    _answerQuestion(_questions[_currentQuestionIndex].answer);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please answer the question')),
                                    );
                                  }
                                },
                                child: Text('Next'),
                              )
                            else
                              ElevatedButton(
                                onPressed: () {
                                  if (_questions[_currentQuestionIndex].answer != null) {
                                    _submitAnswers();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please answer the question')),
                                    );
                                  }
                                },
                                child: Text('Submit'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1)}";
//   }
// }
