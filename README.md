# Shopping App

A premium Flutter shopping and order management app built with Clean Architecture and Provider state management.

## Architecture

This project follows **Clean Architecture** principles to separate concerns and make the codebase scalable and testable.

*   `lib/data`: Contains the data layer (Models, Repositories, Services).
    *   `models`: Plain Dart objects with `fromJson` and `toJson`.
    *   `services`: Interfaces with external APIs. Here, `mock_api_service.dart` reads a local JSON file and simulates network delays.
    *   `repositories`: Acts as a single source of truth for data, parsing raw service data into Models.
*   `lib/presentation`: Contains the UI layer.
    *   `provider`: State management logic using `provider`.
    *   `screens`: Full-page views.
    *   `widgets`: Reusable UI components (e.g., `CustomButton`, `ProductCard`).
*   `lib/core`: Contains app-wide constants, theme, and configuration.

## State Management

We use **Provider** for state management. It is lightweight, easy to understand, and standard in the Flutter ecosystem.

*   `ProductProvider`: Manages fetching products, searching, and filtering.
*   `CartProvider`: Manages items added to the cart, calculates subtotals, discounts, and delivery fees.
*   `AddressProvider`: Manages the user's shipping addresses.
*   `OrderProvider`: Manages order history and simulates placing new orders.

Providers are initialized in `main.dart` using a `MultiProvider` to make them accessible throughout the widget tree.

## Mock Data Approach

To simulate a backend API without a real server, we use a local JSON file (`assets/mock_data.json`). The `MockApiService` reads this file using `rootBundle.loadString`, decodes it, and introduces artificial delays (`Future.delayed`) to simulate network latency. This allows us to properly build and test loading, empty, and error states in the UI.

## Setup Steps

1.  Ensure you have Flutter installed (`flutter --version`).
2.  Clone or open this repository.
3.  Run `flutter pub get` to install dependencies.
4.  Run `flutter run` to launch the app on your connected device or emulator.

## Assumptions & Custom Improvements

*   **Design:** Used Google Fonts ('Inter') and a modern, deep purple color scheme with 8-point grid spacing to achieve a "premium Figma-style" look. Rounded corners and shadows are applied consistently.
*   **Image Loading:** Implemented a custom `NetworkImageWithFallback` widget to gracefully handle image loading states and failures.
*   **Button Debouncing:** `CustomButton` prevents rapid double-taps by disabling the callback briefly after a tap.
*   **Data Persistence:** Currently, Cart and Order History are kept in-memory for simplicity. They will reset when the app is fully closed. For production, these would be saved to `shared_preferences` or a local database (like SQLite/Hive) or fetched from a real API.

## Features

*   Product Catalogue with search and sorting.
*   Product Details with stock validation.
*   Cart with dynamic subtotal, discount, and delivery calculations.
*   Address selection.
*   Order summary and success screens.
*   Order history and detailed past orders.
