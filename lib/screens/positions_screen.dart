import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/screens/candidates_screen.dart';
import '../providers/position_provider.dart';
import '../models/position.dart';
// import 'candidates_screen.dart';

class PositionsScreen extends StatefulWidget {
  @override
  _PositionsScreenState createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PositionProvider>(context, listen: false).fetchPositions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Positions'),
      ),
      body: Consumer<PositionProvider>(
        builder: (context, positionProvider, _) {
          if (positionProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (positionProvider.errorMessage != null) {
            return Center(
                child: Text('Error: ${positionProvider.errorMessage}'));
          } else if (positionProvider.positions.isEmpty) {
            return Center(child: Text('No positions available.'));
          } else {
            return ListView.builder(
              itemCount: positionProvider.positions.length,
              itemBuilder: (context, index) {
                Position position = positionProvider.positions[index];
                return ListTile(
                  title: Text(position.name),
                  subtitle: Text(position.name),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to candidates screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CandidatesScreen(positionId: position.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
