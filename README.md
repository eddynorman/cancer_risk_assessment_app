Cancer Risk Assessment App
This repository provides a comprehensive solution for assessing the risk of breast and cervical cancer, including data preprocessing, model training, and a mobile application for end-user interaction. The project leverages machine learning techniques to predict the likelihood of cancer risk based on various medical and personal factors.

📋 Project Overview
The Cancer Risk Assessment App aims to assist users in evaluating their risk of developing breast or cervical cancer using a mobile app. The solution is composed of the following main components:

Machine Learning Pipeline: Python scripts for data cleaning and model training

TensorFlow Lite Models: Optimized models for efficient mobile deployment

Flutter Application: A cross-platform mobile application for user interaction and risk assessment

🗂️ Project Structure
plaintext
Copy
Edit
cancer_risk_assessment_app/
├── datasets/                           # Data files
│   ├── breast_cancer_data.csv          # Raw breast cancer dataset
│   ├── cleaned_breast_cancer_data.csv  # Cleaned breast cancer dataset
│   ├── risk_factors_cervical_cancer.csv # Raw cervical cancer dataset
│   └── cleaned_cervical_cancer_data.csv # Cleaned cervical cancer dataset
├── ml/                                 # Machine learning scripts
│   ├── Breast_Cancer_Data_Cleaning.ipynb    # Data preprocessing for breast cancer
│   ├── Breast_Cancer_Model_Training.ipynb   # Model training for breast cancer
│   ├── Cervical_Cancer_Data_Cleaning.ipynb  # Data preprocessing for cervical cancer
│   ├── Cervical_Cancer_Model_Training.ipynb # Model training for cervical cancer
│   ├── requirements.txt                # Python dependencies
│   └── saved_models/                   # Saved models for deployment
│       ├── breast_cancer_model.h5      # Trained breast cancer model (Keras)
│       ├── breast_cancer_model.tflite  # Optimized TensorFlow Lite model for mobile
│       ├── cervical_cancer_model.h5    # Trained cervical cancer model (Keras)
│       └── cervical_cancer_model.tflite # Optimized TensorFlow Lite model for mobile
└── flutter_app/                        # Flutter mobile app
    ├── assets/                         # App assets, including models
    ├── lib/                            # Flutter source code
    └── README.md                       # Flutter app documentation
🔧 Setup and Installation
1. Clone the Repository
bash
Copy
Edit
git clone https://github.com/eddynorman/cancer_risk_assessment_app.git
cd cancer_risk_assessment_app
2. Create and Activate a Virtual Environment
bash
Copy
Edit
python -m venv venv
On Windows:

bash
Copy
Edit
venv\Scripts\activate
On macOS/Linux:

bash
Copy
Edit
source venv/bin/activate
3. Install Dependencies
bash
Copy
Edit
pip install -r ml/requirements.txt
4. Register the Virtual Environment as a Jupyter Kernel
bash
Copy
Edit
pip install ipykernel
python -m ipykernel install --user --name=cancer_risk_assessment
5. Running the Jupyter Notebooks
Start Jupyter Lab:

bash
Copy
Edit
jupyter lab
Select the correct kernel:

Open any notebook

Click on the kernel selector (top right)

Choose the cancer_risk_assessment kernel

Execute notebooks in the following order:

Data Cleaning:

ml/Breast_Cancer_Data_Cleaning.ipynb

ml/Cervical_Cancer_Data_Cleaning.ipynb

Model Training:

ml/Breast_Cancer_Model_Training.ipynb

ml/Cervical_Cancer_Model_Training.ipynb

📊 Machine Learning Pipeline
Data Cleaning
The data cleaning notebooks perform the following operations:

Loading raw datasets

Handling missing values

Feature engineering and selection

Exploratory data analysis (EDA)

Saving cleaned datasets for model training

Model Training
The model training notebooks involve:

Loading cleaned datasets

Data preprocessing (scaling, train-test split)

Handling class imbalance using SMOTE

Building and training neural network models

Model evaluation

Saving models in .h5 (Keras) and .tflite (TensorFlow Lite) formats

Model Architecture
The neural network architecture for both breast and cervical cancer models is as follows:

Input Layer: Matches the feature dimensions

Hidden Layers: Multiple dense layers with ReLU activation

Regularization: Batch normalization and dropout layers

Output Layer: Binary classification using sigmoid activation

Training: Binary cross-entropy loss and AdamW optimizer

📱 Flutter Application
The Flutter mobile application provides a user-friendly interface for:

Choosing between breast or cervical cancer risk assessment

Answering a medical questionnaire

Receiving the risk assessment result based on trained models

For detailed instructions on setting up and building the Flutter app, refer to the flutter_app/README.md.

🚀 Deployment
Exporting Models for Mobile
The trained models are automatically saved in TensorFlow Lite format (.tflite), optimized for mobile devices. To deploy them to the Flutter app, copy the models to the app’s assets directory:

bash
Copy
Edit
cp ml/saved_models/*.tflite flutter_app/assets/models/
Building the Flutter App
Follow the instructions in the flutter_app/README.md to build and deploy the mobile application.

🔍 Model Details
Breast Cancer Model
Input Features: Age group, family history, age at menarche, age at first birth, hormone replacement therapy usage, menopausal status, BMI group

Output: Probability of breast cancer risk (0-1)

Cervical Cancer Model
Input Features: Age, sexual history, smoking status, contraceptive usage, STD history

Output: Probability of cervical cancer risk (0-1)

🤝 Contributing
We welcome contributions! If you'd like to contribute, please follow these steps:

Fork the repository

Create a feature branch: git checkout -b feature/amazing-feature

Commit your changes: git commit -m 'Add some amazing feature'

Push to the branch: git push origin feature/amazing-feature

Open a Pull Request

📄 License
This project is licensed under the MIT License. See the LICENSE file for details.

🙏 Acknowledgments
TensorFlow and TensorFlow Lite for machine learning frameworks

Flutter for cross-platform mobile development

The medical research community for providing datasets and insights on cancer risk factors

📞 Contact
For questions or support, please open an issue in the GitHub repository.

Disclaimer: This app is designed for educational purposes only and should not be considered a substitute for professional medical advice. Always consult healthcare professionals for medical concerns.