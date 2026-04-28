import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/constants.dart';
import '../../widgets/custom/custom_text_field.dart';
import '../../widgets/custom/custom_button.dart';
import '../../utils/validators.dart';

/// Contact Screen
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate form submission
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Message sent successfully! We will get back to you soon.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Get in Touch',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Have a question? We\'d love to hear from you.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            // Contact Information Cards
            _buildContactCard(
              icon: Icons.phone,
              label: 'Phone',
              value: AppConstants.contactPhone,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.email,
              label: 'Email',
              value: AppConstants.contactEmail,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.access_time,
              label: 'Business Hours',
              value: AppConstants.businessHours,
            ),
            const SizedBox(height: 32),
            // Contact Form
            Text(
              'Send us a Message',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name Field
                  CustomTextField(
                    controller: _nameController,
                    label: 'Your Name',
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: 16),
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  // Subject Field
                  CustomTextField(
                    controller: _subjectController,
                    label: 'Subject',
                    validator: (value) =>
                        Validators.validateNotEmpty(value, 'Subject'),
                  ),
                  const SizedBox(height: 16),
                  // Message Field
                  CustomTextField(
                    controller: _messageController,
                    label: 'Message',
                    minLines: 4,
                    maxLines: 6,
                    validator: (value) =>
                        Validators.validateNotEmpty(value, 'Message'),
                  ),
                  const SizedBox(height: 24),
                  // Submit Button
                  CustomButton(
                    label: _isLoading ? 'Sending...' : 'Send Message',
                    onPressed: () => _isLoading ? null : _submitForm(),
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'What are your delivery areas?',
              'We deliver to all areas within 5km radius of our restaurant.',
            ),
            _buildFAQItem(
              'How long does delivery take?',
              'Typical delivery time is 30-45 minutes depending on your location.',
            ),
            _buildFAQItem(
              'Do you offer vegan options?',
              'Yes, we have a dedicated vegan menu with various options.',
            ),
            _buildFAQItem(
              'Can I modify my order after placing it?',
              'You can modify your order within 5 minutes of placing it.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ExpansionTile(
          title: Text(question),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(answer, style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
