import 'package:barikoi_autocomplete/src/bloc/location_address_event.dart';
import 'package:barikoi_autocomplete/src/bloc/location_address_state.dart';
import 'package:barikoi_autocomplete/src/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchDelegate extends SearchDelegate<Place> {
  CustomSearchDelegate({required this.locationAddressBloc, required this.key});

  final Bloc<LocationAddressEvent, LocationAddressState> locationAddressBloc;
  final String key;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildResults(BuildContext context) {
    locationAddressBloc.add(SendLocationAddress(key: key, searchQuery: query));
    // if (query.length < 3) {
    //   return const Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Center(
    //         child: Text(
    //           "Search term must be longer than two letters.",
    //         ),
    //       )
    //     ],
    //   );
    // }

    return BlocBuilder(
      bloc: locationAddressBloc,
      builder: (BuildContext context, LocationAddressState state) {
        if (state is AddressRequestSending) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AddressRequestError) {
          return Center(child: Text(state.error ?? ""));
        }

        if (state is AddressNotFound) {
          return Center(child: Text(state.message ?? ""));
        }

        if (state is EmptyAddressRequest) {
          return Center(child: Text(state.message ?? ""));
        }

        if (state is GetLocationAddressSuccessfully) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(state.places[index].address ?? "a"),
                onTap: () => close(context, state.places[index]),
              );
            },
            itemCount: state.places.length,
          );
        }
        return const Text("Not address found");
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}
