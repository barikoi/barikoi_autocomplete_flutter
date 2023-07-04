import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/location_address_state.dart';


class BlocSearchDelegateBuilder<B extends StateStreamable<S>, S>
    extends SearchDelegate<S?> {
  BlocSearchDelegateBuilder({
    required this.bloc,
    this.buildWhen,
    this.onQuery,
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction = TextInputAction.search,
  });

  final B bloc;
  final BlocBuilderCondition<S>? buildWhen;
  final ValueChanged<String>? onQuery;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) return close(context, null);
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty){
      onQuery?.call(query);
    }
    return BlocBuilder<B, S>(
      builder: (context, state){
        if (state is InitialAddress) {
          return const Align(
            alignment: Alignment.topCenter,
              child: Text("Search your address"));
        }
        if (state is AddressRequestSending) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AddressRequestError) {
          return Center(child: Text(state.error ?? ""));
        }

        if (state is AddressNotFound) {
          return Align(
              alignment: Alignment.topCenter,
              child: Text(state.message ?? ""));
        }

        if (state is EmptyAddressRequest) {
          return Align(
              alignment: Alignment.topCenter,
              child: Text(state.message ?? ""));
        }

        if(query.isNotEmpty){
          if (state is GetLocationAddressSuccessfully) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(state.places[index].address ?? ""),
                  onTap: () => close(context, state.places[index].address as S?),
                );
              },
              itemCount: state.places.length,
            );
          }
        }
        return const Align(
            alignment: Alignment.topCenter,
            child: Text("Search your address"));
      },
      bloc: bloc,
      buildWhen: buildWhen,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty){
      onQuery?.call(query);
    }
    return BlocBuilder<B, S>(
      builder: (context, state){
        if (state is InitialAddress) {
          return const Text("Search your address");
        }
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
                title: Text(state.places[index].address ?? ""),
                onTap: () => close(context, state.places[index].address as S?),
              );
            },
            itemCount: state.places.length,
          );
        }
        return const Text("Not address found");
      },
      bloc: bloc,
      buildWhen: buildWhen,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
}