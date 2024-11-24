# Hedieaty

A new Flutter project.

## Structure

lib/
├── core/
│   ├── constants/             # App-wide constants and theme definitions
│   │   ├── app_colors.dart      # Color palette used across the app
│   │   ├── app_icons.dart       # Icon definitions for the app
│   │   ├── app_strings.dart     # Static strings for localization
│   │   └── app_styles.dart      # Text styles and general app styling
│   ├── utils/                 # Utility classes and helpers
│   │   ├── error_handler.dart   # Centralized error handling logic
│   │   ├── log_manager.dart     # Logging functionality
│   │   ├── validators.dart      # Input validation utilities
│   │   └── extensions/          # Custom Dart extensions for convenience
│   └── di/                    # Dependency injection setup
│       ├── config.dart          # DI configurations
│       └── service_locator.dart # Service locator pattern implementation
│
├── data/
│   ├── repositories/          # Concrete implementations of domain repositories
│   │   ├── user_repository_impl.dart    # User repository implementation
│   │   ├── event_repository_impl.dart   # Event repository implementation
│   │   ├── gift_repository_impl.dart    # Gift repository implementation
│   │   └── friend_repository_impl.dart  # Friend repository implementation
│   ├── local/                 # Local data handling
│   │   ├── models/              # Models for local storage
│   │   │   ├── event_model.dart   # Event model for local storage
│   │   │   ├── friend_model.dart  # Friend model for local storage
│   │   │   ├── gift_model.dart    # Gift model for local storage
│   │   │   └── user_model.dart    # User model for local storage
│   │   └── datasources/         # Local data sources
│   │       ├── sqlite_event_datasource.dart   # SQLite datasource for events
│   │       ├── sqlite_friend_datasource.dart  # SQLite datasource for friends
│   │       ├── sqlite_gift_datasource.dart    # SQLite datasource for gifts
│   │       └── sqlite_user_datasource.dart    # SQLite datasource for users
│   ├── remote/                # Remote data handling
│   │   ├── models/              # Models for remote APIs
│   │   │   ├── event_dto.dart    # Event Data Transfer Object (DTO)
│   │   │   ├── friend_dto.dart   # Friend DTO
│   │   │   ├── gift_dto.dart     # Gift DTO
│   │   │   └── user_dto.dart     # User DTO
│   │   └── datasources/         # Remote data sources
│   │       ├── firebase_event_datasource.dart   # Firebase datasource for events
│   │       ├── firebase_friend_datasource.dart  # Firebase datasource for friends
│   │       ├── firebase_gift_datasource.dart    # Firebase datasource for gifts
│   │       └── firebase_user_datasource.dart    # Firebase datasource for users
│   └── utils/                 # Data-specific utilities
│       ├── barcode_scanner_service.dart # Barcode scanner utility
│       ├── firebase_auth_service.dart   # Firebase authentication service
│       └── network_manager.dart         # Network connection management
│
├── domain/
│   ├── entities/              # Core domain entities
│   │   ├── event.dart           # Event entity
│   │   ├── friend.dart          # Friend entity
│   │   ├── gift.dart            # Gift entity
│   │   └── user.dart            # User entity
│   ├── repositories/          # Abstract repository interfaces
│   │   ├── event_repository.dart   # Interface for event repository
│   │   ├── friend_repository.dart  # Interface for friend repository
│   │   ├── gift_repository.dart    # Interface for gift repository
│   │   └── user_repository.dart    # Interface for user repository
│   └── usecases/              # Business logic use cases
│       ├── add_event_usecase.dart       # Add a new event
│       ├── get_friends_usecase.dart     # Retrieve a list of friends
│       ├── pledge_gift_usecase.dart     # Pledge a gift to an event
│       ├── sync_gift_list_usecase.dart  # Synchronize the gift list
│       └── update_gift_status_usecase.dart # Update the status of a gift
│
├── presentation/
│   ├── pages/                 # UI pages and their controllers
│   │   ├── auth/                # Authentication pages
│   │   │   ├── auth_controller.dart # Auth-related logic
│   │   │   ├── login_page.dart      # Login UI
│   │   │   └── signup_page.dart     # Signup UI
│   │   ├── events/              # Event-related pages
│   │   │   ├── event_controller.dart # Event page logic
│   │   │   └── event_list_page.dart  # Event list UI
│   │   ├── gifts/               # Gift-related pages
│   │   │   ├── gift_controller.dart # Gift page logic
│   │   │   ├── gift_details_page.dart # Gift details UI
│   │   │   └── gift_list_page.dart    # Gift list UI
│   │   ├── home/                # Home page
│   │   │   ├── home_controller.dart # Home page logic
│   │   │   └── home_page.dart      # Home UI
│   │   ├── pledged_gifts/        # Pledged gifts pages
│   │   │   ├── pledge_controller.dart # Pledge gift logic
│   │   │   └── pledged_gifts_page.dart # Pledged gifts UI
│   │   └── profile/             # User profile pages
│   │       ├── profile_controller.dart # Profile page logic
│   │       └── profile_page.dart      # Profile UI
│   ├── widgets/               # Reusable UI components
│   │   ├── custom_input_field.dart # Custom text input widget
│   │   ├── event_tile.dart        # Event list item widget
│   │   ├── friend_list_tile.dart  # Friend list item widget
│   │   └── gift_card.dart         # Gift card widget
│   └── routes/                # Navigation and routing setup
│       ├── app_router.dart       # Route management
│       ├── navigation_service.dart # Centralized navigation service
│       └── route_names.dart      # Route name constants
│
└── test/
├── unit/                  # Unit tests
│   ├── datasources/         # Test cases for data sources
│   ├── repositories/        # Test cases for repositories
│   └── usecases/            # Test cases for use cases
├── widget/               # Widget tests
│   ├── event_list_page_test.dart  # Event list page tests
│   ├── gift_list_page_test.dart   # Gift list page tests
│   └── home_page_test.dart        # Home page tests
└── integration/          # Integration tests
├── add_gift_flow_test.dart    # Test for adding a gift flow
└── pledge_gift_flow_test.dart # Test for pledging a gift flow