library;

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

class WithKeyboardSafeScreen extends StatefulWidget {
  const WithKeyboardSafeScreen({super.key});

  @override
  State<WithKeyboardSafeScreen> createState() => _WithKeyboardSafeScreenState();
}

class _WithKeyboardSafeScreenState extends State<WithKeyboardSafeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();

  bool _isKeyboardVisible = false;
  double _keyboardHeight = 0.0;
  bool _autoScrollEnabled = true;
  bool _dismissOnTapEnabled = true;
  bool _persistFooter = false;
  bool _safeAreaEnabled = false;

  String _selectedCountry = 'United States';
  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'Brazil',
    'India',
    'China'
  ];

  @override
  void initState() {
    super.initState();
    // Add focus listeners to detect keyboard state changes
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    // Listen to focus changes for better keyboard state detection
    final controllers = [
      _nameController,
      _emailController,
      _phoneController,
      _addressController,
      _notesController,
      _tagsController,
    ];

    for (final controller in controllers) {
      controller.addListener(() {
        // This helps ensure UI updates when text changes
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'With Keyboard Safe',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: MyApp.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Demo Settings',
          ),
        ],
      ),
      body: KeyboardSafe(
        // Core features
        scroll: true,
        autoScrollToFocused: _autoScrollEnabled,
        dismissOnTapOutside: _dismissOnTapEnabled,
        safeArea: _safeAreaEnabled,
        persistFooter: _persistFooter,

        // Styling
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        keyboardAnimationDuration: const Duration(milliseconds: 300),
        keyboardAnimationCurve: Curves.easeInOut,

        // Enhanced keyboard state callback with debugging
        onKeyboardChanged: (visible, height) {
          print('🔍 KeyboardSafe callback: visible=$visible, height=$height');

          if (mounted) {
            setState(() {
              _isKeyboardVisible = visible;
              _keyboardHeight = height;
            });

            // Additional debug info
            print(
                '📱 State updated: _isKeyboardVisible=$_isKeyboardVisible, _keyboardHeight=$_keyboardHeight');
          }
        },

        // Footer with demo controls and submit button
        footer: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [MyApp.primaryColor, MyApp.blueColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 💡 Enhanced keyboard status with fallback detection
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _isKeyboardVisible
                      ? MyApp.greenColor.withOpacity(0.1)
                      : Colors.white.withOpacity(0.1),
                  border: Border.all(
                    color:
                        _isKeyboardVisible ? MyApp.greenColor : Colors.white70,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isKeyboardVisible ? Icons.keyboard : Icons.keyboard_hide,
                      size: 16,
                      color:
                          _isKeyboardVisible ? MyApp.greenColor : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _buildKeyboardStatusText(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _isKeyboardVisible
                            ? MyApp.greenColor
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 💡 Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        KeyboardSafe.dismissKeyboard(context);
                        _clearForm();
                      },
                      label: const Text('Clear'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      label: const Text('Submit Form'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: MyApp.primaryColor,
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Main form content
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyApp.primaryColor,
                      MyApp.blueColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const Text(
                      'KeyboardSafe Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Experience intelligent keyboard handling with auto-scroll, tap-to-dismiss, and smooth animations.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFeatureChip('Auto-scroll', _autoScrollEnabled),
                        _buildFeatureChip(
                            'Tap-to-dismiss', _dismissOnTapEnabled),
                        _buildFeatureChip('Persist footer', _persistFooter),
                        _buildFeatureChip('Safe area', _safeAreaEnabled),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Personal Information Section
              _buildSectionHeader('Personal Information'),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'you@example.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Email is required';
                  }
                  if (!value!.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: '+1 (555) 123-4567',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 24),

              // Location Section
              _buildSectionHeader('Location'),
              const SizedBox(height: 12),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: InputDecoration(
                  labelText: 'Country',
                  prefixIcon: const Icon(Icons.public,
                      size: 18, color: MyApp.blueColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: MyApp.primaryColor, width: 2),
                  ),
                ),
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                label: 'Address',
                hint: 'Street, City, State, ZIP',
                icon: Icons.location_on,
                maxLines: 3,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 24),

              // Additional Information Section
              _buildSectionHeader('Additional Information'),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Any additional information...',
                icon: Icons.note,
                maxLines: 4,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _tagsController,
                label: 'Tags',
                hint: '#work #important #follow-up',
                icon: Icons.tag,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 32),

              // Feature demonstration cards
              _buildDemoCard(
                'Auto-Scroll Feature',
                'Focus on any field to see it automatically scroll into view',
                Icons.vertical_align_center,
                Colors.green,
              ),

              const SizedBox(height: 12),

              _buildDemoCard(
                'Tap-to-Dismiss',
                'Tap anywhere outside input fields to hide the keyboard',
                Icons.touch_app,
                Colors.orange,
              ),

              const SizedBox(height: 12),

              _buildDemoCard(
                'Smart Footer',
                'Notice how the footer stays accessible above the keyboard',
                Icons.layers,
                Colors.purple,
              ),

              // Extra spacing for footer
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced keyboard status text with fallback detection
  String _buildKeyboardStatusText() {
    // Fallback: Check MediaQuery for keyboard visibility
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisibleFallback = keyboardHeight > 0;

    // Use KeyboardSafe callback data if available, otherwise fall back to MediaQuery
    final actuallyVisible = _isKeyboardVisible || isKeyboardVisibleFallback;
    final actualHeight = _keyboardHeight > 0 ? _keyboardHeight : keyboardHeight;

    if (actuallyVisible && actualHeight > 0) {
      return 'Keyboard: ${actualHeight.toInt()} px';
    } else {
      return 'Keyboard Hidden';
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        // Additional focus tracking for better keyboard state detection
        print('🎯 Field "$label" focus changed: $hasFocus');
        if (hasFocus) {
          // Small delay to ensure keyboard state is updated
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              if (keyboardHeight > 0 && !_isKeyboardVisible) {
                print('🔧 Fallback: Detected keyboard via MediaQuery');
                setState(() {
                  _isKeyboardVisible = true;
                  _keyboardHeight = keyboardHeight;
                });
              }
            }
          });
        }
      },
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(fontSize: 14),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(fontWeight: FontWeight.w400),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Colors.grey),
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: MyApp.blueColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: MyApp.primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, bool enabled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: enabled
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.tune, color: MyApp.primaryColor),
            const SizedBox(width: 8),
            Text(
              'KeyboardSafe Settings',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: MyApp.primaryColor),
              ),
            ),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Core Features Section
                _buildSettingsSection(
                  'Core Features',
                  Icons.settings,
                  [
                    SwitchListTile(
                      title: const Text('Enable Scrolling'),
                      subtitle:
                          const Text('Allow content to scroll when needed'),
                      value: true, // Always enabled in this demo
                      onChanged: null, // Disabled to show it's always on
                      secondary:
                          const Icon(Icons.slideshow, color: Colors.grey),
                    ),
                    SwitchListTile(
                      title: const Text('Auto-scroll to focused field'),
                      subtitle: const Text(
                          'Automatically scroll when focusing inputs'),
                      value: _autoScrollEnabled,
                      onChanged: (value) {
                        setDialogState(() => _autoScrollEnabled = value);
                        setState(() => _autoScrollEnabled = value);
                      },
                      secondary: Icon(Icons.vertical_align_center,
                          color: _autoScrollEnabled
                              ? MyApp.greenColor
                              : Colors.grey),
                    ),
                    SwitchListTile(
                      title: const Text('Dismiss on tap outside'),
                      subtitle:
                          const Text('Hide keyboard when tapping outside'),
                      value: _dismissOnTapEnabled,
                      onChanged: (value) {
                        setDialogState(() => _dismissOnTapEnabled = value);
                        setState(() => _dismissOnTapEnabled = value);
                      },
                      secondary: Icon(Icons.touch_app,
                          color: _dismissOnTapEnabled
                              ? MyApp.greenColor
                              : Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Layout Features Section
                _buildSettingsSection(
                  'Layout Options',
                  Icons.view_quilt,
                  [
                    SwitchListTile(
                      title: const Text('Persistent footer'),
                      subtitle: const Text(
                          'Footer floats above keyboard (can feel intrusive)'),
                      value: _persistFooter,
                      onChanged: (value) {
                        setDialogState(() => _persistFooter = value);
                        setState(() => _persistFooter = value);
                      },
                      secondary: Icon(Icons.layers,
                          color: _persistFooter ? Colors.orange : Colors.grey),
                    ),
                    SwitchListTile(
                      title: const Text('Safe area'),
                      subtitle: const Text('Wrap content in SafeArea'),
                      value: _safeAreaEnabled,
                      onChanged: (value) {
                        setDialogState(() => _safeAreaEnabled = value);
                        setState(() => _safeAreaEnabled = value);
                      },
                      secondary: Icon(Icons.phone_android,
                          color:
                              _safeAreaEnabled ? MyApp.blueColor : Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Info Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MyApp.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: MyApp.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: MyApp.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Pro Tips',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: MyApp.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Persistent footer = false is recommended for better UX\n'
                        '• Auto-scroll requires scrolling to be enabled\n'
                        '• Tap-to-dismiss provides native app feel\n'
                        '• Safe area prevents overlap with system UI',
                        style: TextStyle(fontSize: 12, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Close'),
            style: TextButton.styleFrom(
              foregroundColor: MyApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
      String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: MyApp.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: MyApp.primaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _notesController.clear();
    _tagsController.clear();
    setState(() {
      _selectedCountry = 'United States';
    });
  }

  void _submitForm() {
    KeyboardSafe.dismissKeyboard(context);

    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Form submitted successfully!'),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Please fill in all required fields'),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
