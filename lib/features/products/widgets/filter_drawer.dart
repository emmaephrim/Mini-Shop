import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/products/controllers/filter_provider.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  const FilterDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends ConsumerState<FilterDrawer> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(filterControllerProvider);
    _currentRange = RangeValues(currentFilter.minPrice, currentFilter.maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Price Range',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            RangeSlider(
              values: _currentRange,
              min: 0,
              max: 10000,
              divisions: 50,
              labels: RangeLabels(
                '\$${_currentRange.start.round()}',
                '\$${_currentRange.end.round()}',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRange = values;
                });
              },
            ),

            const Spacer(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(filterControllerProvider.notifier).reset();
                        Navigator.of(context).pop();
                      },
                      child: Text('Reset'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ref
                            .read(filterControllerProvider.notifier)
                            .setPriceRange(
                              _currentRange.start,
                              _currentRange.end,
                            );
                        Navigator.pop(context);
                      },
                      child: Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
