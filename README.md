# Expense Tracker App

Expense Tracker is a simple application built with Flutter to help you keep track of your expenses. With this app, you can easily add, remove, and visualize your expenses to manage your budget effectively.

## Features

- Add new expenses with title, amount, date, and category.
- Remove expenses with undo option.
- View expenses in a list format.
- Visualize expenses using charts.

## Getting Started

To use this application, follow these steps:

1. Clone this repository to your local machine.
2. Ensure you have Flutter installed. If not, follow the [installation instructions](https://flutter.dev/docs/get-started/install).
3. Open the project in your preferred IDE.
4. Run the app on an emulator or physical device.

## Usage

### Adding Expenses

To add a new expense:

1. Tap on the '+' button in the app bar.
2. Fill in the required details including title, amount, date, and category.
3. Tap on the 'Add' button.

### Removing Expenses

To remove an expense:

1. Tap and hold on the expense you want to remove from the expenses list.
2. Confirm the removal by tapping 'Remove'.

### Undo Removal

If you accidentally remove an expense, you can undo the removal by tapping 'Undo' on the snackbar that appears after removal.

## Data Persistence

Expense data is stored locally on your device in a text file named `expenses.txt`. This file is located in the application directory.


## Dependencies

This project uses the following dependencies:

- `flutter/material.dart`
- `dart:io`
- `path.dart`


