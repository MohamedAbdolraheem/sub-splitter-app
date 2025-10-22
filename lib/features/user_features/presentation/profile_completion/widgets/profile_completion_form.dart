import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_splitter_app/features/user_features/presentation/profile/cubit/cubit.dart';

/// {@template profile_completion_form}
/// Form for completing user profile with all required fields
/// {@endtemplate}
class ProfileCompletionForm extends StatefulWidget {
  /// {@macro profile_completion_form}
  const ProfileCompletionForm({super.key});

  @override
  State<ProfileCompletionForm> createState() => _ProfileCompletionFormState();
}

class _ProfileCompletionFormState extends State<ProfileCompletionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  String? _selectedGender;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  void _loadCurrentProfile() {
    final state = context.read<ProfileCubit>().state;
    _nameController.text = state.name;
    _mobileController.text = state.mobileNumber;
    _selectedDateOfBirth = state.dateOfBirth;
    _selectedGender = state.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(),
              const SizedBox(height: 32),

              // Form Fields
              _buildNameField(),
              const SizedBox(height: 16),

              _buildMobileField(),
              const SizedBox(height: 16),

              _buildDateOfBirthField(),
              const SizedBox(height: 16),

              _buildGenderField(),
              const SizedBox(height: 32),

              // Save Button
              _buildSaveButton(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {
            // TODO: Implement image picker
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile picture upload coming soon!'),
              ),
            );
          },
          icon: const Icon(Icons.camera_alt),
          label: const Text('Add Profile Picture'),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name *',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildMobileField() {
    return TextFormField(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Mobile Number *',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
        hintText: '+1 (555) 123-4567',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        }
        // Basic phone number validation
        if (value.length < 10) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return InkWell(
      onTap: () => _selectDateOfBirth(),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date of Birth *',
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
        ),
        child: Text(
          _selectedDateOfBirth != null
              ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
              : 'Select your date of birth',
          style: TextStyle(
            color: _selectedDateOfBirth != null ? null : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: const InputDecoration(
        labelText: 'Gender *',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
      ),
      items:
          _genderOptions.map((String gender) {
            return DropdownMenuItem<String>(value: gender, child: Text(gender));
          }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton(ProfileState state) {
    return ElevatedButton(
      onPressed: state.status == ProfileStatus.loading ? null : _saveProfile,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child:
          state.status == ProfileStatus.loading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : const Text('Complete Profile'),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateProfile(
        name: _nameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        gender: _selectedGender,
      );
    }
  }
}
