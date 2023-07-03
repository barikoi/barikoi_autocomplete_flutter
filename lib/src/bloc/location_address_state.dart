
import 'package:barikoi_autocomplete/src/model/place.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LocationAddressState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialAddress extends LocationAddressState {}

class AddressRequestSending extends LocationAddressState {}

class GetLocationAddressSuccessfully extends LocationAddressState {
  GetLocationAddressSuccessfully({required this.places});
  final List<Place> places;

 @override
 List<Object> get props => [places];

}

class AddressNotFound extends LocationAddressState {
  AddressNotFound({this.message});
  final dynamic message;

  @override
  List<Object> get props => [message];
}

class EmptyAddressRequest extends LocationAddressState {
  EmptyAddressRequest({this.message});
  final dynamic message;

  @override
  List<Object> get props => [message];
}

class AddressRequestError extends LocationAddressState {
  AddressRequestError({this.error});
  final dynamic error;

  @override
  List<Object> get props => [error];
}