class Question {
  final String question;
  final String type;
  final List<dynamic>? options;
  final String? hint;
  final String fieldName;
  final bool required;
  final dynamic trueValue;
  final dynamic falseValue;
  final dynamic defaultValue;
  dynamic answer;

  Question({
    required this.question,
    required this.type,
    required this.fieldName,
    this.options,
    this.hint,
    this.required = false,
    this.trueValue,
    this.falseValue,
    this.defaultValue,
    this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] ?? json['text'] ?? json['label'] ?? '',
      type: json['type'],
      fieldName: json['field_name'] ?? json['key'] ?? '',
      options: json['options'],
      hint: json['hint'],
      required: json['required'] ?? false,
      trueValue: json['true_value'],
      falseValue: json['false_value'],
      defaultValue: json['default_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'type': type,
      'field_name': fieldName,
      'options': options,
      'hint': hint,
      'required': required,
      'true_value': trueValue,
      'false_value': falseValue,
      'default_value': defaultValue,
      'answer': answer,
    };
  }
}
