import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BlocSearchDelegateBuilder<B extends StateStreamable<S>, S>
    extends SearchDelegate<S?> {
  BlocSearchDelegateBuilder({
    required this.builder,
    required this.bloc,
    this.buildWhen,
    this.onQuery,
    super.searchFieldLabel,
    super.searchFieldStyle,
    super.searchFieldDecorationTheme,
    super.keyboardType,
    super.textInputAction = TextInputAction.search,
  });

  final BlocWidgetBuilder<S> builder;
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
      builder: builder,
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
      builder: builder,
      bloc: bloc,
      buildWhen: buildWhen,
    );
  }

  @override
  Widget? buildLeading(BuildContext context) => null;
}