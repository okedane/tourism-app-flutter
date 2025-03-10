import 'package:flutter/material.dart';
import 'package:tourism_app/data/api/api_service.dart';
import 'package:tourism_app/static/tourism_detail_result_state.dart';

class TourismDetailProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  TourismDetailProvider(
    this._apiServices,
  );

  TourismDetailResultState _resultState = TourismDetailNoneState();

  TourismDetailResultState get resultState => _resultState;

 Future<void> fetchTourismDetail(int id) async {
  try {
    _resultState = TourismDetailLoadingState();
    notifyListeners();

    final result = await _apiServices.getTourismDetail(id);

    if (result.error) {
      _resultState = TourismDetailErrorState(result.message);
    } else {
      _resultState = TourismDetailLoadedState(result.place); // Pastikan `place` bukan `places`
    }
  } on Exception catch (e) {
    _resultState = TourismDetailErrorState(e.toString());
  }

  notifyListeners();
}

}
