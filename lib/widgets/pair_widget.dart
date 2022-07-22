import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector_client/cubits/selected_log_index_cubit.dart';

class PairWidget extends StatelessWidget {
  final int index;
  final Widget title;
  final Widget? body;
  final Color? titleColor;

  const PairWidget({
    Key? key,
    required this.index,
    required this.title,
    this.body,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedLogIndexCubit, int>(
      buildWhen: (previous, current) => previous == index || current == index,
      builder: (context, state) => Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            color: titleColor,
            child: title,
          ),
          if (body != null && state == index) (body!),
          Container(
            color: Colors.white,
            height: 1,
          )
        ],
      ),
    );
  }
}
