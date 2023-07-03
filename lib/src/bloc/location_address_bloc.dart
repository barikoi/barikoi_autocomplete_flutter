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

      try {
        var searchResult = responseValue.body;
        final Places response = placesFromJson(searchResult);
        if ( response.status == 200 && response.places != null && response.message == null) {
          emit(GetLocationAddressSuccessfully(places: response.places!));
        }
        if (response.status == 200 && response.message != null) {
          emit(AddressNotFound(message: response.message));
        }

        if (response.status == 401 && response.message != null) {
          emit(EmptyAddressRequest(message: response.message));
        }
      } catch (e) {
        emit(AddressRequestError(error: e.toString()));
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
