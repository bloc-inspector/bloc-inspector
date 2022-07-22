import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector_client/cubits/selected_log_index_cubit.dart';
import 'package:bloc_inspector_client/models/bloc_log.dart';
import 'package:bloc_inspector_client/widgets/pair_widget.dart';
import 'package:bloc_inspector_client/widgets/type_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlocTransitionedItem extends StatelessWidget {
  final BlocLog log;
  final int index;

  const BlocTransitionedItem({
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
        body: Table(
          border: TableBorder.all(),
          children: [
            const TableRow(children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Variable",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
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
            ...log.blocChange!.oldState.keys
                .toList()
                .asMap()
                .entries
                .map((e) => TableRow(
                        decoration: BoxDecoration(
                          color: e.key.isEven
                              ? Colors.white
                              : Colors.blueGrey.shade100,
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(e.value)),
                          ),
                          TableCell(
                              child: Container(
                                  color: log.blocChange!.oldState[e.value] !=
                                          log.blocChange!.newState[e.value]
                                      ? Colors.red
                                      : Colors.transparent,
                                  padding: const EdgeInsets.all(10),
                                  child: TypeText(
                                    log.blocChange!.oldState[e.value],
                                    colorOverride: log.blocChange!
                                                .oldState[e.value] !=
                                            log.blocChange!.newState[e.value]
                                        ? Colors.white
                                        : null,
                                  ))),
                          TableCell(
                              child: Container(
                                  color: log.blocChange!.oldState[e.value] !=
                                          log.blocChange!.newState[e.value]
                                      ? Colors.green
                                      : Colors.transparent,
                                  padding: const EdgeInsets.all(10),
                                  child: TypeText(
                                      colorOverride: log.blocChange!
                                                  .oldState[e.value] !=
                                              log.blocChange!.newState[e.value]
                                          ? Colors.white
                                          : null,
                                      log.blocChange!.newState[e.value])))
                        ]))
                .toList()
          ],
        ),
      ),
    );
  }
}
