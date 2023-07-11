import 'package:barikoi_autocomplete/src/bloc/location_address_bloc.dart';
import 'package:barikoi_autocomplete/src/bloc/location_address_event.dart';
import 'package:barikoi_autocomplete/src/bloc/location_address_state.dart';
import 'package:barikoi_autocomplete/src/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'bloc_search_delegate_builder.dart';

class AutoCompleteSearchView extends StatefulWidget {
  const AutoCompleteSearchView({
    super.key,
    required this.apiKey,
    this.borderRadius = 10,
    this.elevation = 3,
    required this.padding,
    required this.onPlaceSelect,
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.grey,
    this.prefixIconAsset = "assets/barikoi_logo.svg",
    this.prefixIconHeight = 24,
    this.prefixIconWidth = 24,
    this.prefixIconColor = Colors.grey,
    this.suffixIconAsset = "assets/search_icon.svg",
    this.suffixIconHeight = 24,
    this.suffixIconWidth = 24,
    this.suffixIconColor = Colors.grey,
  });

  final String apiKey;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final ValueChanged<Place>? onPlaceSelect;
  final Color backgroundColor;
  final Color shadowColor;
  final String prefixIconAsset;
  final double prefixIconHeight;
  final double prefixIconWidth;
  final Color prefixIconColor;
  final String suffixIconAsset;
  final double suffixIconHeight;
  final double suffixIconWidth;
  final Color suffixIconColor;

  @override
  State<AutoCompleteSearchView> createState() => _AutoCompleteSearchViewState();
}

class _AutoCompleteSearchViewState extends State<AutoCompleteSearchView> {
  Place? selectedPlace;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LocationAddressBloc(),
      child: BlocBuilder<LocationAddressBloc, LocationAddressState>(
        builder: (context, state) {
          return Material(
              child: Padding(
            padding: widget.padding,
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
                  selectedPlace = selected as Place?;
                });
                if (selected != null) {
                  widget.onPlaceSelect?.call(selected as Place);
                }
              },
              child: Card(
                elevation: widget.elevation,
                shadowColor: widget.shadowColor,
                surfaceTintColor: widget.shadowColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.borderRadius))),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: SvgPicture.asset(
                          widget.prefixIconAsset,
                          colorFilter: ColorFilter.mode(
                              widget.prefixIconColor, BlendMode.srcIn),
                          width: widget.prefixIconWidth,
                          height: widget.prefixIconWidth,
                        ),
                      ),
                      Flexible(
                          flex: 10,
                          child: Container(
                            // color: Colors.blueAccent,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            child: Text(selectedPlace?.address ?? ""),
                          )),
                      Flexible(
                          flex: 1,
                          child: selectedPlace == null
                              ? SvgPicture.asset(
                                  widget.suffixIconAsset,
                                  colorFilter: ColorFilter.mode(
                                      widget.suffixIconColor, BlendMode.srcIn),
                                  width: widget.suffixIconWidth,
                                  height: widget.suffixIconWidth,
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
