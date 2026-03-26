import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../viewmodels/widgets_viewmodel.dart';

class WidgetsTab extends ConsumerWidget {
  const WidgetsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final switchValue = ref.watch(switchProvider);
    final sliderValue = ref.watch(sliderProvider);
    final checkboxValue = ref.watch(checkboxProvider);
    final radioValue = ref.watch(radioProvider);

    String tr(String key) => AppLocalizations.of(context).translate(key);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          tr('widgets_title'),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        Text(tr('buttons'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text')),
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
          ],
        ),
        const SizedBox(height: 20),

        Text(tr('switches'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Switch'),
          value: switchValue,
          onChanged: (value) => ref.read(switchProvider.notifier).state = value,
        ),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: checkboxValue,
          onChanged: (value) => ref.read(checkboxProvider.notifier).state = value ?? false,
        ),
        const SizedBox(height: 20),

        Text(tr('radio'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        RadioGroup<int>(
          groupValue: radioValue,
          onChanged: (value) => ref.read(radioProvider.notifier).state = value!,
          child: Column(
            children: [
              RadioListTile(
                title: Text('${tr('option')} 1'),
                value: 1,
              ),
              RadioListTile(
                title: Text('${tr('option')} 2'),
                value: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(tr('slider'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Slider(
          value: sliderValue,
          min: 0,
          max: 100,
          divisions: 10,
          label: sliderValue.round().toString(),
          onChanged: (value) => ref.read(sliderProvider.notifier).state = value,
        ),
        const SizedBox(height: 20),

        Text(tr('cards'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Card Widget',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(tr('card_description')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(tr('list_tiles'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: Text(tr('home')),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(tr('settings')),
                subtitle: Text(tr('settings_subtitle')),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(tr('about')),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(tr('chips'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Wrap(
          spacing: 8,
          children: [
            Chip(avatar: CircleAvatar(child: Text('A')), label: Text('Chip 1')),
            Chip(avatar: Icon(Icons.star, size: 18), label: Text('Chip 2')),
            Chip(label: Text('Chip 3'), deleteIcon: Icon(Icons.close, size: 18), onDeleted: null),
          ],
        ),
      ],
    );
  }
}
