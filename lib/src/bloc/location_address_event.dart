import 'package:equatable/equatable.dart';


abstract class LocationAddressEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendLocationAddress extends LocationAddressEvent {
  SendLocationAddress({required this.key,required this.searchQuery});
  final String key;
  final String searchQuery;
}
