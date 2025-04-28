import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import '../widgets/question_widget.dart';
import 'result_screen.dart';
import '../services/prediction_service.dart';
import '../theme/app_theme.dart';

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
    final iconData = widget.cancerType == 'breast' 
        ? Icons.female 
        : Icons.favorite_border;
    final color = widget.cancerType == 'breast' 
        ? Color(0xFFF48FB1) 
        : Color(0xFF81C784);
        
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cancerType.capitalize()} Cancer Assessment'),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading questions...', style: AppTheme.bodyStyle),
                ],
              ),
            )
          : _questions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text('No questions available.', style: AppTheme.subheadingStyle),
                    ],
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      // Header with progress
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(iconData, color: color),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimaryColor,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: (_currentQuestionIndex + 1) / _questions.length,
                                          minHeight: 8,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor: AlwaysStoppedAnimation<Color>(color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Question content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: QuestionWidget(
                                  question: _questions[_currentQuestionIndex],
                                  onAnswer: _answerQuestion,
                                ),
                              ),
                              SizedBox(height: 20),
                              
                              // Information card (optional)
                              
                            ],
                          ),
                        ),
                      ),
                      
                      // Navigation buttons
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentQuestionIndex > 0)
                              ElevatedButton.icon(
                                onPressed: _previousQuestion,
                                icon: Icon(Icons.arrow_back),
                                label: Text('Previous'),
                                style: AppTheme.secondaryButtonStyle,
                              )
                            else
                              SizedBox(width: 120),
                              
                            if (_currentQuestionIndex < _questions.length - 1)
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (_questions[_currentQuestionIndex].answer != null) {
                                    _answerQuestion(_questions[_currentQuestionIndex].answer);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Please answer the question'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(Icons.arrow_forward),
                                label: Text('Next'),
                                style: AppTheme.primaryButtonStyle,
                              )
                            else
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (_questions[_currentQuestionIndex].answer != null) {
                                    _submitAnswers();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Please answer the question'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(Icons.check_circle),
                                label: Text('Submit'),
                                style: AppTheme.primaryButtonStyle,
                              ),
                          ],
                        ),
                      ),
                    ],
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
