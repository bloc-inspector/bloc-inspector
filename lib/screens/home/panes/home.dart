import 'package:bloc_inspector_client/blocs/service/service_bloc.dart';
import 'package:bloc_inspector_client/config/colors.dart';
import 'package:bloc_inspector_client/config/spacing.dart';
import 'package:bloc_inspector_client/utils/color_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePane extends StatelessWidget {
  const HomePane({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) => Column(
        children: [
          Row(
            children: [
              Card(
                color: ColorGate(
                  context: context,
                  darkModeColor: AppColors.darkModeBlack,
                ).color,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Text(state.instances.length.toString()),
                      AppSpacing.verticalSpaceMedium,
                      Text(
                          "Instance${state.instances.length > 1 || state.instances.isEmpty ? 's' : ''}"),
                    ],
                  ),
                ),
              ),
              Card(
                color: ColorGate(
                  context: context,
                  darkModeColor: AppColors.darkModeBlack,
                ).color,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Text(state.logs.entries.isEmpty
                          ? '0'
                          : state.logs.entries
                              .map((e) => e.value.length)
                              .reduce((a, b) => a + b)
                              .toString()),
                      AppSpacing.verticalSpaceMedium,
                      Text(
                          "Log${(state.logs.entries.isEmpty || state.logs.entries.map((e) => e.value.length).reduce((a, b) => a + b) > 1) ? 's' : ''}"),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
