import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc() : super(MessagesInitial()) {
    on<LoadMessagesData>(_onLoadMessagesData);
  }

  FutureOr<void> _onLoadMessagesData(
    LoadMessagesData event,
    Emitter<MessagesState> emit,
  ) async {
    emit(MessagesLoading());
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final dummyMessages = [
      const MessagePreview(
        name: 'Sarah Jenkins',
        time: '10:42 AM',
        preview: 'Are we still on for the study group at the library later?',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD4SQCp0Q6FfYQqTc0bnv186gHtHpSe1STE3uAu-kcMSFIwVuMKn2fxXxURu2zemTA6lsytWcmlW7WB-KSxRFtRwUtYuep7dCc7xlhTSjg3PTSs0smMxfq7RsFUSTKd8Yf2yeuPxtAX8nXI7MNYhvH4xyJmxcIh7v_9lv6WoGX1Dkr9Dd7w0ZywiGa-uTNPvPp4bEZ_Xn25OFlaUeVHdCvJnvw-iQL5Zf_y4Opg0fZVHpnyrf6eakGp4__KIFw08wVrEUdyIkdkMtYt',
        unreadCount: 2,
        isOnline: true,
      ),
      const MessagePreview(
        name: 'David Chen',
        time: 'Yesterday',
        preview: 'Thanks for sharing those lecture notes, they were really helpful for the assignment.',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBwHW0i8_2cPNjBrpzd3k-vUWpRkyqi-4h7rA-ysCoedFw5u7b68Qv2JqWvNoCIF7pB2CpRdww-I6AxnJ_s4CS2Rw6Q8LI-OzpyehKYcAQpl5ojrt6zzIPp2Av9auoyEPko5vxNHCR1avybi_TE_lFcDGhRzmqq0IWZy37y2tQLPsCsMxU-L7N5vPPNFCJ1ciz27TvWK1OHWnLnTRV82sW_7jnw-QfPAwDSYKOP5YyL75w-xL_WL-BOnwwh0IG83dUOMjKFVLlZkGB5',
      ),
      const MessagePreview(
        name: 'Emily Rodriguez',
        time: 'Mon',
        preview: 'Sounds like a plan. See you then!',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBd2FRF9Mlg651nUSo-SOYDH714kdqXYLl4Bqh3qlvfgIsiUWhR0IOTymxSKiY1xSDN0RRi2n1e1F-bNtRHW1MxbdZ1Vj4Vc2fOqBYJh9a6klwlVzJ7nP-AoNLmdcEb8NbN-E-u06BNJDQblUhwleid17fFiHWleROORVEbNPgim1Y_E5DPic-N9JUqGCDPBFEwHpu9PaGtwMXRITLhfTWnwYuhPpVTiXqPI2f9CrKTp0O095EcflFWngZFWCMbT8bCBH8pmbmf3ctj',
        isRead: true,
      ),
      const MessagePreview(
        name: 'Michael Johnson',
        time: 'Oct 12',
        preview: 'I uploaded the final draft to the shared drive.',
        initials: 'MJ',
      ),
    ];

    emit(MessagesSuccess(messages: dummyMessages));
  }
}
