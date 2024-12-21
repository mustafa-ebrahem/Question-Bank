import 'package:flutter/material.dart';

void main() {
  runApp(QuestionBankApp());
}

class QuestionBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Question Bank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/teacherDashboard': (context) => TeacherDashboardPage(),
        '/addQuestions': (context) => AddQuestionsPage(),
        '/studentDashboard': (context) => StudentDashboardPage(),
        '/quiz': (context) => QuizPage(),
        '/quizResult': (context) => QuizResultPage(),
      },
    );
  }
}

// Landing Page
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Question Bank')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Choose your role:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Login as Teacher'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Login as Student'),
            ),
          ],
        ),
      ),
    );
  }
}

// Login Page
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/teacherDashboard');
              },
              child: Text('Login as Teacher'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/studentDashboard');
              },
              child: Text('Login as Student'),
            ),
          ],
        ),
      ),
    );
  }
}

// Teacher Dashboard Page
class TeacherDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addQuestions');
              },
              child: Text('Add Questions'),
            ),
            ElevatedButton(
              onPressed: () {
                // Placeholder for future feature
              },
              child: Text('Manage Questions'),
            ),
          ],
        ),
      ),
    );
  }
}

// Add Questions Page
class AddQuestionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Questions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Option A'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Option B'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Option C'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Option D'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Correct Answer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for saving question
              },
              child: Text('Save Question'),
            ),
          ],
        ),
      ),
    );
  }
}

// Student Dashboard Page
class StudentDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/quiz');
              },
              child: Text('Take a Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                // Placeholder for progress tracking
              },
              child: Text('View Progress'),
            ),
          ],
        ),
      ),
    );
  }
}

// Quiz Page
class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz')),
      body: Center(
        child: Text('Quiz functionality will go here.'),
      ),
    );
  }
}

// Quiz Result Page
class QuizResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Result')),
      body: Center(
        child: Text('Quiz results will be displayed here.'),
      ),
    );
  }
}
