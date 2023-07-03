import 'dart:developer';
import 'dart:io';
import 'package:barikoi_autocomplete/src/bloc/location_address_event.dart';
import 'package:barikoi_autocomplete/src/bloc/location_address_state.dart';
import 'package:barikoi_autocomplete/src/model/places.dart';
import 'package:barikoi_autocomplete/src/repository/repository.dart';
import 'package:bloc/bloc.dart';


class LocationAddressBloc
    extends Bloc<LocationAddressEvent, LocationAddressState> {
  LocationAddressBloc() : super(InitialAddress()) {
    on<SendLocationAddress>(_onSearchLocationAddress);
  }

  void _onSearchLocationAddress(
      SendLocationAddress event, Emitter<LocationAddressState> emit) async {
    emit(AddressRequestSending());
    try {
      final Repository repository = Repository();
      final responseValue = await repository.sendSearchAddressRequest(
          query: event.searchQuery, key: event.key);
      log("search_statue -> ${responseValue.statusCode}");
      if (responseValue.statusCode == 200) {
        try {
          var searchResult = responseValue.body;
          log("search_result -> $searchResult");
          final Places response = placesFromJson(searchResult);
          if (response.places != null && response.message == null) {
            emit(GetLocationAddressSuccessfully(places: response.places!));
          }
          if (response.places == null && response.message != null) {
            log("empty_place");
            emit(AddressNotFound(message: response.message));
          }
        } catch (e) {
          emit(AddressRequestError(error: "Something is wrong1"));
        }
      } else {
        log("empty_request");
        try {
          final Places response =
              placesFromJson(responseValue.body);
          emit(AddressRequestError(error: response.message));
        } catch (e) {
          emit(AddressRequestError(error: "Something is wrong2"));
        }
      }
    } on SocketException {
      emit(AddressRequestError(
        error: 'No Internet',
      ));
    } on HttpException {
      emit(AddressRequestError(
        error: 'No Service Found',
      ));
    } on FormatException {
      emit(AddressRequestError(
        error: 'Invalid Response format',
      ));
    } catch (e) {
      //print(e);
      emit(AddressRequestError(
        error: e,
      ));
    }
  }
}
