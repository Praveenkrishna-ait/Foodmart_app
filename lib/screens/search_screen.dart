import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Smart suggestions tags
  final List<String> _suggestions = [
    'Milk',
    'Banana',
    'Strawberry',
    'Bread',
    'Chips',
    'Butter',
    'Juice',
  ];

  List<Product> _getFilteredProducts() {
    if (_searchQuery.trim().isEmpty) {
      return [];
    }
    return CartProvider.catalog.where((product) {
      final name = product.name.toLowerCase();
      final category = product.category.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || category.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredProducts();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CustomSearchBar(
            readOnly: false,
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If query is empty, show beautiful suggestions list
          if (_searchQuery.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                'Popular Searches',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 10,
                children: _suggestions.map((suggestion) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = suggestion;
                      setState(() {
                        _searchQuery = suggestion;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: AppTheme.softShadow,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            size: 14,
                            color: AppTheme.primaryOrange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            suggestion,
                            style: const TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Spacer(),
            // Cute animated empty bag vector mock
            Center(
              child: Opacity(
                opacity: 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🔍',
                      style: TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Find your favorite products instantly',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 2),
          ] else ...[
            // Query results section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Search Results for "$_searchQuery"',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '🧐',
                              style: TextStyle(fontSize: 64),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No products match your search',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Double check your spelling or try searching for generic terms like "milk" or "bread"',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: filtered[index]);
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
