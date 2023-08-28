import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raviar_crypto/Presentation/ui/ui_helper/HomePageView.dart';
import 'package:raviar_crypto/Presentation/ui/ui_helper/ThemeSwicher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/Models/CryptoModel.dart/CryptoData.dart';
import '../../data/data_source/ResponseModel.dart';
import '../../logic/providers/CryptoDataProvider.dart';
import '../helpers/decimalRounder.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageViewController = PageController(
    initialPage: 0,
  );

  final List<String> _choisesList = [
    'Top MarketCaps',
    'Top Gainers',
    'Top Losers'
  ];


  @override
  Widget build(BuildContext context) {
    final cryptoProvider = Provider.of<CryptoDataProvider>(context);

    var heigth = MediaQuery.of(context).size.height;

    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [ThemeSwitcher()],
        title: const Text(
          'Raviar Exchange',
          style: TextStyle(color: Colors.white),
        ),
        titleTextStyle: textTheme.titleLarge,
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 7.0,
                  left: 5,
                  right: 5,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: Stack(
                    children: [
                      HomePageView(controller: _pageViewController),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 6.0,
                          ),
                          child: SmoothPageIndicator(
                            controller: _pageViewController,
                            count: 4,
                            effect: const ExpandingDotsEffect(
                                dotWidth: 10,
                                dotHeight: 10,
                                dotColor: Color.fromARGB(255, 231, 181, 16),
                                activeDotColor:
                                    Color.fromARGB(255, 231, 107, 6)),
                            onDotClicked: (index) =>
                                _pageViewController.animateToPage(index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                width: double.infinity,
                child: Marquee(
                  text:
                      "🔊جایی مطمعن برای سرمابه های شما در اپلیکیشن صرافی راویار",
                  style: textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: const EdgeInsets.all(20),
                            // ignore: deprecated_member_use
                            primary: Colors.green[700]),
                        child: const Text('buy'),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: const EdgeInsets.all(20),
                            // ignore: deprecated_member_use
                            primary: Colors.red[700]),
                        child: const Text('sell'),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 7, left: 7),
                child: Row(
                  children: [
                    Consumer<CryptoDataProvider>(
                      builder: (context, CyptoDataProvider, child) {
                        return Wrap(
                          spacing: 8,
                          children: List.generate(
                            _choisesList.length,
                            (index) {
                              return ChoiceChip(
                                label: Text(
                                  _choisesList[index],
                                  style: textTheme.titleSmall,
                                ),
                                selected:
                                    cryptoProvider.defaultChoiceIndex == index,
                                selectedColor: Colors.blue,
                                onSelected: (Value) {
                                  switch (index) {
                                    case 0:
                                      cryptoProvider.getTopMarketCapData();
                                      break;
                                    case 1:
                                      cryptoProvider.getTopGainersData();
                                      break;
                                    case 2:
                                      cryptoProvider.getTopLosersData();
                                      break;
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 25, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' #',
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      'Name            ',
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      'Last 7d          ',
                      style: textTheme.bodySmall,
                    ),
                    Text(
                      'Price',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 500,
                child: Consumer<CryptoDataProvider>(
                  builder: (context, CryptoDataProvider, child) {
                    switch (CryptoDataProvider.state.status) {
                      case Status.LOADING:
                        return SizedBox(
                          height: 80,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.white,
                            child: ListView.builder(
                              itemCount: 50,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.0, bottom: 8, left: 8),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 15,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: SizedBox(
                                                width: 50,
                                                height: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: SizedBox(
                                        width: 70,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 15,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: SizedBox(
                                                width: 25,
                                                height: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        );

                      case Status.COMPLETED:
                        List<CryptoData>? model = CryptoDataProvider
                            .dataFuture.data!.cryptoCurrencyList;

                        return ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              var number = index + 1;
                              var tokenId = model![index].id;

                              MaterialColor filterColor =
                                  DecimalRounder.setColorFilter(
                                      model[index].quotes![0].percentChange24h);

                              var finalPrice =
                                  DecimalRounder.removePriceDecimals(
                                      model[index].quotes![0].price);
                              Color precentColor =
                                  DecimalRounder.setPercentChangesColor(
                                      model[index].quotes![0].percentChange24h);
                              Icon precentIcon =
                                  DecimalRounder.setPercentChangesIcon(
                                      model[index].quotes![0].percentChange24h);
                              var percentChange =
                                  DecimalRounder.removePercentDecimals(
                                      model[index].quotes![0].percentChange24h);

                              return SizedBox(
                                height: heigth * 0.075,
                                child: Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      number.toString(),
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 15),
                                    child: CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      height: 32,
                                      width: 32,
                                      imageUrl:
                                          "https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png",
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model[index].name!,
                                          style: textTheme.bodySmall,
                                        ),
                                        Text(
                                          model[index].symbol!,
                                          style: textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          filterColor, BlendMode.srcATop),
                                      child: SvgPicture.network(
                                          "https://s3.coinmarketcap.com/generated/sparklines/web/7d/2781/$tokenId.svg"),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "\$$finalPrice",
                                          style: textTheme.bodySmall,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            precentIcon,
                                            Text(
                                              percentChange + "%",
                                              style: GoogleFonts.ubuntu(
                                                  color: precentColor,
                                                  fontSize: 13),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                                ]),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: 50);

                      case Status.ERROR:
                        return Text(CryptoDataProvider.state.message);

                      default:
                        return Container();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
