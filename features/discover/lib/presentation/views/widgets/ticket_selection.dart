// import 'dart:developer';

// import 'package:deps/design/design.dart';
// import 'package:deps/features/features.dart';
// import 'package:deps/packages/auto_route.dart';
// import 'package:deps/packages/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// // part 'ticket_selection_cubit.dart';
// // part 'ticket_selection_state.dart';

// @RoutePage()
// class TicketSelectionPage extends StatefulWidget {
//   final String eventId;
  
//   const TicketSelectionPage({
//     super.key,
//     required this.eventId,
//   });

//   @override
//   State<TicketSelectionPage> createState() => _TicketSelectionPageState();
// }

// class _TicketSelectionPageState extends State<TicketSelectionPage> {
//   // late final TicketSelectionCubit _cubit;

//   @override
//   void initState() {
//     super.initState();
//     _cubit = $.get<TicketSelectionCubit>();
//     _cubit.loadEventData(widget.eventId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: FabColors.background,
//       body: BlocBuilder<TicketSelectionCubit, TicketSelectionState>(
//         bloc: _cubit,
//         builder: (context, state) {
//           return state.when(
//             initial: () => const Center(child: CircularProgressIndicator()),
//             loading: () => const Center(child: CircularProgressIndicator()),
//             error: (message) => _buildErrorView(message),
//             loaded: (event, tickets) => _buildLoadedView(event, tickets),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildErrorView(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             message,
//             style: FabTypography.bodyMediumRegular,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           FabButton.primary(
//             onPressed: () => _cubit.loadEventData(widget.eventId),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadedView(EventDetails event, List<TicketType> tickets) {
//     return SafeArea(
//       child: Column(
//         children: [
//           _buildAppBar(event.title),
//           _buildEventHeader(event),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             child: Text(
//               'Choose your ticket type',
//               style: FabTypography.displayBold20,
//             ),
//           ),
//           Expanded(
//             child: ListView.separated(
//               padding: const EdgeInsets.only(bottom: 16),
//               separatorBuilder: (_, __) => const SizedBox(height: 16),
//               itemCount: tickets.length,
//               itemBuilder: (_, index) {
//                 final ticket = tickets[index];
//                 return TicketCard(
//                   ticket: ticket,
//                   onTap: () => _cubit.selectTicket(ticket.id),
//                 );
//               },
//             ),
//           ),
//           _buildContinueSection(tickets),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppBar(String title) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           FloatingActionButton(
//             mini: true,
//             backgroundColor: FabColors.greyscale100,
//             onPressed: $.navigator.pop,
//             child: const Icon(Icons.chevron_left, color: FabColors.greyscale900),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               title,
//               style: FabTypography.displayBold20,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventHeader(EventDetails event) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Text(
//         '${event.dateRange} | ${event.time} WIB',
//         style: FabTypography.bodyMediumRegular.copyWith(
//           color: FabColors.greyscale600,
//         ),
//       ),
//     );
//   }

//   Widget _buildContinueSection(List<TicketType> tickets) {
//     final selectedTicket = tickets.firstWhere((t) => t.isSelected, orElse: () => tickets.first);
//     final formattedPrice = _formatCurrency(selectedTicket.price);

//     return Container(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total Payment',
//                 style: FabTypography.bodyMediumRegular,
//               ),
//               Text(
//                 formattedPrice,
//                 style: FabTypography.displayBold24,
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           FabButton.primary(
//             onPressed: () => $.navigator.push(
//               TravelPackRoute(
//                 eventId: widget.eventId,
//                 selectedTicket: selectedTicket,
//               ),
//             ),
//             child: const Text('Continue'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatCurrency(int amount) {
//     return 'Rp ${amount.toString().replaceAllMapped(
//       RegExp(r'(\d)(?=(\d{3})+$)'),
//       (match) => '${match[1]},',
//     )}';
//   }
// }

// class TicketCard extends StatelessWidget {
//   final TicketType ticket;
//   final VoidCallback onTap;

//   const TicketCard({
//     super.key,
//     required this.ticket,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: ticket.isSelected ? FabColors.primary : FabColors.greyscale200,
//             width: ticket.isSelected ? 2 : 1,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           color: ticket.isSelected ? FabColors.primary.withOpacity(0.05) : null,
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     ticket.name,
//                     style: FabTypography.displayBold18,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 if (ticket.type.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _getTypeColor(ticket.type),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       ticket.type,
//                       style: FabTypography.bodySmallBold.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.attach_money, size: 16, color: FabColors.greyscale600),
//                 const SizedBox(width: 4),
//                 Text(
//                   _formatCurrency(ticket.price),
//                   style: FabTypography.bodyMediumRegular,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.check_circle, size: 16, color: FabColors.greyscale600),
//                 const SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     ticket.description,
//                     style: FabTypography.bodySmallRegular,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.people, size: 16, color: _getSeatsColor(ticket.seatsLeft)),
//                 const SizedBox(width: 4),
//                 Text(
//                   '${ticket.seatsLeft} seats left',
//                   style: FabTypography.bodySmallRegular.copyWith(
//                     color: _getSeatsColor(ticket.seatsLeft),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getTypeColor(String type) {
//     switch (type.toLowerCase()) {
//       case 'regular': return Colors.green;
//       case 'premium': return FabColors.primary;
//       case 'vip': return Colors.amber;
//       default: return FabColors.greyscale400;
//     }
//   }

//   Color _getSeatsColor(int seatsLeft) {
//     if (seatsLeft <= 5) return Colors.red;
//     if (seatsLeft <= 10) return Colors.orange;
//     return FabColors.greyscale600;
//   }

//   String _formatCurrency(int amount) {
//     return 'Rp ${amount.toString().replaceAllMapped(
//       RegExp(r'(\d)(?=(\d{3})+$)'),
//       (match) => '${match[1]},',
//     )}';
//   }
// }