// INLINED keyboard_safe.dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class KeyboardSafe extends StatefulWidget {
  final Widget child;
  final Widget? footer;
  final bool scroll;
  final bool autoScrollToFocused;
  final bool dismissOnTapOutside;
  final bool safeArea;
  final bool persistFooter;
  final EdgeInsets padding;
  final bool reverse;
  final Duration keyboardAnimationDuration;
  final void Function(bool visible, double height)? onKeyboardChanged;
  final Curve keyboardAnimationCurve;

  const KeyboardSafe({
    super.key,
    required this.child,
    this.footer,
    this.scroll = false,
    this.autoScrollToFocused = true,
    this.dismissOnTapOutside = false,
    this.safeArea = false,
    this.persistFooter = false,
    this.padding = EdgeInsets.zero,
    this.reverse = false,
    this.keyboardAnimationDuration = const Duration(milliseconds: 250),
    this.onKeyboardChanged,
    this.keyboardAnimationCurve = Curves.easeOut,
  });

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  State<KeyboardSafe> createState() => _KeyboardSafeState();
}

class _KeyboardSafeState extends State<KeyboardSafe>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  double _lastKeyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.autoScrollToFocused) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusManager.instance.addListener(_handleFocusChange);
      });
    }
  }

  @override
  void dispose() {
    if (widget.autoScrollToFocused) {
      FocusManager.instance.removeListener(_handleFocusChange);
    }
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final keyboardVisible = keyboardHeight > 0.0;

    if (_lastKeyboardHeight != keyboardHeight) {
      _lastKeyboardHeight = keyboardHeight;
      widget.onKeyboardChanged?.call(keyboardVisible, keyboardHeight);
      setState(() {});
    }
  }

  void _handleFocusChange() {
    final focused = FocusManager.instance.primaryFocus;
    if (focused?.context != null) {
      Scrollable.ensureVisible(
        focused!.context!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 0.2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    Widget content = AnimatedPadding(
      duration: widget.keyboardAnimationDuration,
      curve: widget.keyboardAnimationCurve,
      padding: widget.padding.copyWith(
        bottom: widget.footer != null && !widget.persistFooter
            ? 16.0
            : keyboardHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.child,
          if (widget.footer != null) ...[
            const SizedBox(height: 16),
            widget.footer!,
          ],
        ],
      ),
    );

    if (widget.scroll) {
      content = SingleChildScrollView(
        controller: _scrollController,
        reverse: widget.reverse,
        padding: EdgeInsets.only(
            bottom: widget.persistFooter ? 0.0 : keyboardHeight),
        physics: const BouncingScrollPhysics(),
        child: content,
      );
    }

    if (widget.safeArea) {
      content = SafeArea(child: content);
    }

    if (widget.dismissOnTapOutside) {
      content = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => KeyboardSafe.dismissKeyboard(context),
        child: content,
      );
    }

    return AnimatedContainer(
      duration: widget.keyboardAnimationDuration,
      curve: widget.keyboardAnimationCurve,
      child: content,
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;

  ChatMessage(this.text, this.isMe);
}

// ANIMATION DEMO - Showcases custom animations and curves
class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
  Duration _selectedDuration = const Duration(milliseconds: 300);
  Curve _selectedCurve = Curves.easeOut;
  String _keyboardStatus = 'Keyboard: Hidden';

  final List<Duration> _durations = [
    const Duration(milliseconds: 150),
    const Duration(milliseconds: 300),
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 800),
    const Duration(milliseconds: 1200),
  ];

  final List<MapEntry<String, Curve>> _curves = [
    const MapEntry('Ease Out', Curves.easeOut),
    const MapEntry('Ease In Out', Curves.easeInOut),
    const MapEntry('Bounce', Curves.bounceOut),
    const MapEntry('Elastic', Curves.elasticOut),
    const MapEntry('Back', Curves.easeOutBack),
    const MapEntry('Decelerate', Curves.decelerate),
  ];

  void _handleKeyboardChange(bool visible, double height) {
    setState(() {
      _keyboardStatus = visible
          ? 'Keyboard: Visible (${height.toInt()}px)'
          : 'Keyboard: Hidden';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Customization'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: KeyboardSafe(
          scroll: true,
          dismissOnTapOutside: true,
          safeArea: true,
          persistFooter: false,
          padding: const EdgeInsets.all(20),
          keyboardAnimationDuration: _selectedDuration,
          keyboardAnimationCurve: _selectedCurve,
          onKeyboardChanged: _handleKeyboardChange,
          footer: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✨ Animation: ${_selectedDuration.inMilliseconds}ms with ${_curves.firstWhere((c) => c.value == _selectedCurve).key}',
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Test Animation'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.animation,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Animation Playground',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Customize KeyboardSafe animations and see them in action',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _keyboardStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Animation Controls
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚡ Animation Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Duration Selection
                    const Text(
                      'Animation Duration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _durations.map((duration) {
                        final isSelected = _selectedDuration == duration;
                        return FilterChip(
                          label: Text('${duration.inMilliseconds}ms'),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedDuration = duration);
                            }
                          },
                          selectedColor:
                              const Color(0xFF6366F1).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF6366F1),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Curve Selection
                    const Text(
                      'Animation Curve',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _curves.map((curveEntry) {
                        final isSelected = _selectedCurve == curveEntry.value;
                        return FilterChip(
                          label: Text(curveEntry.key),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCurve = curveEntry.value);
                            }
                          },
                          selectedColor:
                              const Color(0xFF6366F1).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF6366F1),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Test Fields
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🧪 Test Fields',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap these fields to see the animation in action',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      decoration: InputDecoration(
                        labelText: 'First Test Field',
                        prefixIcon:
                            const Icon(Icons.edit, color: Color(0xFF6366F1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Second Test Field',
                        prefixIcon: const Icon(Icons.text_fields,
                            color: Color(0xFF6366F1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Multi-line Field',
                        prefixIcon:
                            const Icon(Icons.notes, color: Color(0xFF6366F1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 24),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF6366F1),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Settings: ${_selectedDuration.inMilliseconds}ms',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                Text(
                                  'Curve: ${_curves.firstWhere((c) => c.value == _selectedCurve).key}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
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

              const SizedBox(height: 100), // Extra space for scrolling
            ],
          ),
        ),
      ),
    );
  }
}

