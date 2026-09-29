import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/address.dart';
import '../provider/address_provider.dart';
import '../widgets/custom_button.dart';
import '../../core/constants.dart';

class AddressFormScreen extends StatefulWidget {
  final Address? address; // If null, it's Add Mode. If not, it's Edit Mode.

  const AddressFormScreen({super.key, this.address});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController(text: widget.address?.street ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _zipCodeController = TextEditingController(text: widget.address?.zipCode ?? '');
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.address != null;
      final newAddress = Address(
        id: isEdit ? widget.address!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        isDefault: _isDefault,
      );

      final provider = context.read<AddressProvider>();
      
      if (isEdit) {
        await provider.updateAddress(newAddress);
      } else {
        await provider.addAddress(newAddress);
      }

      if (mounted) {
        if (provider.error.isEmpty) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.error)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AddressProvider>().isLoading;
    final isEdit = widget.address != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Address' : 'Add New Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacing16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  hintText: '123 Main St, Apt 4B',
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a street address' : null,
              ),
              const SizedBox(height: AppConstants.spacing16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
                validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a city' : null,
              ),
              const SizedBox(height: AppConstants.spacing16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State / Province',
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacing16),
                  Expanded(
                    child: TextFormField(
                      controller: _zipCodeController,
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacing16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Set as Default Address'),
                value: _isDefault,
                onChanged: (val) {
                  setState(() => _isDefault = val);
                },
              ),
              const SizedBox(height: AppConstants.spacing32),
              CustomButton(
                text: isEdit ? 'Save Changes' : 'Add Address',
                isLoading: isLoading,
                onPressed: _saveAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
