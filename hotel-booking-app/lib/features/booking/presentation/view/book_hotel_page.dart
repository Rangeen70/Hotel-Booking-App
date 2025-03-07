import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hotel_booking/features/booking/data/models/booking_model.dart';
import 'package:hotel_booking/features/booking/data/services/booking_service.dart';
import 'package:hotel_booking/features/dashboard/data/models/hotel_model.dart';

class BookHotelPage extends StatefulWidget {
  final HotelModel hotel;
  final Map<String, String> initialBookingData;

  const BookHotelPage({
    Key? key,
    required this.hotel,
    required this.initialBookingData,
  }) : super(key: key);

  @override
  State<BookHotelPage> createState() => _BookHotelPageState();
}

class _BookHotelPageState extends State<BookHotelPage> {
  final _formKey = GlobalKey<FormState>();
  final BookingService _bookingService = BookingService();
  bool _isLoading = false;

  late TextEditingController _checkInController;
  late TextEditingController _checkOutController;
  late TextEditingController _guestsController;
  late String _selectedRoom;

  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  @override
  void initState() {
    super.initState();

    // Initialize with provided data
    _checkInController = TextEditingController(
        text:
            _formatDateString(widget.initialBookingData['checkInDate'] ?? ''));
    _checkOutController = TextEditingController(
        text:
            _formatDateString(widget.initialBookingData['checkOutDate'] ?? ''));
    _guestsController =
        TextEditingController(text: widget.initialBookingData['guests'] ?? '1');
    _selectedRoom = widget.initialBookingData['room'] ?? 'standard';

    // Parse dates for validation
    try {
      _checkInDate =
          DateTime.parse(widget.initialBookingData['checkInDate'] ?? '');
      _checkOutDate =
          DateTime.parse(widget.initialBookingData['checkOutDate'] ?? '');
    } catch (e) {
      // Use default dates if parsing fails
      _checkInDate = DateTime.now().add(const Duration(days: 1));
      _checkOutDate = DateTime.now().add(const Duration(days: 8));
    }
  }

  String _formatDateString(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? _checkInDate ?? DateTime.now()
          : _checkOutDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: isCheckIn ? DateTime.now() : _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          _checkInController.text = DateFormat('yyyy-MM-dd').format(picked);

          // If check-out date is before new check-in date, update it
          if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
            _checkOutDate = picked.add(const Duration(days: 1));
            _checkOutController.text =
                DateFormat('yyyy-MM-dd').format(_checkOutDate!);
          }
        } else {
          _checkOutDate = picked;
          _checkOutController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final bookingData = BookingModel(
        checkInDate: _checkInController.text,
        checkOutDate: _checkOutController.text,
        guests: _guestsController.text,
        hotelId: widget.initialBookingData['hotelId'] ?? widget.hotel.id,
        room: _selectedRoom,
      );

      try {
        final result = await _bookingService.bookHotel(bookingData);

        setState(() {
          _isLoading = false;
        });

        if (!mounted) return;

        if (result['success']) {
          _showSuccessDialog();
        } else {
          _showErrorDialog(result['message']);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (!mounted) return;
        _showErrorDialog('An error occurred while processing your booking.');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Booking Successful'),
            ],
          ),
          content: const Text('Your hotel booking has been confirmed!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text('Booking Failed'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Hotel'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHotelInfoCard(),
                    const SizedBox(height: 24),
                    _buildBookingForm(),
                    const SizedBox(height: 24),
                    _buildRoomSelection(),
                    const SizedBox(height: 32),
                    _buildPriceDetails(),
                    const SizedBox(height: 32),
                    _buildBookButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHotelInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hotel.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${widget.hotel.city}, ${widget.hotel.address}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, size: 18, color: Colors.amber[700]),
                const SizedBox(width: 4),
                Text(
                  widget.hotel.rating.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Starting from ${widget.hotel.formattedPrice}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _checkInController,
                decoration: const InputDecoration(
                  labelText: 'Check-in Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a check-in date';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _checkOutController,
                decoration: const InputDecoration(
                  labelText: 'Check-out Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a check-out date';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _guestsController,
          decoration: const InputDecoration(
            labelText: 'Number of Guests',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.people),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter number of guests';
            }
            final int? guests = int.tryParse(value);
            if (guests == null || guests < 1) {
              return 'Must be at least 1 guest';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoomSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Room Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRoomOption(
          'standard',
          'Standard Room',
          '${widget.hotel.cheapestPrice} per night',
          'A cozy room with essential amenities',
        ),
        const SizedBox(height: 12),
        _buildRoomOption(
          'deluxe',
          'Deluxe Room',
          '${(widget.hotel.cheapestPrice * 1.5).toStringAsFixed(2)} per night',
          'Spacious room with premium amenities',
        ),
        const SizedBox(height: 12),
        _buildRoomOption(
          'suite',
          'Executive Suite',
          '${(widget.hotel.cheapestPrice * 2.5).toStringAsFixed(2)} per night',
          'Luxury suite with separate living area',
        ),
      ],
    );
  }

  Widget _buildRoomOption(
      String value, String title, String price, String description) {
    final bool isSelected = _selectedRoom == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRoom = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedRoom,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRoom = newValue;
                  });
                }
              },
              activeColor: Colors.blue,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails() {
    // Calculate the price based on dates and room type
    int nights = 1;
    if (_checkInDate != null && _checkOutDate != null) {
      nights = _checkOutDate!.difference(_checkInDate!).inDays;
      nights = nights < 1 ? 1 : nights;
    }

    double roomPrice = widget.hotel.cheapestPrice;
    if (_selectedRoom == 'deluxe') {
      roomPrice *= 1.5;
    } else if (_selectedRoom == 'suite') {
      roomPrice *= 2.5;
    }

    final double subtotal = roomPrice * nights;
    final double tax = subtotal * 0.1; // 10% tax
    final double total = subtotal + tax;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceRow(
                'Room Price',
                '\$${roomPrice.toStringAsFixed(2)} x $nights night(s)',
                '\$${subtotal.toStringAsFixed(2)}'),
            _buildPriceRow(
                'Taxes & Fees (10%)', '', '\$${tax.toStringAsFixed(2)}'),
            const Divider(thickness: 1),
            _buildPriceRow('Total Amount', '', '\$${total.toStringAsFixed(2)}',
                isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String subtitle, String amount,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          'Confirm Booking',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
