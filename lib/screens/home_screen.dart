import 'package:flutter/material.dart';
import 'package:testing/screens/positions_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Custom Header
          Container(
            width: double.infinity,
            height: screenSize.height * 0.3, // Adjust the height as needed
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: const Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 24,
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 24,
                  right: 24,
                  child: Text(
                    'Your voice matters. Let\'s make a difference today.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Optional: Add a user avatar or profile icon
                Positioned(
                  top: 40,
                  right: 24,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        AssetImage('assets/images/user_avatar.png'),
                    // If no image, you can use backgroundColor and display initials
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Content Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Example of content cards
                _buildFeatureCard(
                  context,
                  icon: Icons.how_to_vote,
                  title: 'Start Voting',
                  description: 'Participate in ongoing elections.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PositionsScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  icon: Icons.history,
                  title: 'Voting History',
                  description: 'Review your past votes.',
                  onTap: () {
                    // Navigate to history screen
                  },
                ),
                // Add more cards as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
