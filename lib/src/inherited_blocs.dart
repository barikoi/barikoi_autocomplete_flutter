
import 'package:barikoi_autocomplete/src/bloc/location_address_bloc.dart';
import 'package:flutter/material.dart';

class InheritedBlocs extends InheritedWidget {
  const InheritedBlocs(
      { Key? key,
        required this.searchBloc,
        required this.child})
      : super(key: key, child: child);

  final Widget child;
  final LocationAddressBloc searchBloc;

  static InheritedBlocs of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedBlocs>()
    as InheritedBlocs);
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }
}