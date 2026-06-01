import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/location_provider.dart';

// A stateful widget to display location header with user avatar.
// Tapping the avatar opens a dialog to view and edit the user's name and address.
class LocationHeader extends StatefulWidget {
  const LocationHeader({Key? key}) : super(key: key);

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  // Placeholder user data; in a real app this would come from a provider or service.
  String _userName = 'Praveen Krishna';

  // Show a dialog that allows editing the address (and display name).
  Future<void> _showEditAddressDialog() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final TextEditingController addressController =
        TextEditingController(text: locationProvider.currentAddress);
    final _formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $_userName'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter new address',
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Address cannot be empty'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  locationProvider.updateAddressManually(addressController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppTheme.cardLight,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: AppTheme.softShadow,
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Delivery boy icon / pin
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.electric_bolt_rounded,
                    color: AppTheme.primaryOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Location text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Delivering in 10 mins',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppTheme.textDark,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        locationProvider.currentAddress,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // User Avatar or Quick Profile Icon
                GestureDetector(
                  onTap: _showEditAddressDialog,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryOrangeGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Center(
                      child: Text(
                        // Show initials of the user name
                        _userName.isNotEmpty
                            ? _userName
                                .trim()
                                .split(' ')
                                .map((e) => e[0])
                                .join()
                            : '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
