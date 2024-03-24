import 'dart:io';

import 'package:expense_tacker/widget/chart/chart.dart';
import 'package:expense_tacker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tacker/widget/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tacker/model/expense.dart';
import 'package:path/path.dart' as path;

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _regersteredExpense = [];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: ((cxt) => NewExpense(
            onAddExpense: _addExpense,
          )),
    );
  }

  Future<File> _getLocalFile() async {
    final directory = Directory.current;
    final filePath = path.join(directory.path, 'expenses.txt');
    return File(filePath);
  }

  Future<void> _loadExpenses() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final lines = await file.readAsLines();
      for (var line in lines) {
        final parts = line.split(',');
        final title = parts[0];
        final amount = double.parse(parts[1]);
        final date = DateTime.parse(parts[2]);
         final category = Category.values.firstWhere((e) => e.toString() == 'Category.$parts[3]');
        final expense = Expense(
            title: title, amount: amount, date: date, category: category);
        _regersteredExpense.add(expense);
      }
    }
  }

  Future<File> _saveExpensesToFile() async {
    final file = await _getLocalFile();
    final text = _regersteredExpense
        .map((expense) =>
            '${expense.title},${expense.amount},${expense.date},${expense.category}')
        .join('\n');
    return file.writeAsString(text);
  }

  void _addExpense(Expense expense) {
    setState(() {
      _regersteredExpense.add(expense);
    });
    _saveExpensesToFile();
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _regersteredExpense.indexOf(expense);
    setState(() {
      _regersteredExpense.remove(expense);
    });
    _saveExpensesToFile();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _regersteredExpense.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(width);
    // print(MediaQuery.of(context).size.height);
    Widget mainContent = const Center(
      child: Text('No Expenses Found, please add some'),
    );
    if (_regersteredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expensesList: _regersteredExpense,
        onRemove: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _regersteredExpense),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _regersteredExpense,
                  ),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
