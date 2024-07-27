import 'package:flutter/material.dart';
import 'package:homework/view/qustions_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: (const Icon(Icons.logout_outlined)),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('forms').select('*').asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final forms = snapshot.data!;
            if (forms.isEmpty) {
              return const Center(child: Text('No forms available.'));
            }
            return ListView.builder(
              itemCount: forms.length,
              itemBuilder: (context, index) {
                final form = forms[index];
                return ListTile(
                  title: Text(form['title']),
                  subtitle: Text(form['description']),
                  onTap: () => navigateToQuestions(context, form['id']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }

  void navigateToQuestions(BuildContext context, int formId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionsPage(formId: formId),
      ),
    );
  }
}
