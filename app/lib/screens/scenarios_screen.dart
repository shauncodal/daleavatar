import 'package:flutter/material.dart';
import 'session_live.dart';
import '../services/backend_api.dart';

class ScenariosScreen extends StatefulWidget {
  final BackendApi api;
  final bool showAppBar;
  const ScenariosScreen({super.key, required this.api, this.showAppBar = true});

  @override
  State<ScenariosScreen> createState() => _ScenariosScreenState();
}

class _ScenariosScreenState extends State<ScenariosScreen> {

  final List<SalesScenario> _scenarios = [
    SalesScenario(
      id: 'cold-call',
      title: 'Cold Call',
      description: 'Practice making cold calls to potential clients. Learn to handle objections and build rapport quickly.',
      avatarImage: '👔',
      difficulty: 'Hard',
      color: Colors.blue,
      tips: [
        'Start with a strong value proposition',
        'Handle objections confidently',
        'Set clear next steps',
      ],
    ),
    SalesScenario(
      id: 'product-demo',
      title: 'Product Demo',
      description: 'Demonstrate your product features and benefits. Practice explaining technical details clearly.',
      avatarImage: '📊',
      difficulty: 'Medium',
      color: Colors.green,
      tips: [
        'Focus on customer benefits, not features',
        'Ask discovery questions',
        'Address concerns proactively',
      ],
    ),
    SalesScenario(
      id: 'price-negotiation',
      title: 'Price Negotiation',
      description: 'Navigate price discussions and objections. Learn to maintain value while being flexible.',
      avatarImage: '💰',
      difficulty: 'Hard',
      color: Colors.orange,
      tips: [
        'Emphasize ROI and value',
        'Bundle solutions creatively',
        'Know your walk-away point',
      ],
    ),
    SalesScenario(
      id: 'closing-deal',
      title: 'Closing the Deal',
      description: 'Practice closing techniques and handling final objections. Get comfortable asking for the sale.',
      avatarImage: '✅',
      difficulty: 'Medium',
      color: Colors.purple,
      tips: [
        'Use assumptive language',
        'Create urgency when appropriate',
        'Offer multiple closing options',
      ],
    ),
    SalesScenario(
      id: 'follow-up',
      title: 'Follow-Up Call',
      description: 'Re-engage with leads who showed interest. Practice rekindling conversations and moving deals forward.',
      avatarImage: '📞',
      difficulty: 'Easy',
      color: Colors.teal,
      tips: [
        'Reference previous conversation',
        'Bring new value or information',
        'Make it easy to say yes',
      ],
    ),
    SalesScenario(
      id: 'objection-handling',
      title: 'Objection Handling',
      description: 'Master common objections like budget, timing, and authority. Learn to turn objections into opportunities.',
      avatarImage: '🛡️',
      difficulty: 'Hard',
      color: Colors.red,
      tips: [
        'Listen fully before responding',
        'Acknowledge the concern',
        'Provide evidence and alternatives',
      ],
    ),
  ];


  Future<void> _enrollInScenario(SalesScenario scenario) async {
    try {
      // For now, we'll use mock course IDs based on scenario ID
      // In production, we'd look up the course by scenario_id
      final courseId = _getCourseIdFromScenario(scenario.id);
      
      // Try to enroll
      try {
        await widget.api.enrollInCourse(courseId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Enrolled in ${scenario.title}!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // If enrollment fails, just navigate to session (demo mode)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Starting ${scenario.title}...'),
            ),
          );
        }
      }
      
      // Navigate to session
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SessionLiveScreen(api: widget.api),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int _getCourseIdFromScenario(String scenarioId) {
    // Map scenario IDs to course IDs (for demo, using 1-6)
    final mapping = {
      'cold-call': 1,
      'product-demo': 2,
      'price-negotiation': 3,
      'closing-deal': 4,
      'follow-up': 5,
      'objection-handling': 6,
    };
    return mapping[scenarioId] ?? 1;
  }

  void _startScenario(SalesScenario scenario) {
    _enrollInScenario(scenario);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Practice Your Sales Skills',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose a scenario to practice with our AI avatar coach',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _scenarios.length,
                  itemBuilder: (context, index) {
                    final scenario = _scenarios[index];
                    return _buildScenarioCard(context, scenario);
                  },
                ),
              ),
            ],
          );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sales Scenarios'),
        ),
        body: content,
      );
    }
    
    return content;
  }

  Widget _buildScenarioCard(BuildContext context, SalesScenario scenario) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _startScenario(scenario),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scenario.color.withOpacity(0.1),
                scenario.color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar/Icon with gradient background
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scenario.color.withOpacity(0.3),
                      scenario.color.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: scenario.color.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    scenario.avatarImage,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const Spacer(),
              // Title
              Text(
                scenario.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(scenario.difficulty).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  scenario.difficulty,
                  style: TextStyle(
                    color: _getDifficultyColor(scenario.difficulty),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Expanded(
                child: Text(
                  scenario.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              // Tips count
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${scenario.tips.length} tips',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 16, color: scenario.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class SalesScenario {
  final String id;
  final String title;
  final String description;
  final String avatarImage;
  final String difficulty;
  final Color color;
  final List<String> tips;

  SalesScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.avatarImage,
    required this.difficulty,
    required this.color,
    required this.tips,
  });
}

