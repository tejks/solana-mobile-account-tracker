import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/cubit/tokens_cubit.dart';
import 'package:solana_mobile_account_tracker/models/local_account.dart';
import 'package:solana_mobile_account_tracker/services/short_pubkey.dart';
import 'package:solana_mobile_account_tracker/widgets/circular_chart.dart';
import 'package:solana_mobile_account_tracker/widgets/n_element_token_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  String _getCumuativeUsd(double cumuativeUsd) =>
      '${cumuativeUsd.toStringAsFixed(2)} \$';

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<TokensCubit, TokensState>(
            builder: (context, state) {
              final localAccounts =
                  (context.read<AccountsCubit>().state as AccountsLoaded)
                      .accounts;

              if (state is TokensLoaded) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      backgroundColor: Colors.deepPurple,
                      leading: const Icon(Icons.menu),
                      title: const Text("Solana Wallet"),
                      expandedHeight: 400,
                      flexibleSpace: FlexibleSpaceBar(
                        background: PageView.builder(
                          controller: _pageViewController,
                          onPageChanged: _handlePageViewChanged,
                          itemBuilder: (context, index) {
                            final LocalAccount account = localAccounts[index];

                            return Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(50),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            _getCumuativeUsd(
                                              state.getAccountTotalValueInUSD(
                                                account,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 25),
                                          Text(
                                            account.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      shortPubkey(
                                                        account.address,
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    const Icon(
                                                      Icons.copy,
                                                      size: 13,
                                                      color: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: PageIndicator(
                            tabController: _tabController,
                            currentPageIndex: _currentPageIndex,
                            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
                            isOnDesktopAndWeb: _isOnDesktopAndWeb,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.deepPurple[300],
                            child: TokenList(
                              tokens: state.getTokensByLocalAccount(
                                localAccounts[_currentPageIndex],
                              ),
                              tokenPrices: state.priceFeed,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.deepPurple[300],
                            height: 350,
                            child: CircularChart(
                              tokens: state.getTokensByLocalAccount(
                                localAccounts[_currentPageIndex],
                              ),
                              tokenPrices: state.priceFeed,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.deepPurple[300],
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.deepPurple[300],
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 0) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex - 1);
            },
            icon: const Icon(
              Icons.arrow_left_rounded,
              size: 32.0,
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.background,
            selectedColor: colorScheme.primary,
          ),
          IconButton(
            splashRadius: 16.0,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (currentPageIndex == 2) {
                return;
              }
              onUpdateCurrentPageIndex(currentPageIndex + 1);
            },
            icon: const Icon(
              Icons.arrow_right_rounded,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
