import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/strapi_api_client.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<StrapiApiClient>().submitRegistration(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        notes: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );
      if (!mounted) return;
      form.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _noteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công! Đợi xác nhận từ BTC nhé.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể gửi đăng ký: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Đăng ký tham gia',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hãy để lại thông tin của bạn để Global Tech Solutions xếp chỗ.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'BTC sẽ gửi email xác nhận cùng với các hướng dẫn trước sự kiện.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập họ tên';
                      }
                      if (value.trim().length < 3) {
                        return 'Họ tên quá ngắn';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email liên hệ',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email là bắt buộc';
                      }
                      final emailRegex = RegExp(
                        r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$",
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
                      if (!phoneRegex.hasMatch(value.trim())) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú (tùy chọn)',
                      prefixIcon: Icon(Icons.note_alt_outlined),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        _isSubmitting ? 'Đang gửi...' : 'Gửi đăng ký',
                      ),
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
}
