import 'package:flutter/material.dart';

// Social Proof Widget
class SocialProofWidget extends StatelessWidget {
  const SocialProofWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Trusted by Sales Professionals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('10K+', 'Active Users'),
                _buildStat('500+', 'Companies'),
                _buildStat('95%', 'Satisfaction'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '"This platform transformed our sales team\'s performance. Highly recommend!"',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '- Sarah Johnson, VP of Sales, TechCorp',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// ROI Calculator Widget
class ROICalculatorWidget extends StatefulWidget {
  const ROICalculatorWidget({super.key});

  @override
  State<ROICalculatorWidget> createState() => _ROICalculatorWidgetState();
}

class _ROICalculatorWidgetState extends State<ROICalculatorWidget> {
  int _salesReps = 10;
  double _avgDealSize = 50000;
  double _conversionImprovement = 15;

  @override
  Widget build(BuildContext context) {
    final currentRevenue = _salesReps * _avgDealSize * 12; // Annual
    final improvedRevenue = currentRevenue * (1 + _conversionImprovement / 100);
    final additionalRevenue = improvedRevenue - currentRevenue;
    final platformCost = (_salesReps * 100 * 12).toDouble(); // $100/user/month
    final roi = ((additionalRevenue - platformCost) / platformCost * 100);
    final paybackMonths = (platformCost / (additionalRevenue / 12));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ROI Calculator',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSlider(
              'Number of Sales Reps',
              _salesReps.toDouble(),
              1,
              100,
              (v) => setState(() => _salesReps = v.toInt()),
            ),
            _buildSlider(
              'Average Deal Size (\$)',
              _avgDealSize,
              10000,
              200000,
              (v) => setState(() => _avgDealSize = v),
            ),
            _buildSlider(
              'Conversion Improvement (%)',
              _conversionImprovement,
              5,
              50,
              (v) => setState(() => _conversionImprovement = v),
            ),
            const Divider(),
            const SizedBox(height: 16),
            _buildResultRow('Current Annual Revenue', '\$${_formatNumber(currentRevenue)}', Colors.grey),
            _buildResultRow('Improved Annual Revenue', '\$${_formatNumber(improvedRevenue)}', Colors.green),
            _buildResultRow('Additional Revenue', '\$${_formatNumber(additionalRevenue)}', Colors.blue),
            _buildResultRow('Platform Cost/Year', '\$${_formatNumber(platformCost)}', Colors.orange),
            const Divider(),
            _buildResultRow('ROI', '${roi.toStringAsFixed(0)}%', Colors.purple, isBold: true),
            _buildResultRow('Payback Period', '${paybackMonths.toStringAsFixed(1)} months', Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                value.toStringAsFixed(label.contains('\$') ? 0 : 0),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min > 50) ? 50 : (max - min).toInt(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double num) {
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(0)}K';
    }
    return num.toStringAsFixed(0);
  }
}

// Feature Comparison Widget
class FeatureComparisonWidget extends StatelessWidget {
  const FeatureComparisonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Comparison',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildComparisonTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable(BuildContext context) {
    final features = [
      ['AI Avatar Coaching', true, true, false],
      ['Interactive Scenarios', true, false, false],
      ['Real-time Feedback', true, true, true],
      ['Progress Analytics', true, true, false],
      ['Branching Paths', true, false, false],
      ['Video Recording', true, true, true],
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            _buildTableCell('Feature', isHeader: true),
            _buildTableCell('DaleAvatar', isHeader: true),
            _buildTableCell('Competitor A', isHeader: true),
            _buildTableCell('Competitor B', isHeader: true),
          ],
        ),
        ...features.map((feature) {
          return TableRow(
            children: [
              _buildTableCell(feature[0] as String),
              _buildCheckCell(feature[1] as bool),
              _buildCheckCell(feature[2] as bool),
              _buildCheckCell(feature[3] as bool),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCheckCell(bool hasFeature) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Icon(
          hasFeature ? Icons.check_circle : Icons.cancel,
          color: hasFeature ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}

// Trust Indicators Widget
class TrustIndicatorsWidget extends StatelessWidget {
  const TrustIndicatorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Enterprise-Grade Security & Compliance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildBadge(Icons.security, 'SOC 2 Compliant', Colors.green),
                _buildBadge(Icons.verified_user, 'GDPR Compliant', Colors.blue),
                _buildBadge(Icons.lock, 'End-to-End Encryption', Colors.purple),
                _buildBadge(Icons.cloud_done, 'AWS Infrastructure', Colors.orange),
                _buildBadge(Icons.assignment_turned_in, 'HIPAA Ready', Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Free Trial CTA Widget
class FreeTrialCTAWidget extends StatelessWidget {
  const FreeTrialCTAWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.stars, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Start Your Free Trial',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No credit card required • 14-day free trial • Cancel anytime',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to sign up
                  },
                  icon: const Icon(Icons.rocket_launch),
                  label: const Text('Start Free Trial'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // Schedule demo
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Schedule Demo'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              alignment: WrapAlignment.center,
              children: const [
                _FeatureCheck('✓ Full access to all features'),
                _FeatureCheck('✓ AI avatar coaching'),
                _FeatureCheck('✓ Progress analytics'),
                _FeatureCheck('✓ Email support'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCheck extends StatelessWidget {
  final String text;
  const _FeatureCheck(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[700],
        fontSize: 12,
      ),
    );
  }
}

// Pricing Widget
class PricingWidget extends StatelessWidget {
  const PricingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Simple, Transparent Pricing',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildPricingCard('Starter', 99, 5, false)),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPricingCard('Professional', 199, 20, true),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildPricingCard('Enterprise', 499, 100, false, isEnterprise: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingCard(String name, int price, int users, bool isPopular, {bool isEnterprise = false}) {
    return Card(
      elevation: isPopular ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPopular ? BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$price',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('/month'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Up to $users users'),
            const SizedBox(height: 16),
            const _PricingFeature('AI Avatar Coaching'),
            const _PricingFeature('Interactive Scenarios'),
            const _PricingFeature('Progress Analytics'),
            const _PricingFeature('Email Support'),
            if (isEnterprise) ...[
              const _PricingFeature('Priority Support'),
              const _PricingFeature('Custom Integrations'),
              const _PricingFeature('Dedicated Account Manager'),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(isEnterprise ? 'Contact Sales' : 'Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingFeature extends StatelessWidget {
  final String text;
  const _PricingFeature(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

