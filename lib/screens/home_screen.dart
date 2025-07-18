import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridezo_project/models/ride_model.dart';
import 'package:ridezo_project/services/ride_service.dart';
import 'package:ridezo_project/screens/authentication_screens/signin_screen.dart';
import 'package:ridezo_project/widgets/create_ride_dialog.dart';
import 'package:ridezo_project/widgets/ride_list_item.dart';
import 'package:ridezo_project/widgets/ride_option_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RideShareHomeScreen extends StatefulWidget {
  const RideShareHomeScreen({Key? key}) : super(key: key);

  @override
  _RideShareHomeScreenState createState() => _RideShareHomeScreenState();
}

class _RideShareHomeScreenState extends State<RideShareHomeScreen> {
  final RideService _rideService = RideService();
  List<Ride> availableRides = [];
  String? _joinedRideId;
  final String currentUserId =
      'user123'; // Replace with FirebaseAuth.instance.currentUser!.uid
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _rideService.loadRides(context, (rides) {
      setState(() {
        availableRides = rides;
      });
    });
    _rideService.loadJoinedRide(context, (rideId) {
      setState(() {
        _joinedRideId = rideId;
      });
    });
    _rideService.addFakeRides(availableRides, (updatedRides) {
      setState(() {
        availableRides = updatedRides;
      });
    });
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasLoggedIn', false);
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Ride Share',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? _buildHomeTab(context)
          : _selectedIndex == 1
          ? _buildRidesTab(context)
          : _buildProfileTab(context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6B9EFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Rides',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find a Ride',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: RideOptionButton(
                  title: 'Create Ride',
                  subtitle: 'Offer a ride to other students',
                  backgroundColor: Color(0xFFF2E8D5),
                  backgroundImage: 'assets/images/create.png',
                  onTap: () {
                    showCreateRideDialog(
                      context,
                      _rideService,
                      availableRides,
                      (updatedRides) {
                        setState(() {
                          availableRides = updatedRides;
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: RideOptionButton(
                  title: 'Join Ride',
                  subtitle: 'Find a ride offered by other students',
                  backgroundColor: Color.fromARGB(209, 254, 227, 211),
                  backgroundImage: 'assets/images/join.png',
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Text(
            'Available Rides',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: availableRides.isEmpty
                ? _buildEmptyState()
                : ListView(
                    children: availableRides.map((ride) {
                      return RideListItem(
                        ride: ride,
                        onJoin: () => _rideService.joinRide(
                          context,
                          availableRides,
                          ride,
                          currentUserId,
                          (updatedRides) {
                            setState(() {
                              availableRides = updatedRides;
                              _joinedRideId = ride.id;
                            });
                          },
                        ),
                        onLeave: () => _rideService.leaveRide(
                          context,
                          availableRides,
                          ride,
                          _joinedRideId,
                          (updatedRides) {
                            setState(() {
                              availableRides = updatedRides;
                              _joinedRideId = null;
                            });
                          },
                        ),
                        onDelete: () => _rideService.deleteRide(
                          context,
                          availableRides,
                          ride,
                          _joinedRideId,
                          (updatedRides) {
                            setState(() {
                              availableRides = updatedRides;
                              if (_joinedRideId == ride.id) {
                                _joinedRideId = null;
                              }
                            });
                          },
                        ),
                        currentUserId: currentUserId,
                        hasJoinedRide: _joinedRideId != null,
                        isJoinedRide: _joinedRideId == ride.id,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRidesTab(BuildContext context) {
    if (_joinedRideId != null) {
      final joinedRide = availableRides.firstWhere(
        (ride) => ride.id == _joinedRideId,
        orElse: () {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Joined ride not found')));
          }
          return Ride(
            id: '',
            from: '',
            destination: '',
            seatsLeft: 0,
            date: '',
            time: '',
            genderPreference: '',
            vehicleType: '',
            creatorId: '',
          );
        },
      );
      if (joinedRide.id.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Joined Ride',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              RideListItem(
                ride: joinedRide,
                onJoin: () {},
                onLeave: () => _rideService.leaveRide(
                  context,
                  availableRides,
                  joinedRide,
                  _joinedRideId,
                  (updatedRides) {
                    setState(() {
                      availableRides = updatedRides;
                      _joinedRideId = null;
                    });
                  },
                ),
                onDelete: () {},
                currentUserId: currentUserId,
                hasJoinedRide: true,
                isJoinedRide: true,
              ),
            ],
          ),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Rides',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: availableRides.isEmpty
                ? _buildEmptyState()
                : ListView(
                    children: availableRides.map((ride) {
                      return RideListItem(
                        ride: ride,
                        onJoin: () => _rideService.joinRide(
                          context,
                          availableRides,
                          ride,
                          currentUserId,
                          (updatedRides) {
                            setState(() {
                              availableRides = updatedRides;
                              _joinedRideId = ride.id;
                            });
                          },
                        ),
                        onLeave: () => _rideService.leaveRide(
                          context,
                          availableRides,
                          ride,
                          _joinedRideId,
                          (updatedRides) {
                            setState(() {
                              availableRides = updatedRides;
                              _joinedRideId = null;
                            });
                          },
                        ),
                        onDelete: () => _rideService.deleteRide(
                          context,
                          availableRides,
                          ride,
                          _joinedRideId,
                          (updatedRides) {
                            setState(() {
                              availableRides = updatedRides;
                              if (_joinedRideId == ride.id) {
                                _joinedRideId = null;
                              }
                            });
                          },
                        ),
                        currentUserId: currentUserId,
                        hasJoinedRide: _joinedRideId != null,
                        isJoinedRide: _joinedRideId == ride.id,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    final userRides = availableRides
        .where((ride) => ride.creatorId == currentUserId)
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'User ID: $currentUserId',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Text(
            'Your Created Rides',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: userRides.isEmpty
                ? _buildEmptyState(message: 'No rides created')
                : ListView(
                    children: userRides.map((ride) {
                      return RideListItem(
                        ride: ride,
                        onJoin: () {},
                        onLeave: () {},
                        onDelete: () => _rideService.deleteRide(
                          context,
                          availableRides,
                          ride,
                          _joinedRideId,
                          (updatedRides) {
                            setState(() {
                              availableRides = updatedRides;
                              if (_joinedRideId == ride.id) {
                                _joinedRideId = null;
                              }
                            });
                          },
                        ),
                        currentUserId: currentUserId,
                        hasJoinedRide: _joinedRideId != null,
                        isJoinedRide: false,
                      );
                    }).toList(),
                  ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({String message = 'No rides available'}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, size: 50, color: Colors.grey),
          SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}
