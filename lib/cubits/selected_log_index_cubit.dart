import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedLogIndexCubit extends Cubit<int> {
  SelectedLogIndexCubit() : super(-1);
  void setIndex(int index) => emit(index);
}
