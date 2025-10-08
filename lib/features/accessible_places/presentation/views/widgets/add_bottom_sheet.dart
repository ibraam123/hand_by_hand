import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_by_hand/features/accessible_places/presentation/views/widgets/custom_text_field.dart';
import 'package:hand_by_hand/features/accessible_places/presentation/views/widgets/save_button.dart';
import 'package:hand_by_hand/features/auth/presentation/logic/auth_cubit.dart';
import '../../../../../core/config/app_keys_localization.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../../../auth/data/models/user_progress.dart';
import '../../../data/models/place_model.dart';
import '../../../domain/entities/category_entitiy.dart';
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

  final List<CategoryEntity> categories = [
    CategoryEntity("all", CategoriesPlaces.all.tr()),
    CategoryEntity("cafe", CategoriesPlaces.cafe.tr()),
    CategoryEntity("restaurant", CategoriesPlaces.restaurant.tr()),
    CategoryEntity("park", CategoriesPlaces.park.tr()),
    CategoryEntity("clinic", CategoriesPlaces.clinic.tr()),
    CategoryEntity("pharmacy", CategoriesPlaces.pharmacy.tr()),
    CategoryEntity("mall", CategoriesPlaces.mall.tr()),
    CategoryEntity("hospital", CategoriesPlaces.hospital.tr()),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetHandle(),
              const SizedBox(height: 12),
              Text(
                AccessiblePlaces.addPlace.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextFieldPlaces(
                controller: _nameController,
                label: AccessiblePlaces.placeName.tr(),
                icon: Icons.place,
                validator: (v) =>
                    v!.isEmpty ? AccessiblePlaces.enterName.tr() : null,
              ),
              const SizedBox(height: 12),

              CustomTextFieldPlaces(
                controller: _latController,
                label: AccessiblePlaces.latitude.tr(),
                icon: Icons.map,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? AccessiblePlaces.enterLatitude.tr() : null,
              ),
              const SizedBox(height: 12),

              CustomTextFieldPlaces(
                controller: _lngController,
                label: AccessiblePlaces.longitude.tr(),
                icon: Icons.map_outlined,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? AccessiblePlaces.enterLongitude.tr() : null,
              ),
              const SizedBox(height: 12),

              CategoryDropdown(
                value: _type,
                categories: categories,
                onChanged: (val) => setState(() => _type = val!),
              ),
              const SizedBox(height: 20),

              SaveButton(
                label: General.save.tr(),
                icon: Icons.save,
                onSave: () {
                  if (_formKey.currentState!.validate()) {
                    final authState = context.read<AuthCubit>().state;

                    if (authState is AuthError) {
                      CustomSnackBar.show(
                        context,
                        message: authState.errorMessage,
                        backgroundColor: theme.colorScheme.onError,
                        textColor: theme.colorScheme.onErrorContainer,
                        icon: Icons.error,
                        duration: Duration(seconds: 2),
                      );
                      return;
                    }
                    final user = (authState as AuthSuccess).user;
                    final progress = user?.progress ?? UserProgress(
                      totalLessons: 0,
                      completedLessons: 0,
                      streakDays: 0,
                      contributedPlaces: 0,
                    );

                    final place = PlaceModel(
                      id: '',
                      name: _nameController.text,
                      lat: double.parse(_latController.text),
                      lng: double.parse(_lngController.text),
                      type: _type,
                    );

                    context.read<PlaceCubit>().addPlace(place , user!.id , progress);
                    Navigator.pop(context);

                    CustomSnackBar.show(
                      context,
                      message: "✅ Place added successfully",
                      backgroundColor: theme.colorScheme.primary,
                      textColor: theme.colorScheme.onPrimary,
                      icon: Icons.check_circle,
                      duration: Duration(seconds: 2),
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
