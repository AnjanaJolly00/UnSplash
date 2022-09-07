import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash/bloc/search_bloc.dart';
import 'package:unsplash/bloc/search_event.dart';
import 'package:unsplash/screens/image_screen.dart';
import 'package:unsplash/widgets/app_loader.dart';
import 'package:unsplash/widgets/app_widgets.dart';
import '../bloc/search_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  AppLoader loader = AppLoader();
  ScrollController scrollController = ScrollController();
  late SearchBloc searchBloc;
  Timer? _debounce;

  @override
  void initState() {
    searchBloc = BlocProvider.of<SearchBloc>(context);
    scrollController.addListener(pagination);
    super.initState();
  }

  pagination() {
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) &&
        (searchBloc.canLoadMore)) {
      searchBloc.add(
        SearchEvent(searchValue: searchController.text, loadMore: true),
      );
    }
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      searchBloc.results = [];
      FocusScope.of(context).unfocus();
      searchBloc.add(
        SearchEvent(searchValue: searchController.text, loadMore: false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppWidgets.textField(
          prefixIcon: clearButton,
          suffixIcon: searchButton,
          controller: searchController,
          onChanged: _onSearchChanged,
          keyboardType: TextInputType.text,
          maxLength: 10,
          hint: '',
        ),
      ),
      body: InkWell(
        onTap: (() => FocusScope.of(context).unfocus()),
        child:
            BlocListener<SearchBloc, SearchState>(listener: (context, state) {
          if (state is SearchLoadingState) {
            loader.show(context);
          }
          if (state is SearchSuccessState) {
            loader.hide(context);
          }
          if (state is SearchFailureState) {
            loader.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg!),
                duration: const Duration(milliseconds: 300),
              ),
            );
          }
        }, child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchSuccessState && searchBloc.results.isEmpty) {
              return const Center(
                child: Text(
                  'No Results !!!',
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                ),
              );
            }
            return body();
          },
        )),
      ),
    );
  }

  Widget body() {
    return StaggeredGridView.countBuilder(
      controller: scrollController,
      crossAxisCount: 4,
      itemCount: searchBloc.results.length,
      itemBuilder: ((context, index) {
        var item = searchBloc.results[index];
        return InkWell(
          onTap: (() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ImageScreen(imageUrl: item.url!.fullUrl!)),
            );
          }),
          child: Image.network(item.url!.thumbUrl!),
        );
      }),
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget get searchButton => IconButton(
        splashRadius: 1,
        color: Colors.black,
        padding: const EdgeInsets.all(0),
        onPressed: () {
          FocusScope.of(context).unfocus();
          searchBloc.add(
            SearchEvent(searchValue: searchController.text, loadMore: false),
          );
        },
        icon: const Icon(Icons.search),
      );

//

  Widget get clearButton => IconButton(
        splashRadius: 1,
        color: Colors.black,
        padding: const EdgeInsets.all(0),
        onPressed: () {
          FocusScope.of(context).unfocus();
          searchController.clear();
        },
        icon: const Icon(Icons.clear),
      );

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
