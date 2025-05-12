import 'package:flutter/material.dart';

class StressModulesScreen extends StatefulWidget {
  const StressModulesScreen({super.key});

  @override
  State<StressModulesScreen> createState() => _StressModulesScreenState();
}

class _StressModulesScreenState extends State<StressModulesScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Popular', 'Recent', 'Difficulty'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterChips(),
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 18),
            _sectionTitle('Breathing Exercises'),
            _moduleGrid([
              _moduleCard('https://picsum.photos/200/300', 'Deep Breathing',
                  'Slow, deep breaths to calm your nervous system', 0.75),
              _moduleCard('https://picsum.photos/200/301', 'Box Breathing',
                  'Equal inhale, hold, exhale pattern', 0.3),
              _moduleCard('https://picsum.photos/200/302', '4-7-8 Technique',
                  'Timed breathing for relaxation', null,
                  isNew: true),
            ]),
            const SizedBox(height: 18),
            _sectionTitle('Meditation'),
            _moduleGrid([
              _moduleCard('https://picsum.photos/200/303', 'Guided Meditation',
                  'Voice-guided relaxation sessions', 0.5),
              _moduleCard('https://picsum.photos/200/304', 'Mindfulness',
                  'Present-moment awareness practice', 0.25),
              _moduleCard('https://picsum.photos/200/305', 'Body Scan',
                  'Systematic relaxation technique', null,
                  isNew: true),
            ]),
            const SizedBox(height: 18),
            _sectionTitle('Physical Activities'),
            _moduleGrid([
              _moduleCard('https://picsum.photos/200/306', 'Stretching',
                  'Gentle stretches for tension relief', 0.6),
              _moduleCard('https://picsum.photos/200/307', 'Muscle Relaxation',
                  'Tense and release muscle groups', 0.4),
              _moduleCard('https://picsum.photos/200/308', 'Quick Exercises',
                  'Short activities for busy days', 0.15),
            ]),
            const SizedBox(height: 18),
            _sectionTitle('Sleep Improvement'),
            _moduleGrid([
              _moduleCard('https://picsum.photos/200/309', 'Bedtime Routine',
                  'Establish healthy sleep habits', 0.2),
              _moduleCard('https://picsum.photos/200/310', 'Sleep Meditation',
                  'Guided relaxation for better sleep', null,
                  isNew: true),
              _moduleCard(
                  'https://picsum.photos/200/311',
                  'Relaxation Techniques',
                  'Methods to calm mind before sleep',
                  0.35),
            ]),
            const SizedBox(height: 18),
            _sectionTitle('Stress Education'),
            _moduleGrid([
              _moduleCard(
                  'https://picsum.photos/200/312',
                  'Understanding Stress',
                  'Learn how stress affects your body',
                  0.8),
              _moduleCard('https://picsum.photos/200/313', 'Coping Strategies',
                  'Effective ways to handle stress', 0.45),
              _moduleCard('https://picsum.photos/200/314', 'Stress Triggers',
                  'Identify your personal stressors', 0.1),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final selected = _selectedFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(_filters[index]),
              selected: selected,
              onSelected: (_) {
                setState(() => _selectedFilter = index);
              },
              selectedColor: const Color(0xFF7B61FF),
              backgroundColor: const Color(0xFFF3F1FF),
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search modules',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF7B61FF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _moduleGrid(List<Widget> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards
              .map((card) => SizedBox(
                    width: (constraints.maxWidth - 12) /
                        2, // 2 cards per row with spacing
                    child: card,
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _moduleCard(
      String imagePath, String title, String subtitle, double? progress,
      {bool isNew = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(title),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.white,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imagePath,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 50),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (progress != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFFF3F1FF),
                            valueColor:
                                const AlwaysStoppedAnimation(Color(0xFF7B61FF)),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(progress * 100).toInt()}% completed',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7B61FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement module start functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B61FF),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Module',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 30),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (progress != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFF3F1FF),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF7B61FF)),
                    minHeight: 5,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7B61FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else if (isNew)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B61FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF7B61FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
