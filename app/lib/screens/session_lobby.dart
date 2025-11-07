import 'package:flutter/material.dart';
import '../models/avatar_settings.dart';
import '../services/settings_service.dart';

class SessionLobbyScreen extends StatefulWidget {
  const SessionLobbyScreen({super.key});

  @override
  State<SessionLobbyScreen> createState() => _SessionLobbyScreenState();
}

class _SessionLobbyScreenState extends State<SessionLobbyScreen> {
  late AvatarSettings _settings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await SettingsService.instance.load();
    setState(() {
      _settings = SettingsService.instance.settings;
      _loading = false;
    });
  }

  Future<void> _saveSettings() async {
    await SettingsService.instance.update(_settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFBEF264)));
    }

    // Design colors
    const textPrimary = Color(0xFFE8EAEF);
    const textSecondary = Color(0xFFA1A7B8);
    const lime300 = Color(0xFFBEF264);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Avatar Name
          _buildSection(
            context,
            'Avatar',
            [
              _buildTextField(
                context,
                label: 'Avatar Name/ID',
                hint: 'Elenora_IT_Sitting_public',
                value: _settings.avatarName,
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(avatarName: v));
                  _saveSettings();
                },
                helpText: 'Interactive Avatar ID from labs.heygen.com',
              ),
              const SizedBox(height: 16),
              _buildDropdown<AvatarQuality>(
                context,
                label: 'Quality',
                value: _settings.quality,
                items: AvatarQuality.values,
                getLabel: (q) => q.name.toUpperCase(),
                getDescription: (q) {
                  switch (q) {
                    case AvatarQuality.low:
                      return '500kbps, 360p - Faster connection';
                    case AvatarQuality.medium:
                      return '1000kbps, 480p - Balanced';
                    case AvatarQuality.high:
                      return '2000kbps, 720p - Best quality';
                  }
                },
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(quality: v));
                  _saveSettings();
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Voice Settings
          _buildSection(
            context,
            'Voice Settings',
            [
              _buildTextField(
                context,
                label: 'Voice ID (Optional)',
                hint: 'Leave empty for avatar default',
                value: _settings.voiceId ?? '',
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(
                    voiceId: v.isEmpty ? null : v,
                  ));
                  _saveSettings();
                },
                helpText: 'Custom voice ID from HeyGen',
              ),
              const SizedBox(height: 16),
              _buildSlider(
                context,
                label: 'Voice Rate',
                value: _settings.voiceRate,
                min: 0.5,
                max: 1.5,
                divisions: 20,
                formatValue: (v) => v.toStringAsFixed(1),
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(voiceRate: v));
                  _saveSettings();
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown<VoiceEmotion?>(
                context,
                label: 'Voice Emotion (Optional)',
                value: _settings.voiceEmotion,
                items: [null, ...VoiceEmotion.values],
                getLabel: (e) => e?.name.toUpperCase() ?? 'Default',
                getDescription: (e) => e?.name ?? 'Use default emotion',
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(voiceEmotion: v));
                  _saveSettings();
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Knowledge Base
          _buildSection(
            context,
            'Knowledge Base',
            [
              _buildTextField(
                context,
                label: 'Knowledge ID (Optional)',
                hint: 'Enter knowledge base ID',
                value: _settings.knowledgeId ?? '',
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(
                    knowledgeId: v.isEmpty ? null : v,
                  ));
                  _saveSettings();
                },
                helpText: 'Get from labs.heygen.com/knowledge-base',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                context,
                label: 'Custom System Prompt (Optional)',
                hint: 'Enter custom prompt for LLM',
                value: _settings.knowledgeBase ?? '',
                maxLines: 4,
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(
                    knowledgeBase: v.isEmpty ? null : v,
                  ));
                  _saveSettings();
                },
                helpText: 'Custom system prompt for GPT-4o mini',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // STT Settings
          _buildSection(
            context,
            'Speech-to-Text',
            [
              _buildDropdown<STTProvider>(
                context,
                label: 'STT Provider',
                value: _settings.sttProvider,
                items: STTProvider.values,
                getLabel: (p) => p.name.toUpperCase(),
                getDescription: (p) => 'Speech recognition provider',
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(sttProvider: v));
                  _saveSettings();
                },
              ),
              const SizedBox(height: 16),
              _buildSlider(
                context,
                label: 'Confidence Threshold',
                value: _settings.sttConfidence,
                min: 0.0,
                max: 1.0,
                divisions: 20,
                formatValue: (v) => v.toStringAsFixed(2),
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(sttConfidence: v));
                  _saveSettings();
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Language & Session Settings
          _buildSection(
            context,
            'Session Settings',
            [
              _buildTextField(
                context,
                label: 'Language Code',
                hint: 'en, ja, es, etc.',
                value: _settings.language,
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(language: v));
                  _saveSettings();
                },
                helpText: 'Basic language codes only (e.g., en, not en-US)',
              ),
              const SizedBox(height: 16),
              _buildSlider(
                context,
                label: 'Idle Timeout (seconds)',
                value: _settings.activityIdleTimeout.toDouble(),
                min: 30,
                max: 3600,
                divisions: 119,
                formatValue: (v) => '${v.toInt()}s',
                onChanged: (v) {
                  setState(() => _settings = _settings.copyWith(
                    activityIdleTimeout: v.toInt(),
                  ));
                  _saveSettings();
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Use Silence Prompt',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFE8EAEF),
                            letterSpacing: -0.1504,
                            height: 1.0, // 14px / 14px
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Enable automatic conversational prompts during silence',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFA1A7B8),
                            letterSpacing: -0.1504,
                            height: 1.43, // 20px / 14px
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Switch(
                    value: _settings.useSilencePrompt,
                    onChanged: (v) {
                      setState(() => _settings = _settings.copyWith(useSilencePrompt: v));
                      _saveSettings();
                    },
                    activeColor: const Color(0xFFBEF264),
                    inactiveThumbColor: const Color(0xFFE8EAEF),
                    inactiveTrackColor: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),

          const SizedBox(height: 32),

          // Settings Reference Card
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: lime300.withOpacity(0.05),
              border: Border.all(
                color: lime300.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: textPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings Reference',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textPrimary,
                          letterSpacing: -0.1504,
                          height: 1.43, // 20px / 14px
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'These settings are based on the HeyGen Streaming Avatar SDK. Settings are automatically saved and will be used when you start a session.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                          letterSpacing: -0.1504,
                          height: 1.43, // 20px / 14px
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          // Could open documentation link
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'View SDK Documentation',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: lime300,
                                letterSpacing: -0.1504,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: lime300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    const backgroundColor = Color(0xFF0A0E14); // cardBackground
    const cardBorder = Color(0xFF1A2E23);
    const textPrimary = Color(0xFFE8EAEF);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: cardBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
      padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textPrimary,
                letterSpacing: -0.3125,
                height: 1.5, // 24px / 16px
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
    String? helpText,
    int maxLines = 1,
  }) {
    const textSecondary = Color(0xFFA1A7B8);
    const textPrimary = Color(0xFFE8EAEF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textPrimary,
              letterSpacing: -0.1504,
              height: 1.0, // 14px / 14px
            ),
          ),
        ),
        Container(
          height: maxLines > 1 ? null : 36,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
              width: 0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textPrimary,
              letterSpacing: -0.1504,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textSecondary,
                letterSpacing: -0.1504,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: maxLines > 1 ? 8 : 4),
              border: InputBorder.none,
              filled: false,
            ),
            maxLines: maxLines,
            controller: TextEditingController(text: value)
              ..selection = TextSelection.collapsed(offset: value.length),
            onChanged: onChanged,
          ),
        ),
        if (helpText != null) ...[
          const SizedBox(height: 8),
          Text(
            helpText,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: textSecondary,
              letterSpacing: 0,
              height: 1.33, // 16px / 12px
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDropdown<T>(
    BuildContext context, {
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) getLabel,
    String? Function(T)? getDescription,
    required ValueChanged<T> onChanged,
  }) {
    const textSecondary = Color(0xFFA1A7B8);
    const textPrimary = Color(0xFFE8EAEF);

    final selectedDescription = getDescription?.call(value);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textPrimary,
              letterSpacing: -0.1504,
              height: 1.0, // 14px / 14px
            ),
          ),
        ),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.transparent,
              width: 0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<T>(
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textPrimary,
              letterSpacing: -0.1504,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 1),
              border: InputBorder.none,
              filled: false,
            ),
            dropdownColor: const Color(0xFF0A0E14), // cardBackground
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: textPrimary,
            ),
            isDense: true,
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  getLabel(item),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textPrimary,
                    letterSpacing: -0.1504,
                  ),
                ),
              );
            }).toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ),
        if (selectedDescription != null) ...[
          const SizedBox(height: 8),
          Text(
            selectedDescription,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: textSecondary,
              letterSpacing: 0,
              height: 1.33, // 16px / 12px
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) formatValue,
    required ValueChanged<double> onChanged,
  }) {
    const textPrimary = Color(0xFFE8EAEF);
    const lime300 = Color(0xFFBEF264);
    const sliderBg = Color(0xFF141820);

    // Calculate slider position percentage
    final percentage = (value - min) / (max - min);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimary,
                letterSpacing: -0.1504,
                height: 1.43, // 20px / 14px
              ),
            ),
            Text(
              formatValue(value),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textPrimary,
                letterSpacing: -0.1504,
                height: 1.43, // 20px / 14px
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final thumbPosition = percentage * (trackWidth - 16);
            
            return SizedBox(
              height: 16,
              child: Stack(
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: sliderBg,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: (1 - percentage) * trackWidth,
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: lime300,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                  Positioned(
                    left: thumbPosition,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: lime300,
                          width: 1,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 16,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      divisions: divisions,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
