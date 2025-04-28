Cancer Risk Assessment App
Cancer Risk Assessment App is a Flutter application providing risk assessment tools for breast and cervical cancer.
It uses TensorFlow Lite machine learning models to predict cancer risk based on users' responses to medical questionnaires.

📝 Project Overview
The app is designed to assist users in assessing their risk of developing breast or cervical cancer based on multiple risk factors.
It presents a series of medically relevant questions, processes the responses through trained ML models, and displays an intuitive risk score.

✨ Key Features
Separate risk assessment tools for breast cancer and cervical cancer

Step-by-step questionnaire interface

Machine learning-based risk prediction with TFLite models

User-friendly and easy-to-understand results

📂 Project Structure
bash
Copy
Edit
cancer_risk_assessment_app/
├── lib/
│   ├── models/
│   │   └── question.dart          # Question data model
│   ├── screens/
│   │   ├── question_screen.dart   # UI for the questionnaire
│   │   └── result_screen.dart     # UI for displaying results
│   ├── services/
│   │   ├── prediction_service.dart # ML model integration service
│   │   └── question_service.dart   # Service for loading questions
│   └── widgets/
│       └── question_widget.dart    # Reusable question widget
├── assets/
│   ├── data/
│   │   ├── breast_qns.json         # Breast cancer questionnaire
│   │   └── cervical_qns.json       # Cervical cancer questionnaire
│   └── models/
│       ├── breast_cancer_model.tflite   # Breast cancer ML model
│       └── cervical_cancer_model.tflite # Cervical cancer ML model
📦 Dependencies
Make sure the following are added to your pubspec.yaml:

yaml
Copy
Edit
dependencies:
  flutter:
    sdk: flutter
  tflite_flutter: ^0.9.0  # For TensorFlow Lite model integration
⚙️ Setup and Installation
Clone the repository:

bash
Copy
Edit
git clone https://github.com/eddynorman/cancer_risk_assessment_app.git
Navigate to the project directory:

bash
Copy
Edit
cd cancer_risk_assessment_app/flutter_app
Install dependencies:

bash
Copy
Edit
flutter pub get
Run the app:

bash
Copy
Edit
flutter run
🤖 Machine Learning Models
Breast Cancer Model
Location: assets/models/breast_cancer_model.tflite

Input Features (in order):

age_group_5_years (1-13)

first_degree_hx (0.0 or 1.0)

age_menarche (8-16)

age_first_birth (15-45)

current_hrt (0.0 or 1.0)

menopaus (1-3)

bmi_group (1-4)

Output:
A floating-point value between 0 and 1 representing the predicted risk of breast cancer.

Cervical Cancer Model
Location: assets/models/cervical_cancer_model.tflite

Input Features (in order):

Age, number of sexual partners, first sexual intercourse, number of pregnancies

Smoking status, smoking years, smoking packs/year

Hormonal contraceptives usage and years

IUD usage and years

STD history, number of STDs, individual STD diagnoses

Output:
A floating-point value between 0 and 1 representing the predicted risk of cervical cancer.

🛠️ How It Works
Users select between breast or cervical cancer risk assessment.

The corresponding questionnaire loads from JSON.

Users answer each question.

Responses are fed into the respective TFLite model.

The app displays a calculated risk score.

🔗 Integration with Other Projects
You can reuse the core functionality:

Copy the following directories into your project:

assets/

lib/models/

lib/services/

Update your pubspec.yaml to reference the assets and required dependencies.

Use the PredictionService class:

dart
Copy
Edit
import 'package:your_project/services/prediction_service.dart';
import 'package:your_project/models/question.dart';

// Initialize
final predictionService = PredictionService();
await predictionService.initialize();

// Prepare questions with answers
List<Question> questions = [...];

// Predict
double breastCancerRisk = await predictionService.predictBreastCancerRisk(questions);
double cervicalCancerRisk = await predictionService.predictCervicalCancerRisk(questions);

// Dispose when done
predictionService.dispose();
🖥️ Platform Support
✅ Android

✅ iOS

✅ Windows

✅ Linux

🛠️ Troubleshooting

Issue	Solution
TFLite model loading error	Ensure model files are correctly placed in assets and referenced in pubspec.yaml.
Question loading error	Verify JSON files are correctly formatted and referenced.
Platform-specific issues	Check platform-specific code in android/, ios/, windows/, or linux/ directories.
📜 License
This project is licensed under the MIT License.
See LICENSE for details.

🤝 Contributing
Contributions are welcome!
To contribute:

Fork the repository

Create a new branch (git checkout -b feature/YourFeature)

Commit your changes (git commit -m 'Add some feature')

Push to the branch (git push origin feature/YourFeature)

Open a Pull Request

🙏 Acknowledgments
TensorFlow Lite – For providing the lightweight machine learning models.

Flutter – For the cross-platform mobile development framework.

🚀 Let's work together to make early cancer risk detection more accessible!