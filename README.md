# Assignment2 - Employee Management System

This project is a Flutter-based Employee Management System developed by **Senthamizh Raj Thiruneelakandan**. 
It follows **clean architecture**, uses **Cubit for state management**, and includes a **customized calendar widget**.

## App Name
- **For better understanding, the app name has been set as "Senthamizh".**

## Hosted Web app
🎥 **Try the web version at:** https://d9lkusk6fmuu0.cloudfront.net/

## Features
1. **Splash Screen**
    - Loads the database within **2 seconds** delay.

2. **State Management**
    - Uses **Cubit** for managing app state efficiently.

3. **Employee Management**
    - Add, edit, and delete employees.
    - **Undo delete** within **3 seconds**.

4. **Calendar Integration**
    - **Custom-designed calendar widget**.
    - Top actions pre-selected for better user experience.
    - **To Date should always be greater than From Date** when updating employees.
    - **From Date is pre-selected when opening the calendar for the first time**.

5. **Automatic Employee Categorization**
    - Adding **To Date** moves the employee to the **Previous Employees** list.

## Edge Cases Handled
- **Form validation for name & title when adding an employee.**
- **Ensuring From Date is shown when opening the calendar.**
- **Preventing invalid date selection scenarios.**
- **To Date cannot be selected for a new employee**.
- **To Date should always be greater than From Date** when updating employees.

## App Name
- **For better understanding I made the app name hass been as senthamizh**

## Getting Started
1. **Clone the repository**
   ```sh
   git clone https://github.com/senthamizhrajt/riassignment2.git
2. **Download the project dependencies**
   ```sh
   flutter pub get
3. **Run the project**
   ```sh
   flutter run
