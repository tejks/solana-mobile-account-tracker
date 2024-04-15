import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  String _getCumuativeUsd(double cumuativeUsd) =>
      '${cumuativeUsd.toStringAsFixed(2)} \$'.replaceFirst('.', ',');

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
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
                      backgroundColor: Colors.transparent,
                      leading: const Icon(Icons.menu, color: Colors.black),
                      title: const Text("Solana Wallet"),
                      expandedHeight: 400,
                      flexibleSpace: FlexibleSpaceBar(
                        background: PageView.builder(
                          controller: _pageViewController,
                          onPageChanged: _handlePageViewChanged,
                          itemBuilder: (context, index) {
                            final LocalAccount account = localAccounts[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  account.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _getCumuativeUsd(
                                    state.getAccountTotalValueInUSD(
                                      account,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 35,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                account is! AllAccounts
                                    ? GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  shortPubkey(
                                                    account.address,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 12,
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
                                      )
                                    : const SizedBox(),
                                // const SizedBox(height: 100),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: localAccounts.length > 1
                            ? SmoothPageIndicator(
                                controller: _pageViewController,
                                count: localAccounts.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 6,
                                  dotWidth: 6,
                                  activeDotColor: Colors.green,
                                  dotColor: Colors.grey[300]!,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              splashRadius: 16.0,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (_currentPageIndex == 0) {
                                  return;
                                }
                                _updateCurrentPageIndex(_currentPageIndex - 1);
                              },
                              icon: const Icon(
                                Icons.arrow_left_rounded,
                                size: 32.0,
                              ),
                            ),
                            IconButton(
                              splashRadius: 16.0,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (_currentPageIndex == 2) {
                                  return;
                                }
                                _updateCurrentPageIndex(_currentPageIndex + 1);
                              },
                              icon: const Icon(
                                Icons.arrow_right_rounded,
                                size: 32.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        child: TokenList(
                          tokens: state.getTokensByLocalAccount(
                            localAccounts[_currentPageIndex],
                          ),
                          tokenPrices: state.priceFeed,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 5,
                                top: 3,
                                bottom: 7,
                              ),
                              child: Text(
                                'Statistics',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: state
                                      .getStableTokensByLocalAccount(
                                        localAccounts[_currentPageIndex],
                                      )
                                      .isNotEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircularChart(
                                          tokens: state.getTokensByLocalAccount(
                                            localAccounts[_currentPageIndex],
                                          ),
                                          tokenPrices: state.priceFeed,
                                        ),
                                        CircularChart(
                                          tokens: state
                                              .getStableTokensByLocalAccount(
                                            localAccounts[_currentPageIndex],
                                          ),
                                          tokenPrices: state.priceFeed,
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: CircularChart(
                                        tokens: state.getTokensByLocalAccount(
                                          localAccounts[_currentPageIndex],
                                        ),
                                        tokenPrices: state.priceFeed,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 30,
                    //       vertical: 20,
                    //     ),
                    //     child: Container(
                    //       height: 200,
                    //       decoration: const BoxDecoration(
                    //         borderRadius: BorderRadius.all(Radius.circular(20)),
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black12,
                    //             blurRadius: 10,
                    //             offset: Offset(0, 4),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SliverToBoxAdapter(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(20),
                    //       child: Container(
                    //         color: Colors.deepPurple[300],
                    //         height: 200,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
