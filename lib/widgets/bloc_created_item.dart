import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_inspector/cubits/selected_log_index_cubit.dart';
import 'package:bloc_inspector/models/bloc_log.dart';
import 'package:bloc_inspector/widgets/pair_widget.dart';
import 'package:bloc_inspector/widgets/type_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlocCreatedItem extends StatelessWidget {
  final BlocLog log;
  final int index;
  const BlocCreatedItem({
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
                    "Value",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
            ...log.state!.keys
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
                                  child: Text(e.value))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TypeText(log.state![e.value])))
                        ]))
                .toList()
          ],
        ),
      ),
    );
  }
}
