import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_color_scheme/image_color_scheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image ColorScheme Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ExampleListPage(),
    );
  }
}

class ExampleListPage extends StatelessWidget {
  const ExampleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image ColorScheme Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ExampleCard(
            title: 'Network Image',
            description: 'Extract colors from a network image URL',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NetworkImageExample()),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            title: 'Memory Image',
            description: 'Extract colors from generated image bytes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MemoryImageExample()),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            title: 'Multiple Images',
            description: 'Switch between different images',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MultipleImagesExample()),
            ),
          ),
          const SizedBox(height: 16),
          _ExampleCard(
            title: 'Profile Card',
            description: 'Realistic profile card UI',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileCardExample()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

// Example 1: Network Image
class NetworkImageExample extends StatelessWidget {
  const NetworkImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a placeholder image service
    const imageUrl = 'https://picsum.photos/seed/flutter/400/400';

    return ImageColorSchemeBuilder(
      provider: const NetworkImage(imageUrl),
      builder: (context, colorScheme) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Network Image'),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ColorInfo('Primary', colorScheme.primary),
                      _ColorInfo('Secondary', colorScheme.secondary),
                      _ColorInfo('Tertiary', colorScheme.tertiary),
                      _ColorInfo('Surface', colorScheme.surface),
                      _ColorInfo(
                        'Primary Container',
                        colorScheme.primaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Example 2: Memory Image
class MemoryImageExample extends StatefulWidget {
  const MemoryImageExample({super.key});

  @override
  State<MemoryImageExample> createState() => _MemoryImageExampleState();
}

class _MemoryImageExampleState extends State<MemoryImageExample> {
  Uint8List? _imageBytes;
  Color _currentColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _generateImage();
  }

  Future<void> _generateImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..color = _currentColor;

    // Draw a simple gradient
    final rect = ui.Rect.fromLTWH(0, 0, 200, 200);
    final gradient = ui.Gradient.linear(
      ui.Offset.zero,
      const ui.Offset(200, 200),
      [_currentColor, _currentColor.withOpacity(0.3)],
    );
    paint.shader = gradient;
    canvas.drawRect(rect, paint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(200, 200);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (mounted) {
      setState(() {
        _imageBytes = byteData!.buffer.asUint8List();
      });
    }
  }

  void _changeColor() {
    final colors = <Color>[
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    setState(() {
      _currentColor =
          colors[(colors.indexOf(_currentColor) + 1) % colors.length];
    });
    _generateImage();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageBytes == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Memory Image')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ImageColorSchemeBuilder(
      provider: MemoryImage(_imageBytes!),
      builder: (context, colorScheme) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: const Text('Memory Image'),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _changeColor,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Change Color'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'The ColorScheme updates automatically when the image changes!',
                      style: TextStyle(color: colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Example 3: Multiple Images
class MultipleImagesExample extends StatefulWidget {
  const MultipleImagesExample({super.key});

  @override
  State<MultipleImagesExample> createState() => _MultipleImagesExampleState();
}

class _MultipleImagesExampleState extends State<MultipleImagesExample> {
  int _currentIndex = 0;

  final List<String> _imageUrls = [
    'https://picsum.photos/seed/red/400/400',
    'https://picsum.photos/seed/blue/400/400',
    'https://picsum.photos/seed/green/400/400',
  ];

  @override
  Widget build(BuildContext context) {
    return ImageColorSchemeBuilder(
      provider: NetworkImage(_imageUrls[_currentIndex]),
      builder: (context, colorScheme) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: const Text('Multiple Images'),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  colorScheme.primary.withOpacity(0.3),
                  colorScheme.secondary.withOpacity(0.2),
                  colorScheme.surface,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      _imageUrls[_currentIndex],
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _imageUrls.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: CircleAvatar(
                          radius: _currentIndex == index ? 6 : 4,
                          backgroundColor: _currentIndex == index
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentIndex = (_currentIndex + 1) % _imageUrls.length;
                      });
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next Image'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Example 4: Profile Card
class ProfileCardExample extends StatelessWidget {
  const ProfileCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    const imageUrl = 'https://picsum.photos/seed/profile/400/400';

    return ImageColorSchemeBuilder(
      provider: const NetworkImage(imageUrl),
      builder: (context, colorScheme) {
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Gradient background
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topCenter,
                              radius: 1.5,
                              colors: [
                                colorScheme.primary,
                                colorScheme.secondary,
                                colorScheme.surface,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                colorScheme.surface.withOpacity(0.2),
                                colorScheme.surface,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Profile picture
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.surface,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: const NetworkImage(imageUrl),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'John Doe',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '@johndoe',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(
                                        0.7,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatCard(
                            label: 'Posts',
                            value: '42',
                            colorScheme: colorScheme,
                          ),
                          _StatCard(
                            label: 'Followers',
                            value: '1.2K',
                            colorScheme: colorScheme,
                          ),
                          _StatCard(
                            label: 'Following',
                            value: '324',
                            colorScheme: colorScheme,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Flutter enthusiast and Material Design lover. Building beautiful apps with dynamic colors!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: const Text('Follow'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.outline),
                            foregroundColor: colorScheme.onSurface,
                          ),
                          child: const Text('Message'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _StatCard({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorInfo extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorInfo(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
