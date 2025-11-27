import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme_provider.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final themeState = ref.watch(themeProvider);
  
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Tema', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Modalità Scura'),
            value: themeState.isDarkMode,
            onChanged: (value) {
            
              themeNotifier.toggleDarkMode(value);
            },
          ),
          
          const Divider(height: 40),

          const Text('Colore Principale', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          
      
          RadioListTile<Color>(
            title: const Text('Blu'),
            value: Colors.blue,
            groupValue: themeState.selectedColor,
            onChanged: (Color? value) {
              if (value != null) themeNotifier.changeColor(value);
            },
          ),
          
      
          RadioListTile<Color>(
            title: const Text('Verde'),
            value: Colors.green,
            groupValue: themeState.selectedColor,
            onChanged: (Color? value) {
              if (value != null) themeNotifier.changeColor(value);
            },
          ),

  
          RadioListTile<Color>(
            title: const Text('Viola'),
            value: Colors.purple,
            groupValue: themeState.selectedColor,
            onChanged: (Color? value) {
              if (value != null) themeNotifier.changeColor(value);
            },
          ),

          const SizedBox(height: 20),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeState.selectedColor, 
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              themeNotifier.setRandomColor();
            },
            child: const Text('Colore Casuale'),
          ),
        ],
      ),
    );
  }
}