import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesTabCubit extends Cubit<int> {
  MessagesTabCubit() : super(0);
  void changeTab(int index) => emit(index);
}
