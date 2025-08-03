import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WithoutKeyboardSafeScreen extends StatefulWidget {
  const WithoutKeyboardSafeScreen({super.key});

  @override
  State<WithoutKeyboardSafeScreen> createState() =>
      _WithoutKeyboardSafeScreenState();
}

class _WithoutKeyboardSafeScreenState extends State<WithoutKeyboardSafeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Without Keyboard Safe',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: MyApp.ashDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: _showStruggleDialog,
            tooltip: 'See The Struggles',
          ),
        ],
      ),
      // NO KeyboardSafe wrapper - this is where the problems begin!
      body: Column(
        children: [
          // Main content that will be covered by keyboard
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section with struggle theme
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            MyApp.ashDark,
                            MyApp.ashLight,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'The Struggle is Real',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Experience the frustration: footer floats up covering fields, no auto-scroll, and broken layouts.',
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
                              _buildProblemChip('Footer covers fields', true),
                              _buildProblemChip('No auto-scroll', true),
                              _buildProblemChip('Floating mess', true),
                              _buildProblemChip('Manual handling', true),
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
                            size: 18, color: MyApp.ashColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: MyApp.ashColor, width: 2),
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

                    // Problem demonstration cards
                    _buildProblemCard(
                      'Footer Covers Fields',
                      'The footer floats up and covers your form fields - super annoying!',
                      Icons.layers,
                      Colors.red,
                    ),

                    const SizedBox(height: 12),

                    _buildProblemCard(
                      'No Auto-Scroll',
                      'You have to manually scroll to see what you\'re typing',
                      Icons.pan_tool,
                      Colors.orange,
                    ),

                    const SizedBox(height: 12),

                    _buildProblemCard(
                      'Floating Mess',
                      'UI elements jump around making the experience terrible',
                      Icons.warning,
                      Colors.purple,
                    ),

                    // Extra spacing to show the problem
                    const SizedBox(
                        height: 100), // This won't help when keyboard appears!
                  ],
                ),
              ),
            ),
          ),

          // Footer that will FLOAT UP and cover fields - this is the main problem!
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyApp.ashDark,
                  MyApp.ashLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Warning about keyboard problems
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white70,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'This footer floats up and covers fields!',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action buttons that will cover the form fields
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // No easy way to dismiss keyboard without KeyboardSafe
                          FocusScope.of(context).unfocus();
                          _clearForm();
                        },
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
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: MyApp.ashColor,
                          textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Submit (Covers Fields!)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    return TextFormField(
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
          textStyle: const TextStyle(color: MyApp.ashLight),
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: MyApp.ashColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MyApp.ashColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildProblemChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
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
            isActive ? Icons.error : Icons.check_circle,
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

  Widget _buildProblemCard(
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
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: MyApp.ashColor,
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

  void _showStruggleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: MyApp.ashDark),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Common Keyboard Problems',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MyApp.ashColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProblemItem(
                'Footer Floats Up',
                'Footer moves up with keyboard and covers form fields - extremely annoying!',
              ),
              _buildProblemItem(
                'No Auto-Scroll',
                'Users can\'t see what they\'re typing in covered fields.',
              ),
              _buildProblemItem(
                'UI Layout Breaks',
                'Content gets covered and becomes completely inaccessible.',
              ),
              _buildProblemItem(
                'No Tap-to-Dismiss',
                'Users must manually close keyboard every time.',
              ),
              _buildProblemItem(
                'Manual Handling Required',
                'Developers need to write complex code for basic functionality.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MyApp.ashDark.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: MyApp.ashDark.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 16, color: MyApp.ashDark),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Solution: KeyboardSafe Package',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: MyApp.ashColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'All these problems disappear with just one widget wrapper. '
                      'Try the "With KeyboardSafe" version to see the difference!',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Got It'),
            style: TextButton.styleFrom(
              foregroundColor: MyApp.ashDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
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
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                    'Form submitted successfully! (Despite the floating footer chaos)'),
              ),
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
              Expanded(
                child: Text(
                    'Please fill required fields (if you can see them under the footer)'),
              ),
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
