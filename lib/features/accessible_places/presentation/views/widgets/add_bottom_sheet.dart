import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/features/accessible_places/presentation/views/widgets/custom_text_field.dart';
import 'package:hand_by_hand/features/accessible_places/presentation/views/widgets/save_button.dart';
import '../../../data/models/place_model.dart';
import '../../logic/place_cubit.dart';
import 'bottom_sheet_handle.dart';
import 'category_drop_menu.dart';


class AddPlaceBottomSheet extends StatefulWidget {
  const AddPlaceBottomSheet({super.key});

  @override
  State<AddPlaceBottomSheet> createState() => _AddPlaceBottomSheetState();
}

class _AddPlaceBottomSheetState extends State<AddPlaceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  String _type = "cafe";

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  final categories = [
    "cafe",
    "restaurant",
    "hospital",
    "pharmacy",
    "park",
    "clinic",
    "mall"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetHandle(),
              const SizedBox(height: 12),

              const Text(
                "Add New Place",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextFieldPlaces(
                controller: _nameController,
                label: "Place Name",
                icon: Icons.place,
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 12),

              CustomTextFieldPlaces(
                controller: _latController,
                label: "Latitude",
                icon: Icons.map,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter latitude" : null,
              ),
              const SizedBox(height: 12),

              CustomTextFieldPlaces(
                controller: _lngController,
                label: "Longitude",
                icon: Icons.map_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter longitude" : null,
              ),
              const SizedBox(height: 12),

              CategoryDropdown(
                value: _type,
                categories: categories,
                onChanged: (val) => setState(() => _type = val!),
              ),
              const SizedBox(height: 20),

              SaveButton(
                onSave: () {
                  if (_formKey.currentState!.validate()) {
                    final place = PlaceModel(
                      name: _nameController.text,
                      lat: double.parse(_latController.text),
                      lng: double.parse(_lngController.text),
                      type: _type,
                    );

                    context.read<PlaceCubit>().addPlace(place);
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Place added successfully" , style: TextStyle(color: Colors.white),),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        duration: Duration(seconds: 2),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