// MAIN APP
void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeyboardSafe Ultimate Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const DemoSelector(),
    );
  }
}

class DemoSelector extends StatelessWidget {
  const DemoSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.keyboard_alt_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'KeyboardSafe',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ultimate Flutter Demo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildDemoCard(
                    context,
                    'Complex Form Demo',
                    'Complete form with all KeyboardSafe features',
                    Icons.assignment_outlined,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComplexFormPage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDemoCard(
                    context,
                    'Reverse Scroll Demo',
                    'Chat-like interface with reverse scrolling',
                    Icons.chat_bubble_outline,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReverseChatDemo(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDemoCard(
                    context,
                    'Animation Customization',
                    'Custom animations and curves showcase',
                    Icons.animation,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnimationDemo(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ComplexFormPage extends StatefulWidget {
  const ComplexFormPage({super.key});

  @override
  State<ComplexFormPage> createState() => _ComplexFormPageState();
}

class _ComplexFormPageState extends State<ComplexFormPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _selectedCountry = 'United States';
  String _selectedGender = 'Male';
  bool _agreeToTerms = false;
  bool _subscribeNewsletter = false;
  double _experience = 2.0;
  String _keyboardStatus = 'Keyboard: Hidden';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleKeyboardChange(bool visible, double height) {
    setState(() {
      _keyboardStatus = visible
          ? 'Keyboard: Visible (${height.toInt()}px)'
          : 'Keyboard: Hidden';
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeToTerms) {
        _showSnackBar('Please agree to terms and conditions', Colors.red);
        return;
      }

      FocusScope.of(context).unfocus();
      _showSnackBar('✨ Application submitted successfully!', Colors.green);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF6366F1)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _keyboardStatus,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: KeyboardSafe(
          scroll: true,
          persistFooter: true,
          dismissOnTapOutside: true,
          safeArea: true,
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
          keyboardAnimationDuration: const Duration(milliseconds: 350),
          keyboardAnimationCurve: Curves.elasticOut,
          onKeyboardChanged: _handleKeyboardChange,
          footer: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      setState(() {
                        _selectedCountry = 'United States';
                        _selectedGender = 'Male';
                        _agreeToTerms = false;
                        _subscribeNewsletter = false;
                        _experience = 2.0;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side:
                          const BorderSide(color: Color(0xFF6366F1), width: 2),
                    ),
                    icon: const Icon(Icons.refresh, color: Color(0xFF6366F1)),
                    label: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _submitForm,
                      icon:
                          const Icon(Icons.rocket_launch, color: Colors.white),
                      label: const Text(
                        'Submit Application',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Glassmorphism Header
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Dream Job Application',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Experience all KeyboardSafe features in this beautiful, comprehensive form',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Form Sections in Cards
                _buildFormSection(
                  'Personal Information',
                  [
                    _buildTextField(
                      'Full Name *',
                      Icons.person_outline,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      'Email Address *',
                      Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!value!.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      'Phone Number *',
                      Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      'Date of Birth',
                      Icons.calendar_today_outlined,
                      keyboardType: TextInputType.datetime,
                      hintText: 'MM/DD/YYYY',
                    ),
                    _buildDropdown(
                      'Gender',
                      Icons.person_outline,
                      _selectedGender,
                      ['Male', 'Female', 'Other', 'Prefer not to say'],
                      (value) => setState(() => _selectedGender = value!),
                    ),
                    _buildDropdown(
                      'Country',
                      Icons.public_outlined,
                      _selectedCountry,
                      _countries,
                      (value) => setState(() => _selectedCountry = value!),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildFormSection(
                  'Professional Information',
                  [
                    _buildTextField(
                      'Current Position',
                      Icons.work_outline,
                    ),
                    _buildTextField(
                      'Company Name',
                      Icons.business_outlined,
                    ),
                    _buildExperienceSlider(),
                    _buildTextField(
                      'Expected Salary',
                      Icons.attach_money_outlined,
                      keyboardType: TextInputType.number,
                      hintText: 'e.g., \$75,000',
                    ),
                    _buildTextField(
                      'LinkedIn Profile',
                      Icons.link_outlined,
                      keyboardType: TextInputType.url,
                      hintText: 'https://linkedin.com/in/yourprofile',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildFormSection(
                  'Additional Information',
                  [
                    _buildTextField(
                      'Skills (comma-separated)',
                      Icons.star_outline,
                      hintText: 'Flutter, Dart, Firebase, etc.',
                      maxLines: 2,
                    ),
                    _buildTextField(
                      'Cover Letter *',
                      Icons.description_outlined,
                      hintText: 'Tell us why you\'re perfect for this role...',
                      maxLines: 4,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please write a brief cover letter';
                        }
                        if (value!.length < 50) {
                          return 'Cover letter should be at least 50 characters';
                        }
                        return null;
                      },
                    ),
                    _buildCheckboxes(),
                  ],
                ),

                const SizedBox(height: 120), // Extra space for scrolling
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: child,
              )),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF6366F1),
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        labelStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF6366F1),
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildExperienceSlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Color(0xFF6366F1)),
              const SizedBox(width: 12),
              Text(
                'Years of Experience: ${_experience.toInt()} years',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF6366F1),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF6366F1),
              overlayColor: const Color(0xFF6366F1).withOpacity(0.2),
            ),
            child: Slider(
              value: _experience,
              min: 0,
              max: 20,
              divisions: 20,
              onChanged: (value) => setState(() => _experience = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text(
            'I agree to the terms and conditions *',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Required to submit application'),
          value: _agreeToTerms,
          onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
          activeColor: const Color(0xFF6366F1),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text(
            'Subscribe to newsletter',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Get updates about new opportunities'),
          value: _subscribeNewsletter,
          onChanged: (value) =>
              setState(() => _subscribeNewsletter = value ?? false),
          activeColor: const Color(0xFF6366F1),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

// REVERSE CHAT DEMO - Showcases reverse scrolling feature
class ReverseChatDemo extends StatefulWidget {
  const ReverseChatDemo({super.key});

  @override
  State<ReverseChatDemo> createState() => _ReverseChatDemoState();
}

class _ReverseChatDemoState extends State<ReverseChatDemo> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage('Hello! This demo shows reverse scrolling.', false),
    ChatMessage('Perfect for chat interfaces!', false),
    ChatMessage('Try typing a message below.', false),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.insert(0, ChatMessage(_messageController.text, true));
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reverse Chat Demo'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
        ),
        child: KeyboardSafe(
          scroll: true,
          reverse: true, // THIS IS THE KEY FEATURE - Reverse scrolling
          dismissOnTapOutside: true,
          safeArea: true,
          persistFooter: true,
          padding: const EdgeInsets.all(16),
          keyboardAnimationDuration: const Duration(milliseconds: 300),
          keyboardAnimationCurve: Curves.easeOutCubic,
          footer: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Reverse Scrolling Demo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Perfect for chat interfaces where new messages appear at the bottom',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ..._messages.map((message) => _buildMessageBubble(message)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: message.isMe
              ? null
              : Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isMe ? const Color(0xFF1F2937) : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
