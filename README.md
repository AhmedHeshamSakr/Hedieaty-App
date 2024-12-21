### Hedieaty: Gift List Management App

**Hedieaty** is a Flutter-based app designed to streamline creating, managing, and sharing gift lists for special occasions. The app features intuitive UI, barcode scanning, real-time cloud syncing, and notifications to enhance the joy of gift-giving.

---

### **Features**
- **Event and Gift Management**: Create, edit, delete, and organize events and gift lists.
- **Barcode Scanner**: Add gifts by scanning product barcodes.
- **Real-Time Updates**: Sync lists and statuses (available, pledged, purchased) across devices using Firebase.
- **Friend Interaction**: Share lists, view friends' lists, and pledge gifts in real time.
- **Notifications**: Receive alerts when a gift is pledged or status updates occur.
- **User-Friendly Interface**: Visually appealing and responsive UI with animations and transitions.
- **Cross-Platform**: Available for iOS, Android, and Amazon App Store.

---

### **Application Architecture**
The app follows **Clean Architecture**, ensuring modularity, scalability, and maintainability.

#### **Project Structure**
```plaintext
├── core/               # Shared utilities, configurations, and constants
│   ├── constants/      # Colors, icons, strings, and styles
│   ├── utils/          # Error handling, logging, and validation
│   ├── di/             # Dependency injection setup , SQLite Initialization Here
├── data/               # Data layer for interacting with local and remote sources
│   ├── repositories/   # Repository implementations
│   ├── local/          # SQLite data sources and models
│   ├── remote/         # Firebase data sources and DTOs
│   ├── utils/          # Services like barcode scanner and Firebase auth
├── domain/             # Core business logic
│   ├── entities/       # Core data structures (e.g., Event, Gift)
│   ├── repositories/   # Repository interfaces
│   ├── usecases/       # Application-specific workflows
├── presentation/       # User interface layer
│   ├── pages/          # UI components and controllers
│   ├── routes/         # App navigation setup
│   ├── widgets/         # App navigation setup
├── test/               # Automated testing        
│   ├── integration/    # End-to-end tests for workflows
```

---

### **Core Layers and Their Responsibilities**

1. **Core**:
    - Shared utilities and configurations used across the app (e.g., themes, validators, logging).

2. **Data**:
    - **Local Storage**: SQLite for offline data persistence.
    - **Remote Storage**: Firebase for real-time updates and authentication.
    - **Repositories**: Bridges the domain and data layers for fetching and storing data.

3. **Domain**:
    - Defines the business logic via **entities** and **use cases**.
    - Operates independently of frameworks or external libraries.

4. **Presentation**:
    - Handles UI components and state management.
    - Connects the UI to the domain layer for data operations and event handling.

5. **Test**:
    - Includes unit, widget, and integration tests to ensure app reliability.

---

### **Database Design**
- **SQLite**: Local data storage for events, gifts, and user profiles.
- **Firebase**: Real-time synchronization and authentication.

#### **Tables**
1. **Users**: Stores user details and preferences.
2. **Events**: Stores event details like name, date, and description.
3. **Gifts**: Stores gift details and their status (available, pledged, purchased).
4. **Friends**: Links users to their friends.

---

### **Technologies Used**
- **Flutter**: Frontend development.
- **SQLite**: Local database.
- **Firebase**: Authentication, real-time database, and notifications.
- **Dart**: Core programming language.
- **Git**: Version control.

---

### **Testing and Quality Assurance**
- Automated tests for unit, widget, and integration workflows using Flutter's testing framework.
- **Auto-Test Script**: A shell script to run test cases using `adb` commands, generating logs for review.

---

### **How to Contribute**
1. Clone the repository:
   ```bash
   git clone[ https://github.com/your-repo/hedieaty](https://github.com/AhmedHeshamSakr/Hedieaty-App).git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```
4. Execute tests:
   ```bash
   flutter test
   ```

---

### **Deployment**
- Published **Amazon App Store**.
- Access the app here: [   ].

---

### **License**
© 2024 Hedieaty. All Rights Reserved.

