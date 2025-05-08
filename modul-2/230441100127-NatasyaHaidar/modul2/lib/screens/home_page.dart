import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_page.dart';
import 'add_wisata_page.dart';
import '../widgets/place_card.dart';
import '../widgets/hotel_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> hotPlaces = [];
  final List<Map<String, dynamic>> bestHotels = [];

  @override
  void initState() {
    super.initState();

    hotPlaces.addAll([
      {
        'title': 'National Park Yosemite',
        'location': 'California',
        'image': 'assets/yosemite.jpg',
        'description': 'Lorem ipsum est donec non interdum amet phasellus egestas id dignissim in vestibulum augue ut a lectus rhoncus sed ullamcorper at vestibulum sed mus neque amet turpis placerat in luctus at eget egestas praesent congue semper in facilisis purus dis pharetra odio ullamcorper euismod a donec consectetur pellentesque pretium sapien proin tincidunt non augue turpis massa euismod quis lorem et feugiat ornare id cras sed eget adipiscing dolor urna mi sit a a auctor mattis urna fermentum facilisi sed aliquet odio at suspendisse posuere tellus pellentesque id quis libero fames blandit ullamcorper interdum eget placerat tortor cras nulla consectetur et duis viverra mattis libero scelerisque gravida egestas blandit tincidunt ullamcorper auctor aliquam leo urna adipiscing est ut ipsum consectetur id erat semper fames elementum rhoncus quis varius pellentesque quam neque vitae sit velit leo massa habitant tellus velit pellentesque cursus laoreet donec etiam id vulputate nisi integer eget gravida volutpat.',
        'jenis': 'Wisata Alam',
        'harga': '30.000,00',
      },
      {
        'title': 'National Park Yosemite',
        'location': 'California',
        'image': 'assets/yosemite.jpg',
        'description': 'Lorem ipsum est donec non interdum amet phasellus egestas id dignissim in vestibulum augue ut a lectus rhoncus sed ullamcorper at vestibulum sed mus neque amet turpis placerat in luctus at eget egestas praesent congue semper in facilisis purus dis pharetra odio ullamcorper euismod a donec consectetur pellentesque pretium sapien proin tincidunt non augue turpis massa euismod quis lorem et feugiat ornare id cras sed eget adipiscing dolor urna mi sit a a auctor mattis urna fermentum facilisi sed aliquet odio at suspendisse posuere tellus pellentesque id quis libero fames blandit ullamcorper interdum eget placerat tortor cras nulla consectetur et duis viverra mattis libero scelerisque gravida egestas blandit tincidunt ullamcorper auctor aliquam leo urna adipiscing est ut ipsum consectetur id erat semper fames elementum rhoncus quis varius pellentesque quam neque vitae sit velit leo massa habitant tellus velit pellentesque cursus laoreet donec etiam id vulputate nisi integer eget gravida volutpat.',
        'jenis': 'Wisata Alam',
        'harga': '30.000,00',
      },
    ]);

    bestHotels.addAll([
      {
        'title': 'National Park Yosemite',
        'image': 'assets/yosemite.jpg',
        'description': 'Lorem ipsum...',
      },
      {
        'title': 'National Park Yosemite',
        'image': 'assets/yosemite.jpg',
        'description': 'Lorem ipsum...',
      },
    ]);
  }

  Future<void> _navigateToAddWisataPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddWisataPage()),
    );

    if (result != null && result is Map) {
      setState(() {
        hotPlaces.insert(0, {
          'title': result['nama'],
          'location': result['lokasi'],
          'image': result['image'],
          'description': result['deskripsi'],
          'jenis': result['jenis'],
          'harga': result['harga'],
        });

        bestHotels.insert(0, {
          'title': result['nama'],
          'image': result['image'],
          'description': result['deskripsi'],
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wisata baru berhasil ditambahkan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.arrow_back, size: 24, color: Colors.grey),
            Icon(Icons.circle_outlined, size: 24, color: Colors.grey),
            Icon(Icons.crop_square, size: 24, color: Colors.grey),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('9.41', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        Row(
                          children: const [
                            Icon(Icons.signal_cellular_alt, size: 18),
                            SizedBox(width: 4),
                            Icon(Icons.wifi, size: 18),
                            SizedBox(width: 4),
                            Icon(Icons.battery_full, size: 18),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Hi, User", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 6),
                                const Text("👋", style: TextStyle(fontSize: 22)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text("Let’s Discover", style: GoogleFonts.poppins(color: Colors.grey)),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.greenAccent, width: 2),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage('assets/aku.jpg'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hot Places", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("See All", style: GoogleFonts.poppins(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotPlaces.length,
                        itemBuilder: (context, index) {
                          final place = hotPlaces[index];
                          return PlaceCard(
                            image: place['image'],
                            title: place['title'],
                            location: place['location'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(
                                    title: place['title'],
                                    imagePath: place['image'] ?? '',
                                    description: place['description'],
                                    jenisWisata: place['jenis'] ?? '',
                                    lokasi: place['location'] ?? '',
                                    harga: place['harga'] ?? '',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Best Hotels", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("See All", style: GoogleFonts.poppins(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      itemCount: bestHotels.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final hotel = bestHotels[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: HotelCard(
                            image: hotel['image'],
                            title: hotel['title'],
                            description: hotel['description'],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 70,
            child: GestureDetector(
              onTap: _navigateToAddWisataPage,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
