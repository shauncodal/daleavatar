import 'package:flutter/material.dart';
import '../widgets/sales_enhancements.dart';

class SalesDemoScreen extends StatefulWidget {
  const SalesDemoScreen({super.key});

  @override
  State<SalesDemoScreen> createState() => _SalesDemoScreenState();
}

class _SalesDemoScreenState extends State<SalesDemoScreen> {
  int _currentStep = 0;
  int _score = 0;
  final List<DemoChoice> _choices = [];
  bool _showAnalytics = false;

  final List<DemoScenarioStep> _scenarioSteps = [
    DemoScenarioStep(
      step: 0,
      title: 'Cold Call Scenario',
      description: 'You\'re calling a potential client who hasn\'t responded to your emails. This is your first attempt to reach them directly.',
      choices: [
        DemoChoice(
          text: 'Open with your company name and ask for their time',
          feedback: 'Good professional opening. Sets clear expectation.',
          score: 3,
        ),
        DemoChoice(
          text: 'Immediately jump into your pitch',
          feedback: 'Too aggressive. You haven\'t earned their attention yet.',
          score: 1,
        ),
        DemoChoice(
          text: 'Ask "Is this a good time?" first',
          feedback: 'Respectful approach. Shows consideration for their schedule.',
          score: 5,
        ),
      ],
    ),
    DemoScenarioStep(
      step: 1,
      title: 'The Objection',
      description: 'The prospect says: "I\'m not interested. We already have a solution."',
      choices: [
        DemoChoice(
          text: 'Accept and end the call',
          feedback: 'Missed opportunity. Objections are often buying signals in disguise.',
          score: 1,
        ),
        DemoChoice(
          text: 'Challenge them: "Are you sure? Our solution is better."',
          feedback: 'Too confrontational. This will likely end the conversation.',
          score: 2,
        ),
        DemoChoice(
          text: 'Ask: "What solution are you using? I\'d love to understand your current setup."',
          feedback: 'Excellent! Discovery questions help you understand needs and find gaps.',
          score: 5,
        ),
      ],
    ),
    DemoScenarioStep(
      step: 2,
      title: 'Building Interest',
      description: 'They mention they\'re having issues with their current system. You have their attention.',
      choices: [
        DemoChoice(
          text: 'Immediately start listing all your features',
          feedback: 'Feature dumping. Focus on benefits that solve their specific problems.',
          score: 2,
        ),
        DemoChoice(
          text: 'Ask more questions about their specific pain points',
          feedback: 'Great discovery approach. Understanding problems before offering solutions.',
          score: 5,
        ),
        DemoChoice(
          text: 'Offer a discount to switch',
          feedback: 'Price-cutting too early. Build value first, then discuss pricing.',
          score: 3,
        ),
      ],
    ),
  ];

  void _makeChoice(DemoChoice choice) {
    setState(() {
      _choices.add(choice);
      _score += choice.score;
      if (_currentStep < _scenarioSteps.length - 1) {
        _currentStep++;
      } else {
        _showAnalytics = true;
      }
    });

    // Show feedback
    _showFeedback(choice);
  }

  void _showFeedback(DemoChoice choice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  choice.score >= 4 ? Icons.check_circle : Icons.info,
                  color: choice.score >= 4 ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Score: +${choice.score}/5',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(choice.feedback),
          ],
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: choice.score >= 4 ? Colors.green.shade700 : Colors.orange.shade700,
      ),
    );
  }

  void _resetDemo() {
    setState(() {
      _currentStep = 0;
      _score = 0;
      _choices.clear();
      _showAnalytics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showAnalytics) {
      return _buildAnalyticsView();
    }

    final currentScenario = _scenarioSteps[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => setState(() => _showAnalytics = true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of ${_scenarioSteps.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Score: $_score/${_scenarioSteps.length * 5}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / _scenarioSteps.length,
                  minHeight: 6,
                ),
              ],
            ),
          ),

          // Scenario content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scenario title and description
                  Text(
                    currentScenario.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentScenario.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Choices
                  Text(
                    'What would you do?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...currentScenario.choices.asMap().entries.map((entry) {
                    final index = entry.key;
                    final choice = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ChoiceCard(
                        choice: choice,
                        index: index,
                        onTap: () => _makeChoice(choice),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView() {
    final maxScore = _scenarioSteps.length * 5;
    final percentage = (_score / maxScore * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetDemo,
            tooltip: 'Start New Demo',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Performance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Overall Performance',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '$_score / $maxScore',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      '$percentage% Score',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Choice Breakdown
            Text(
              'Your Choices',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._choices.asMap().entries.map((entry) {
              final index = entry.key;
              final choice = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: choice.score >= 4
                        ? Colors.green
                        : choice.score >= 3
                            ? Colors.orange
                            : Colors.red,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(choice.text),
                  subtitle: Text(choice.feedback),
                  trailing: Text(
                    '+${choice.score}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: choice.score >= 4
                          ? Colors.green
                          : choice.score >= 3
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Common Choices (mock data)
            Text(
              'Most Common Choices',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildChoiceFrequency('Ask "Is this a good time?" first', 0.42, Colors.green),
                    const SizedBox(height: 12),
                    _buildChoiceFrequency('Open with company name', 0.35, Colors.blue),
                    const SizedBox(height: 12),
                    _buildChoiceFrequency('Ask discovery questions', 0.28, Colors.orange),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Key Insights
            Text(
              'Key Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightCard(
              Icons.thumb_up,
              Colors.green,
              'Strengths',
              'You excel at discovery questions and building rapport.',
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              Icons.trending_up,
              Colors.blue,
              'Improvement Areas',
              'Focus on handling objections more proactively.',
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              Icons.lightbulb,
              Colors.orange,
              'Recommendation',
              'Practice more cold call scenarios to improve your opening.',
            ),

            const SizedBox(height: 32),

            // Sales Enhancements Section
            const Divider(),
            const SizedBox(height: 32),
            const SocialProofWidget(),
            const SizedBox(height: 24),
            const ROICalculatorWidget(),
            const SizedBox(height: 24),
            const FeatureComparisonWidget(),
            const SizedBox(height: 24),
            const TrustIndicatorsWidget(),
            const SizedBox(height: 24),
            const FreeTrialCTAWidget(),
            const SizedBox(height: 24),
            const PricingWidget(),
            const SizedBox(height: 32),

            // CTA Buttons
            ElevatedButton.icon(
              onPressed: _resetDemo,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Another Scenario'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Dashboard'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceFrequency(String choice, double percentage, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            choice,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              LinearProgressIndicator(
                value: percentage,
                minHeight: 20,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard(IconData icon, Color color, String title, String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  final DemoChoice choice;
  final int index;
  final VoidCallback onTap;

  const ChoiceCard({
    super.key,
    required this.choice,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  choice.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoScenarioStep {
  final int step;
  final String title;
  final String description;
  final List<DemoChoice> choices;

  DemoScenarioStep({
    required this.step,
    required this.title,
    required this.description,
    required this.choices,
  });
}

class DemoChoice {
  final String text;
  final String feedback;
  final int score;

  DemoChoice({
    required this.text,
    required this.feedback,
    required this.score,
  });
}

