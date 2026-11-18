import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder Mini',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const KosListPage(),
    );
  }
}

class Kos {
  const Kos({
    required this.id,
    required this.name,
    required this.location,
    required this.monthlyPrice,
  });

  final String id;
  final String name;
  final String location;
  final String monthlyPrice;
}

const kosList = [
  Kos(
    id: 'melati',
    name: 'Kos Melati',
    location: 'Jl. Mawar, Bandung',
    monthlyPrice: 'Rp 1.200.000 / bulan',
  ),
  Kos(
    id: 'harmoni',
    name: 'Kos Harmoni',
    location: 'Jl. Dipatiukur, Bandung',
    monthlyPrice: 'Rp 1.500.000 / bulan',
  ),
  Kos(
    id: 'cempaka',
    name: 'Kos Cempaka',
    location: 'Jl. Gejayan, Yogyakarta',
    monthlyPrice: 'Rp 900.000 / bulan',
  ),
  Kos(
    id: 'tentrem',
    name: 'Kos Tentrem',
    location: 'Jl. Kaliurang, Yogyakarta',
    monthlyPrice: 'Rp 1.100.000 / bulan',
  ),
  Kos(
    id: 'pelangi',
    name: 'Kos Pelangi',
    location: 'Jl. Sukajadi, Bandung',
    monthlyPrice: 'Rp 1.300.000 / bulan',
  ),
  Kos(
    id: 'sejahtera',
    name: 'Kos Sejahtera',
    location: 'Jl. Seturan, Yogyakarta',
    monthlyPrice: 'Rp 850.000 / bulan',
  ),
];

class KosListPage extends StatefulWidget {
  const KosListPage({super.key});

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _favoriteKosIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Kos> get _filteredKos {
    final query = _searchQuery.trim().toLowerCase();
    return kosList
        .where((kos) => kos.name.toLowerCase().contains(query))
        .toList();
  }

  void _toggleFavorite(Kos kos) {
    setState(() {
      if (!_favoriteKosIds.add(kos.id)) {
        _favoriteKosIds.remove(kos.id);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredKos = _filteredKos;

    return Scaffold(
      appBar: AppBar(title: const Text('KosFinder Mini')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari nama kos',
                hintText: 'Contoh: Kos Melati',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ).copyWith(
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.clear),
                      ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredKos.isEmpty
                  ? const Center(child: Text('Kos tidak ditemukan'))
                  : ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: filteredKos.length,
                      itemBuilder: (context, index) {
                        final kos = filteredKos[index];
                        final isFavorite = _favoriteKosIds.contains(kos.id);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(kos.name),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(kos.location),
                                  Text(kos.monthlyPrice),
                                ],
                              ),
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              tooltip: isFavorite
                                  ? 'Hapus dari favorit'
                                  : 'Tambahkan ke favorit',
                              onPressed: () => _toggleFavorite(kos),
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
