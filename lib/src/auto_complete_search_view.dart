import 'package:barikoi_autocomplete/src/bloc/location_address_bloc.dart';
import 'package:barikoi_autocomplete/src/bloc/location_address_state.dart';
import 'package:barikoi_autocomplete/src/custom_search_delegate.dart';
import 'package:barikoi_autocomplete/src/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoCompleteSearchView extends StatefulWidget {
  const AutoCompleteSearchView({super.key, required this.apiKey});
  final String apiKey;

  @override
  State<AutoCompleteSearchView> createState() => _AutoCompleteSearchViewState();
}

class _AutoCompleteSearchViewState extends State<AutoCompleteSearchView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LocationAddressBloc(),
      child: BlocConsumer<LocationAddressBloc, LocationAddressState>(
          builder: (context, state) {
            return Material(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                shadowColor: Colors.grey,
                surfaceTintColor: Colors.grey,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Colors.white,
                child: TextField(
                    maxLines: 1,
                    readOnly: true,
                    onTap: () async {
                      var key = widget.apiKey;
                      Place? selectedPlace = await showSearch<Place>(
                        context: context,
                        delegate: CustomSearchDelegate(locationAddressBloc: BlocProvider.of<LocationAddressBloc>(context), key: key),
                      );
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(
                        Icons.menu,
                        color: Colors.grey.shade700,
                        // size: 30,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade700,
                      ),
                      border: InputBorder.none,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade100,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade100)),
                      hoverColor: Colors.black,
                    )),
              ),
            ));
          },
          listener: (context, state) {
            if(state is GetLocationAddressSuccessfully){

            }
          }),
    );
  }
}
