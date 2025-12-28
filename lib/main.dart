import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Класс TasksProvider, расширяющий ChangeNotifier
class TasksProvider extends ChangeNotifier {
  // Список задач
  List<String> tasks = [];

  // Метод для добавления задачи
  void addTask(String task) {
    tasks.add(task);
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  // Метод для удаления задачи
  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners(); // Уведомляем слушателей об изменении
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Оборачиваем MaterialApp в ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) => TasksProvider(),
      child: MaterialApp(
        title: 'Список задач с Provider',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем список задач через context.watch()
    // Это автоматически перестроит виджет при изменении списка
    final tasks = context.watch<TasksProvider>().tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Нет задач',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Нажмите + чтобы добавить',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(tasks[index]),
                    trailing: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    // Удаление при долгом нажатии
                    onLongPress: () {
                      // Используем context.read() для вызова метода без подписки
                      context.read<TasksProvider>().removeTask(index);
                      
                      // Показываем сообщение об удалении
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Задача "${tasks[index]}" удалена'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Используем context.read() для добавления задачи
          context.read<TasksProvider>().addTask('Новая задача ${tasks.length + 1}');
          
          // Показываем сообщение о добавлении
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Задача добавлена'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        tooltip: 'Добавить задачу',
        child: const Icon(Icons.add),
      ),
    );
  }
}
