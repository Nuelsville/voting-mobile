import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/candidate.dart';
import '../services/api_service.dart';
import '../widgets/full_screen_image_page.dart';
import 'sign_in_screen.dart';

class CandidatesScreen extends StatefulWidget {
  final int positionId;

  // positionId is passed from PositionsScreen to know which candidates to load
  CandidatesScreen({required this.positionId});

  @override
  _CandidatesScreenState createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  List<Candidate> _candidates = [];
  bool _isLoading = false;
  String? _errorMessage;
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  // Fetch candidates for the given position
  Future<void> _fetchCandidates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _candidates = await _apiService.fetchCandidates(widget.positionId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Vote for a selected candidate
  void _voteForCandidate(int candidateId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.submitVote(candidateId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vote submitted successfully')),
      );
    } on UnauthorizedException catch (e) {
      // Handle token invalid scenario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session expired. Please log in again.')),
      );

      // Clear token and navigate to SignIn screen
      await _storage.delete(key: 'auth_token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      // Other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidates'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : ListView.builder(
                  itemCount: _candidates.length,
                  itemBuilder: (context, index) {
                    Candidate candidate = _candidates[index];
                    final heroTag = 'candidate-photo-${candidate.id}';

                    return ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          if (candidate.photo != null &&
                              candidate.photo!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: candidate.photo!,
                                  heroTag: heroTag,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No photo available.')),
                            );
                          }
                        },
                        child: Hero(
                          tag: heroTag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: candidate.photo ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: Icon(Icons.person, color: Colors.grey),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                          '${candidate.title} ${candidate.firstName} ${candidate.lastName}'),
                      subtitle: Text(candidate.position.name),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // When user presses vote, call _voteForCandidate
                          _voteForCandidate(candidate.id);
                        },
                        child: Text('Vote'),
                      ),
                    );
                  },
                ),
    );
  }
}
