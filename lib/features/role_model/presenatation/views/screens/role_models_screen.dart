import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/config/app_keys_localization.dart';
import '../../logic/role_model_cubit.dart';
import '../widgets/role_model_custom_container.dart';

class RoleModelsScreen extends StatelessWidget {
  const RoleModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Home.roleModels.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RoleModelCubit, RoleModelState>(
        builder: (context, state) {
          if (state is RoleModelLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoleModelLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.roleModels.length,
              itemBuilder: (context, index) {
                final roleModel = state.roleModels[index];
                if (roleModel.imageUrl.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return RoleModelCustomContainer(roleModel: roleModel);
                }
              },
            );
          } else if (state is RoleModelError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
