// profile_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String _userName = "Ahmed Hesham"; // Initial values; replace with actual user data
  String _email = "Ahmed@example.com";
  String _phone = "123456789";
  bool _notificationsEnabled = true;
  XFile? _profileImage;

  // Editable states for each field
  bool _isNameEditable = false;
  bool _isEmailEditable = false;
  bool _isPhoneEditable = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  void _toggleEditMode(String field) {
    setState(() {
      if (field == 'name') {
        _isNameEditable = !_isNameEditable;
        if (_isNameEditable) _nameFocusNode.requestFocus();
      } else if (field == 'email') {
        _isEmailEditable = !_isEmailEditable;
        if (_isEmailEditable) _emailFocusNode.requestFocus();
      } else if (field == 'phone') {
        _isPhoneEditable = !_isPhoneEditable;
        if (_isPhoneEditable) _phoneFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: GestureDetector(
        onTap: () {
          // Unfocus all text fields
          _nameFocusNode.unfocus();
          _emailFocusNode.unfocus();
          _phoneFocusNode.unfocus();

          // Disable edit mode for all fields
          setState(() {
            _isNameEditable = false;
            _isEmailEditable = false;
            _isPhoneEditable = false;
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!.path as File)
                      : const AssetImage('assets/default_profile.png') as ImageProvider,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Name Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _nameFocusNode,
                      initialValue: _userName,
                      decoration: const InputDecoration(labelText: "Name"),
                      enabled: _isNameEditable,
                      onChanged: (value) => _userName = value,
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isNameEditable ? Icons.check : Icons.edit),
                    onPressed: () => _toggleEditMode('name'),
                  ),
                ],
              ),

              // Email Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _emailFocusNode,
                      initialValue: _email,
                      decoration: const InputDecoration(labelText: "Email"),
                      enabled: _isEmailEditable,
                      onChanged: (value) => _email = value,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isEmailEditable ? Icons.check : Icons.edit),
                    onPressed: () => _toggleEditMode('email'),
                  ),
                ],
              ),

              // Phone Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _phoneFocusNode,
                      initialValue: _phone,
                      decoration: const InputDecoration(labelText: "Phone"),
                      enabled: _isPhoneEditable,
                      onChanged: (value) => _phone = value,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isPhoneEditable ? Icons.check : Icons.edit),
                    onPressed: () => _toggleEditMode('phone'),
                  ),
                ],
              ),

              SwitchListTile(
                title: const Text("Notifications"),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),

              ListTile(
                title: const Text("My Pledged Gifts"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pushNamed(context, '/myPledgedGifts');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}