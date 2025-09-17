import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/colors.dart';
import '../../core/styles.dart';
import '../blocs/popular_persons/popular_people_bloc.dart';
import '../widgets/person_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PopularPeopleBloc bloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<PopularPeopleBloc>();
    bloc.add(FetchPopularPeople());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        bloc.add(FetchMorePopularPeople());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Popular People',
          style: AppStyles.titleLarge.copyWith(color: AppColors.textOnPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: BlocBuilder<PopularPeopleBloc, PopularPeopleState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is PopularPeopleLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is PopularPeopleLoaded) {
            final people = state.people;
            return ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(AppStyles.spacing16),
              itemCount: people.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= people.length) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppStyles.spacing12),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }
                final person = people[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: AppStyles.spacing12),
                  child: PersonListItem(person: person),
                );
              },
            );
          }
          if (state is PopularPeopleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppStyles.iconXLarge,
                    color: AppColors.error,
                  ),
                  SizedBox(height: AppStyles.spacing16),
                  Text(
                    'Error: ${state.message}',
                    style: AppStyles.bodyLarge.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.spacing24),
                  ElevatedButton(
                    onPressed: () => bloc.add(FetchPopularPeople()),
                    style: AppStyles.primaryButton,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
