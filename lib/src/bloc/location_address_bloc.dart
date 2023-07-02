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
      if (responseValue.statusCode == 200) {
        try {
          final Places response =
          placesFromJson(responseValue.stream.bytesToString());
          if (response.places != null) {
            emit(GetLocationAddressSuccessfully(places: response.places!));
          }
          if (response.places != null) {
            emit(AddressNotFound(message: response.message));
          }
        } catch (e) {
          emit(AddressRequestError(error: "Something is wrong"));
        }
      } else {
        try {
          final Places response =
              placesFromJson(responseValue.stream.bytesToString());
          emit(AddressRequestError(error: response.message));
        } catch (e) {
          emit(AddressRequestError(error: "Something is wrong"));
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
