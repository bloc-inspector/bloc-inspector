import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector_client/cubits/selected_log_index_cubit.dart';
import 'package:bloc_inspector_client/models/bloc_log.dart';
import 'package:bloc_inspector_client/widgets/pair_widget.dart';

import 'package:timeago/timeago.dart' as timeago;

class BlocFallbackCreatedItem extends StatelessWidget {
  final BlocLog log;
  final int index;
  const BlocFallbackCreatedItem({
    Key? key,
    required this.log,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SelectedLogIndexCubit>().setIndex(index);
      },
      child: PairWidget(
        index: index,
        titleColor: Colors.green,
        title: Row(children: [
          Expanded(
            flex: 14,
            child: RichText(
              text: TextSpan(
                  text: "Bloc: ",
                  children: [
                    TextSpan(
                      text: "<[ ${log.blocName} ]>",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " has been created!")
                  ],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white)),
            ),
          ),
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    const Icon(
                      Icons.punch_clock,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      timeago.format(log.createdAt!),
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )),
          Expanded(
            child: IconButton(
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.read<SelectedLogIndexCubit>().setIndex(-1)),
          )
        ]),
        body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: Text(log.fallbackState?.toString() ?? "")),
      ),
    );
  }
}
