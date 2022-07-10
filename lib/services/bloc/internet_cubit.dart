import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todoapp/constants/enums.dart';
import 'package:todoapp/services/bloc/internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  Connectivity connectivity = Connectivity();

  InternetCubit() : super(InternetLoading()) {}

  onResult() {
    return connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.Wifi);
      } else if (result == ConnectivityResult.mobile) {
        emitInternetConnected((ConnectionType.Mobile));
      } else {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectionType connectionType) =>
      emit(InternetConnected(connectionType: connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());
}
