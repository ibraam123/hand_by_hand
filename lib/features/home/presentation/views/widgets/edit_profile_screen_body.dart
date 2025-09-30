import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import '../../logic/profile_cubit.dart';

class EditProfileScreenBody extends StatefulWidget {
  const EditProfileScreenBody({super.key});

  @override
  State<EditProfileScreenBody> createState() => _EditProfileScreenBodyState();
}

class _EditProfileScreenBodyState extends State<EditProfileScreenBody> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded || state is ProfileEdit) {
      _firstNameController =
          TextEditingController(text: (state as dynamic).firstName);
      _lastNameController =
          TextEditingController(text: (state as dynamic).lastName);
    } else {
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().saveProfile(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );
      Navigator.pop(context); // Go back to profile screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          Profile.editProfile.tr(),
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: AuthKeys.firstName.tr(),
                  labelStyle:
                      TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white54 : Colors.black38),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white : Colors.blue),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? AuthKeys.enterFirstName.tr() : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: AuthKeys.lastName.tr(),
                  labelStyle:
                      TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white54 : Colors.black38),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white : Colors.blue),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? AuthKeys.enterLastName.tr() : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  General.save.tr(),
                  style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.black : Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
