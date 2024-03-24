import 'package:expense_tacker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tacker/widget/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expensesList,
    required this.onRemove,
  });

  final List<Expense> expensesList;
  final void Function(Expense expense) onRemove;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expensesList.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(.60),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        key: ValueKey(expensesList[index]),
        onDismissed: (direction) {
          onRemove(expensesList[index]);
        },
        child: ExpenseItem(expense: expensesList[index]),
      ),
    );
  }
}
