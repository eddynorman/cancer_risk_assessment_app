import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function(dynamic) onAnswer;

  QuestionWidget({required this.question, required this.onAnswer});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with existing answer if available
    if (widget.question.answer != null && widget.question.type == 'number') {
      _textController.text = widget.question.answer.toString();
    } else if (widget.question.defaultValue != null && widget.question.answer == null) {
      // Set default value if available and no answer yet
      widget.question.answer = widget.question.defaultValue;
      if (widget.question.type == 'number') {
        _textController.text = widget.question.defaultValue.toString();
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.question.required)
              Text(
                '* Required',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            SizedBox(height: 8),
            if (widget.question.hint != null)
              Text(
                widget.question.hint!,
                style: TextStyle(color: Colors.grey, fontSize: 14, fontStyle: FontStyle.italic),
              ),
            SizedBox(height: 20),
            _buildAnswerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerWidget() {
    // If options are available, use the options widget regardless of type
    if (widget.question.options != null && widget.question.options!.isNotEmpty) {
      return _buildOptionsWidget();
    }
    
    // Otherwise, use the appropriate widget based on type
    switch (widget.question.type) {
      case 'boolean':
        return _buildBooleanWidget();
      case 'number':
        return _buildNumberWidget();
      case 'string':
        return _buildTextWidget();
      default:
        return Text('Unsupported question type: ${widget.question.type}');
    }
  }

  Widget _buildBooleanWidget() {
    // Use the true/false values from the question if available
    dynamic trueValue = widget.question.trueValue ?? true;
    dynamic falseValue = widget.question.falseValue ?? false;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.question.answer = trueValue;
            });
            widget.onAnswer(trueValue);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.question.answer == trueValue ? Colors.green : null,
          ),
          child: Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.question.answer = falseValue;
            });
            widget.onAnswer(falseValue);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.question.answer == falseValue ? Colors.red : null,
          ),
          child: Text('No'),
        ),
      ],
    );
  }

  Widget _buildNumberWidget() {
    return TextField(
      controller: _textController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))], // Allow decimals
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.question.hint ?? 'Enter a number',
        suffixIcon: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              double value = double.parse(_textController.text);
              setState(() {
                widget.question.answer = value;
              });
              widget.onAnswer(value);
            }
          },
        ),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          double numValue = double.parse(value);
          setState(() {
            widget.question.answer = numValue;
          });
          widget.onAnswer(numValue);
        }
      },
    );
  }

  Widget _buildTextWidget() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: widget.question.hint ?? 'Enter your answer',
      ),
      onSubmitted: (value) {
        setState(() {
          widget.question.answer = value;
        });
        widget.onAnswer(value);
      },
    );
  }

  Widget _buildOptionsWidget() {
    return Column(
      children: widget.question.options!.map((option) {
        // Handle different option formats
        String label;
        dynamic value;
        
        if (option is Map) {
          // Format: {"value": 1, "label": "20-24 years"}
          label = option['label']?.toString() ?? '';
          value = option['value'];
        } else if (option is String) {
          // Format: "Option text"
          label = option;
          value = option;
        } else {
          // Fallback
          label = option.toString();
          value = option;
        }
        
        return ListTile(
          title: Text(label),
          leading: Radio<dynamic>(
            value: value,
            groupValue: widget.question.answer,
            onChanged: (selectedValue) {
              setState(() {
                widget.question.answer = selectedValue;
              });
              widget.onAnswer(selectedValue);
            },
          ),
        );
      }).toList(),
    );
  }
}
