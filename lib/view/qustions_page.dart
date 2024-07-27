import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homework/main.dart';
import 'package:homework/view/form_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionsPage extends StatefulWidget {
  final int formId;
  const QuestionsPage({super.key, required this.formId});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late Future<List<Map<String, dynamic>>> questionsFuture;
  final Map<int, int?> selectedOptions = {};
  final Set<int> unansweredQuestions = {};

  @override
  void initState() {
    super.initState();
    questionsFuture = fetchQuestions();
  }

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await Supabase.instance.client
        .from('questions')
        .select()
        .eq('form_id', widget.formId);

    if (response.isEmpty) {
      throw Exception('Error fetching questions: No data found');
    }

    return List<Map<String, dynamic>>.from(response as List);
  }

  void onOptionSelected(int questionId, int? value) {
    setState(() {
      selectedOptions[questionId] = value;
      if (value != null) {
        unansweredQuestions.remove(questionId);
      }
    });
  }

  void checkUnansweredQuestions(List<Map<String, dynamic>> questions) {
    unansweredQuestions.clear();
    for (var question in questions) {
      if (selectedOptions[question['id']] == null) {
        unansweredQuestions.add(question['id']);
      }
    }
  }

  Future<void> submitAnswers() async {
    for (var entry in selectedOptions.entries) {
      await Supabase.instance.client
          .from('answers')
          .insert({
            'form_id': widget.formId,
            'question_id': entry.key,
            'selected_option': entry.value,
          })
          .select()
          .single();
    }
    showNotification();
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'تم إرسال الإجابات',
      'شكراً على وقتك',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions found'));
          } else {
            final questions = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final questionId = question['id'];
                      final options = [
                        question['choice_1'],
                        question['choice_2'],
                        question['choice_3'],
                        question['choice_4']
                      ];

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question['question'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ...options.asMap().entries.map((entry) {
                                final optionIndex = entry.key + 1;
                                final optionText = entry.value;

                                return RadioListTile<int>(
                                  title: Text(optionText),
                                  value: optionIndex,
                                  groupValue: selectedOptions[questionId],
                                  onChanged: (value) =>
                                      onOptionSelected(questionId, value),
                                );
                              }),
                              if (unansweredQuestions.contains(questionId))
                                const Text(
                                  'هذا السؤال مطلوب',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        checkUnansweredQuestions(questions);
                      });
                      if (unansweredQuestions.isEmpty) {
                        await submitAnswers();
                        Navigator.of(context).pop(
                          MaterialPageRoute(
                            builder: (context) => const FormPage(),
                          ),
                        );
                      }
                    },
                    child: const Text('أرسل الإجابات'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
