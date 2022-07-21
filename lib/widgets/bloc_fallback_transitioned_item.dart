import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector/cubits/selected_log_index_cubit.dart';
import 'package:bloc_inspector/models/bloc_log.dart';
import 'package:bloc_inspector/widgets/pair_widget.dart';
import 'package:bloc_inspector/widgets/type_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlocFallbackTransitionedItem extends StatelessWidget {
  final BlocLog log;
  final int index;

  const BlocFallbackTransitionedItem({
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
          titleColor: Colors.lightBlueAccent,
          title: Row(children: [
            Expanded(
              flex: 14,
              child: RichText(
                text: TextSpan(
                    text: "Bloc Transitioned: ",
                    children: [
                      TextSpan(
                        text: "<[ ${log.blocName} ]>",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " Event: "),
                      TextSpan(
                        text: log.blocChange!.eventName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  child: Row(children: [
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
                    ),
                  ])),
            ),
            Expanded(
                child: IconButton(
                    icon: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        context.read<SelectedLogIndexCubit>().setIndex(-1)))
          ]),
          body: Column(
            children: [
              Table(
                border: TableBorder.all(),
                children: [
                  const TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Old Value",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "New Value",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(log.oldFallbackState!))),
                    TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(log.newFallbackState!)))
                  ])
                ],
              ),
              if (log.decodeErrorReason != null)
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(log.decodeErrorReason!,
                        style: const TextStyle(fontSize: 12))),
            ],
          )),
    );
  }
}
