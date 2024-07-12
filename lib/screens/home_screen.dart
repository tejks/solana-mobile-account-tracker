import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/cubit/tokens_cubit.dart';
import 'package:solana_mobile_account_tracker/models/local_account.dart';
import 'package:solana_mobile_account_tracker/screens/add_account.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.diamond,
                          size: 100,
                          color: Color.fromARGB(255, 133, 5, 172),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Solana Tracker',
                          style: TextStyle(
                            color: Color.fromARGB(255, 133, 5, 172),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...(context.read<AccountsCubit>().state as AccountsLoaded)
                      .accounts
                      .map(
                        (account) => ListTile(
                          title: Text(account.name),
                          onTap: () {
                            _updateCurrentPageIndex(
                              (context.read<AccountsCubit>().state
                                      as AccountsLoaded)
                                  .accounts
                                  .indexOf(account),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                ],
              ),
            ),
            // Plus add account button
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 161, 58, 175),
              Color.fromARGB(255, 15, 45, 90),
            ],
          ),
        ),
        child: BlocBuilder<TokensCubit, TokensState>(
          builder: (context, state) {
            final localAccounts =
                (context.read<AccountsCubit>().state as AccountsLoaded)
                    .accounts;

            if (state is TokensLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 200,
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddAccountScreen2(),
                            ),
                          );
                        },
                      ),
                    ],
                    leading: IconButton(
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: PageView.builder(
                        controller: _pageViewController,
                        onPageChanged: _handlePageViewChanged,
                        itemCount: localAccounts.length,
                        itemBuilder: (context, index) {
                          final LocalAccount account = localAccounts[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                account.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 229, 208, 230),
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
                                  color: Color.fromARGB(255, 254, 231, 255),
                                ),
                              ),
                              const SizedBox(height: 20),
                              account is! AllAccounts
                                  ? GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            196,
                                            196,
                                            196,
                                          ).withOpacity(0.6),
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
                                                  fontSize: 10,
                                                  color: Color.fromARGB(
                                                      255, 27, 27, 27),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.copy,
                                                size: 12,
                                                color: Color.fromARGB(
                                                  255,
                                                  27,
                                                  27,
                                                  27,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: account.address,
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Address copied to clipboard',
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 60,
                      ),
                      child: Center(
                        child: localAccounts.length > 1
                            ? SmoothPageIndicator(
                                controller: _pageViewController,
                                count: localAccounts.length,
                                effect: const ScrollingDotsEffect(
                                  spacing: 7,
                                  dotHeight: 5,
                                  dotWidth: 5,
                                  activeDotColor:
                                      Color.fromARGB(220, 223, 223, 223),
                                  dotColor: Color.fromARGB(185, 61, 61, 61),
                                ),
                              )
                            : const SizedBox(
                                height: 10,
                              ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TokenList(
                              tokens: state.getTokensByLocalAccount(
                                localAccounts[_currentPageIndex],
                              ),
                              tokenPrices: state.priceFeed,
                            ),
                            const SizedBox(height: 20),
                            Column(
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
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
                            const SizedBox(height: 20),
                          ],
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
    );
  }
}
