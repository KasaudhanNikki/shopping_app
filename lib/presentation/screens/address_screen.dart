import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/address_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state.dart';
import '../widgets/custom_button.dart';
import '../../core/constants.dart';
import 'order_summary_screen.dart';
import 'address_form_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddressFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: addressProvider.isLoading
          ? const LoadingWidget()
          : addressProvider.error.isNotEmpty
              ? EmptyState(
                  message: addressProvider.error,
                  onRetry: () => addressProvider.fetchAddresses(),
                )
              : addressProvider.addresses.isEmpty
                  ? const EmptyState(message: 'No addresses found. Please add one.')
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppConstants.spacing16),
                      itemCount: addressProvider.addresses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacing16),
                      itemBuilder: (context, index) {
                        final address = addressProvider.addresses[index];
                        final isSelected = addressProvider.selectedAddress?.id == address.id;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radius16),
                            side: BorderSide(
                              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => addressProvider.selectAddress(address),
                            borderRadius: BorderRadius.circular(AppConstants.radius16),
                            child: Padding(
                              padding: const EdgeInsets.all(AppConstants.spacing16),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                                  ),
                                  const SizedBox(width: AppConstants.spacing16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(address.street, style: Theme.of(context).textTheme.titleMedium),
                                        Text('${address.city}, ${address.state} ${address.zipCode}'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => AddressFormScreen(address: address)),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () {
                                          addressProvider.deleteAddress(address.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          child: CustomButton(
            text: 'Continue to Summary',
            onPressed: addressProvider.selectedAddress != null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderSummaryScreen()),
                    );
                  }
                : null,
          ),
        ),
      ),
    );
  }
}

