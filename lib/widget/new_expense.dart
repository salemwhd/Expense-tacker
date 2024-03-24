import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tacker/model/expense.dart';
import 'package:path/path.dart' as path;

class NewExpense extends StatefulWidget {
  const NewExpense({required this.onAddExpense, super.key});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  Expense? expense;
  void _presntDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(2002);
    final lastDate = DateTime(2025);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDilog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (cxt) => CupertinoAlertDialog(
          title: const Text('invalid input'),
          content: const Text('Please fill all fields'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(cxt);
              },
              child: const Text('oK'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (cxt) => AlertDialog(
          title: const Text('invalid input'),
          content: const Text('Please fill all fields'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(cxt);
              },
              child: const Text('oK'),
            )
          ],
        ),
      );
    }
  }

  void _submitExpeneseData() async {
    final _enteredAmount = double.tryParse(_amountController.text);
    final isInValidAmount = _enteredAmount == null || _enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        isInValidAmount ||
        _selectedDate == null) {
      _showDilog();
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: _enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    widget.onAddExpense(expense!);
    await _saveExpenseToFile(expense!);
    Navigator.pop(context);
  }

  Future<File> _getLocalFile() async {
    final directory = Directory.current;
    final filePath = path.join(directory.path, 'expenses.txt');
    return File(filePath);
  }

  Future<File> _saveExpenseToFile(Expense expense) async {
    final file = await _getLocalFile();
    final text =
        '${expense.title},${expense.amount},${expense.date},${expense.category}\n';
    return file.writeAsString(text, mode: FileMode.append);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (cxt, constarints) {
      final width = constarints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            label: Text(
                              'Title',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          maxLength: 50,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text(
                              'Amount',
                            ),
                            prefixText: '\$ ',
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      label: Text(
                        'Title',
                      ),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        // icon: const Icon(Icons.category),
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No date selected'
                                : formatter.format(_selectedDate!).toString()),
                            IconButton(
                              onPressed: _presntDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          maxLength: 50,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text(
                              'Amount',
                            ),
                            prefixText: '\$ ',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null
                                ? 'No date selected'
                                : formatter.format(_selectedDate!).toString()),
                            IconButton(
                              onPressed: _presntDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpeneseData,
                        child: const Text('Save Expenese'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        // icon: const Icon(Icons.category),
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpeneseData,
                        child: const Text('Save Expenese'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
