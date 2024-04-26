import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_quran_app/features/core/cubit/internet_state.dart';

class InternetCubit extends Cubit<InternetStatus>{
  InternetCubit() : super(const InternetStatus(ConnectivityStatus.disconnected));

  void checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectivityStatus(connectivityResult);
  }

  void _updateConnectivityStatus(ConnectivityResult result){
    if(result == ConnectivityResult.none){
      emit(const InternetStatus(ConnectivityStatus.disconnected));
    }
    else{
      emit(const InternetStatus(ConnectivityStatus.connected));
    }
  }

  late StreamSubscription<ConnectivityResult?> _subscription;

  void trackConnectivityChange(){
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectivityStatus(result);
    });
  }

  void dispose(){
    _subscription.cancel();
  }

}