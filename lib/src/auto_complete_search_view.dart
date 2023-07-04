import 'dart:developer';

import 'package:barikoi_autocomplete/src/bloc/location_address_bloc.dart';
import 'package:barikoi_autocomplete/src/bloc/location_address_event.dart';
import 'package:barikoi_autocomplete/src/bloc/location_address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_search_delegate_builder.dart';

class AutoCompleteSearchView extends StatefulWidget {
  const AutoCompleteSearchView({super.key, required this.apiKey});

  final String apiKey;

  @override
  State<AutoCompleteSearchView> createState() => _AutoCompleteSearchViewState();
}

class _AutoCompleteSearchViewState extends State<AutoCompleteSearchView> {
  String? selectedPlace;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LocationAddressBloc(),
      child: BlocBuilder<LocationAddressBloc, LocationAddressState>(
        builder: (context, state) {
          return Material(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                var key = widget.apiKey;
                var selected = await showSearch(
                  context: context,
                  delegate: BlocSearchDelegateBuilder(
                    bloc: BlocProvider.of<LocationAddressBloc>(context),
                    buildWhen: (context, state) {
                      return state is GetLocationAddressSuccessfully;
                    },
                    onQuery: (query) =>
                        BlocProvider.of<LocationAddressBloc>(context).add(
                            SendLocationAddress(key: key, searchQuery: query)),
                  ),
                );
                setState(() {
                  selectedPlace = selected as String?;
                });
              },
              child: Card(
                elevation: 3,
                shadowColor: Colors.grey,
                surfaceTintColor: Colors.grey,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Colors.white,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.menu,
                          color: Colors.grey.shade700,
                          // size: 30,
                        ),
                      ),
                      Flexible(
                          flex: 10,
                          child: Container(
                            // color: Colors.blueAccent,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            child: Text(selectedPlace ?? ""),
                          )),
                      Flexible(
                          flex: 1,
                          child: selectedPlace == null
                              ? Icon(
                                  Icons.search,
                                  color: Colors.grey.shade700,
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedPlace = null;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.grey.shade700,
                                  )))
                    ],
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
