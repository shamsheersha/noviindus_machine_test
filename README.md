# 🏥 Ayurveda Care - Patient Management System

A comprehensive Flutter application for managing Ayurvedic Centre patients with modern UI/UX and robust functionality.




## ✨ Features

### 🔐 Authentication
- Secure login system with token-based authentication
- Persistent session management
- Auto-logout on token expiration

### 👥 Patient Management
- **Patient List**: View all registered patients with pull-to-refresh
- **Patient Registration**: Comprehensive form with validation
- **Patient Details**: Detailed view with treatment information
- **Search & Filter**: Easy patient lookup

### 🏥 Treatment Management
- **Treatment Selection**: Choose from available treatments
- **Gender-based Count**: Separate male/female patient counts
- **Treatment Pricing**: Automatic price calculations

### 📊 Branch Management
- **Multi-branch Support**: Manage multiple clinic branches
- **Location-based**: Static location dropdown
- **Branch Details**: Complete branch information

### 💰 Financial Management
- **Payment Options**: Cash, Card, UPI support
- **Amount Calculations**: Total, Discount, Advance, Balance
- **Financial Summary**: Complete payment breakdown

### 📄 PDF Generation
- **Professional Reports**: Generate patient booking details
- **Watermark Logo**: Branded PDF documents
- **Print & Share**: Easy document sharing

### 🎨 Modern UI/UX
- **Material Design**: Clean and intuitive interface
- **Theme Support**: Light/Dark theme compatibility
- **Responsive Design**: Works on all screen sizes
- **Custom Colors**: Brand-consistent color scheme

## 🛠️ Technical Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: SharedPreferences
- **PDF Generation**: pdf + printing packages
- **Architecture**: Clean Architecture with MVVM pattern

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  http: ^1.5.0
  shared_preferences: ^2.5.3
  provider: ^6.1.5+1
  intl: ^0.20.2
  pdf: ^3.11.3
  printing: ^5.14.2
  flutter_launcher_icons: ^0.14.4
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/shamsheersha/noviindus_machine_test.git
   cd ayurveda-care
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```



## 🌐 API Integration

The app integrates with the following REST APIs:




```

## 📁 Project Structure
