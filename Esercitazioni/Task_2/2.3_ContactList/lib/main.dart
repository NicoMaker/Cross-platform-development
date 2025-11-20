import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class Person {
  String firstName;
  String lastName;
  List<String> phones;

  Person({
    required this.firstName,
    required this.lastName,
    required this.phones,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return (f + l).toUpperCase();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Person> contacts = [
    Person(
      firstName: 'Mario',
      lastName: 'Rossi',
      phones: ['3331112233'],
    ),
    Person(
      firstName: 'Laura',
      lastName: 'Bianchi',
      phones: ['3384455667'],
    ),
    Person(
      firstName: 'Giovanni',
      lastName: 'Verdi',
      phones: ['3409988776'],
    ),
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossibile effettuare la chiamata')),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Contatto da app&body=Ciao, ti sto contattando dalla mia app.',
    );
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossibile aprire il client email')),
      );
    }
  }

  Future<void> _shareContact(Person person) async {
    final phones = person.phones.join(', ');
    final text = 'Contatto: ${person.fullName}\nTelefoni: $phones';
    await Share.share(text, subject: 'Dettagli contatto');
  }

  void _editContact(Person person, int index) {
    final firstController = TextEditingController(text: person.firstName);
    final lastController = TextEditingController(text: person.lastName);
    final phoneController = TextEditingController(
      text: person.phones.isNotEmpty ? person.phones.first : '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifica contatto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastController,
                  decoration: const InputDecoration(labelText: 'Cognome'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefono (solo cifre, max 10)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                if (firstController.text.isEmpty ||
                    lastController.text.isEmpty ||
                    phoneController.text.isEmpty) return;

                final cleanPhone =
                    phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleanPhone.length != 10) return;

                setState(() {
                  contacts[index].firstName = firstController.text;
                  contacts[index].lastName = lastController.text;
                  contacts[index].phones = [cleanPhone];
                });
                Navigator.pop(context);
              },
              child: const Text('Salva'),
            ),
          ],
        );
      },
    );
  }

  void _addContact() {
    final firstController = TextEditingController();
    final lastController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuovo contatto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: lastController,
                  decoration: const InputDecoration(labelText: 'Cognome'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Telefono (solo cifre, max 10)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                if (firstController.text.isEmpty ||
                    lastController.text.isEmpty ||
                    phoneController.text.isEmpty) return;

                final cleanPhone =
                    phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleanPhone.length != 10) return;

                setState(() {
                  contacts.add(
                    Person(
                      firstName: firstController.text,
                      lastName: lastController.text,
                      phones: [cleanPhone],
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Crea'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void _showContactDetails(Person person, int index) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  person.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: person.phones
                      .map(
                        (phone) => ListTile(
                          leading: const Icon(Icons.phone),
                          title: Text(phone),
                          onTap: () => _makePhoneCall(phone),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Email di esempio',
                      icon: const Icon(Icons.email_outlined),
                      onPressed: () => _sendEmail('esempio@mail.com'),
                    ),
                    IconButton(
                      tooltip: 'Modifica',
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pop(context);
                        _editContact(person, index);
                      },
                    ),
                    IconButton(
                      tooltip: 'Condividi',
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareContact(person),
                    ),
                    IconButton(
                      tooltip: 'Elimina',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteContact(index);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      body: contacts.isEmpty
          ? const Center(child: Text('Nessun contatto'))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final person = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(person.initials),
                  ),
                  title: Text(person.fullName),
                  subtitle: Text(person.phones.join(' • ')),
                  onTap: () => _showContactDetails(person, index),
                  trailing: IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () {
                      if (person.phones.length == 1) {
                        _makePhoneCall(person.phones.first);
                      } else {
                        _showContactDetails(person, index);
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}
