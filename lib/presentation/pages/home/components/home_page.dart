import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/constants/strings.dart';
import 'package:online_counsellor/core/components/widgets/custom_input.dart';
import 'package:online_counsellor/core/functions.dart';
import 'package:online_counsellor/presentation/widgets/category_card.dart';
import 'package:online_counsellor/presentation/widgets/counsellor_card.dart';
import 'package:online_counsellor/state/data_state.dart';
import 'package:online_counsellor/styles/styles.dart';

import '../../../../styles/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var counsellorList = ref.watch(
        filteredCounsellorsProvider(ref.watch(selectedCategoryProvider)));
    var sortedList = sortUsersByRating(counsellorList);
    return Container(
      color: primaryColor.withOpacity(0.1),
      child: SingleChildScrollView(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextFields(
            hintText: 'Search for a counsellor',
            focusNode: _focus,
            controller: _controller,
            suffixIcon: _focus.hasFocus
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        _focus.unfocus();
                      });
                    },
                    icon: Icon(MdiIcons.close, color: primaryColor))
                : Icon(MdiIcons.magnify, color: primaryColor),
            onChanged: (p0) =>
                ref.read(searchQueryProvider.notifier).state = p0,
          ),
        ),
        if (!_focus.hasFocus)
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: normalText(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: normalText(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            subtitle: SizedBox(
              height: 160,
              child: CarouselSlider(
                  items: counsellorTypeWithIcon
                      .map((e) => CategoryCard(category: e))
                      .toList(),
                  options: CarouselOptions(
                      height: 160,
                      viewportFraction: 0.6,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      onPageChanged: (index, reason) {
                        ref.read(selectedCategoryProvider.notifier).state =
                            counsellorTypeWithIcon[index]['name']!;
                      })),
            ),
          ),
        if (!_focus.hasFocus) const SizedBox(height: 5),
        if (!_focus.hasFocus)
          ListTile(
            title: Row(
              children: [
                Text('Rated',
                    style: normalText(
                        color: primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                const Icon(Icons.star, color: primaryColor, size: 25),
                const Icon(Icons.star, color: primaryColor, size: 25),
                const Icon(Icons.star, color: primaryColor, size: 25),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: normalText(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            subtitle: SizedBox(
              height: 215,
              child: sortedList.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CounsellorCard(user: sortedList[index]);
                      },
                      itemCount: sortedList.length)
                  : Center(
                      child: Text(
                        'No Counsellor Found',
                        style: normalText(),
                      ),
                    ),
            ),
          ),
        if (!_focus.hasFocus) const SizedBox(height: 5),
        if (!_focus.hasFocus)
          if (ref.watch(quotesProvider) != null &&
              ref.watch(quotesProvider)!.quote.isNotEmpty)
            Card(
                color: secondaryColor.withOpacity(0.5),
                margin: const EdgeInsets.all(10),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(children: [
                        const Icon(Icons.format_quote, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Quote of the Day',
                          style: normalText(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(Icons.format_quote, color: Colors.white),
                      ]),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(ref.watch(quotesProvider)!.quote,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: normalText()),
                          ),
                          const SizedBox(height: 10),
                          Text("- ${ref.watch(quotesProvider)!.author} -",
                              textAlign: TextAlign.center,
                              style: normalText(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ))),
        if (_focus.hasFocus) const SizedBox(height: 5),
        if (_focus.hasFocus)
          LayoutBuilder(builder: (context, constraint) {
            var newList = ref.watch(searchControllerProvider);
            var newSortedList = sortUsersByRating(newList);
            if (newSortedList.isNotEmpty) {
              return Wrap(
                children:
                    newSortedList.map((e) => CounsellorCard(user: e)).toList(),
              );
            } else {
              return Center(
                  child: Text('No Counsellor Found', style: normalText()));
            }
          }),
        if (!_focus.hasFocus)
          LayoutBuilder(builder: (context, constraints) {
            var newList = ref.watch(filteredCounsellorsProvider(''));
            return SizedBox(
              height: 215,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return CounsellorCard(user: newList[index]);
                  },
                  itemCount: newList.length > 10 ? 10 : newList.length),
            );
          }),
        const SizedBox(height: 15),
      ])),
    );
  }
}
