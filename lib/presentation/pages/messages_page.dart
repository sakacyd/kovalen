import 'package:flutter/material.dart';
import '../../core/theme/app_pallete.dart';
import '../widgets/chat_list_item.dart';

class MessagesPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const MessagesPage());
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppPallete.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppPallete.stroke,
            height: 1.0,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA6_8ztsLxf2Z3wE8lVk4oCeZJu4O9ZeXP0EBNHkP9DnjR48r0uVG-u8yPqdrYi96rRBL8N7u1BtvOroR7SQ1FzUuqpSDEqBovbs-N6w9Ib28x9rOzNw0kYvG8lwJkAFqHSx5WO5whMY8uUD2l8iLtyNB2DKhrakSshngwdeHQWYqY8kvdiirwgD5HttE3zJZrodA600Jotxqrkf5D9ec5Bn4gH11I3hSVICNxbtVrIfiLXiILYnx_YYasnpPHzjPTJE-4nQ2kLAatv',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Kovalen',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppPallete.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppPallete.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Cari kontak atau pesan...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPallete.textOutline,
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppPallete.textOutline),
                    filled: true,
                    fillColor: AppPallete.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppPallete.stroke),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppPallete.stroke),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppPallete.primary),
                    ),
                  ),
                ),
              ),
            ),
            
            // Messages List Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppPallete.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppPallete.stroke),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListView(
                    children: const [
                      ChatListItem(
                        name: 'Sarah Jenkins',
                        time: '10:42 AM',
                        messagePreview: 'Are we still on for the study group at the library later?',
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD4SQCp0Q6FfYQqTc0bnv186gHtHpSe1STE3uAu-kcMSFIwVuMKn2fxXxURu2zemTA6lsytWcmlW7WB-KSxRFtRwUtYuep7dCc7xlhTSjg3PTSs0smMxfq7RsFUSTKd8Yf2yeuPxtAX8nXI7MNYhvH4xyJmxcIh7v_9lv6WoGX1Dkr9Dd7w0ZywiGa-uTNPvPp4bEZ_Xn25OFlaUeVHdCvJnvw-iQL5Zf_y4Opg0fZVHpnyrf6eakGp4__KIFw08wVrEUdyIkdkMtYt',
                        unreadCount: 2,
                        isOnline: true,
                      ),
                      ChatListItem(
                        name: 'David Chen',
                        time: 'Yesterday',
                        messagePreview: 'Thanks for sharing those lecture notes, they were really helpful for the assignment.',
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBwHW0i8_2cPNjBrpzd3k-vUWpRkyqi-4h7rA-ysCoedFw5u7b68Qv2JqWvNoCIF7pB2CpRdww-I6AxnJ_s4CS2Rw6Q8LI-OzpyehKYcAQpl5ojrt6zzIPp2Av9auoyEPko5vxNHCR1avybi_TE_lFcDGhRzmqq0IWZy37y2tQLPsCsMxU-L7N5vPPNFCJ1ciz27TvWK1OHWnLnTRV82sW_7jnw-QfPAwDSYKOP5YyL75w-xL_WL-BOnwwh0IG83dUOMjKFVLlZkGB5',
                      ),
                      ChatListItem(
                        name: 'Emily Rodriguez',
                        time: 'Mon',
                        messagePreview: 'Sounds like a plan. See you then!',
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBd2FRF9Mlg651nUSo-SOYDH714kdqXYLl4Bqh3qlvfgIsiUWhR0IOTymxSKiY1xSDN0RRi2n1e1F-bNtRHW1MxbdZ1Vj4Vc2fOqBYJh9a6klwlVzJ7nP-AoNLmdcEb8NbN-E-u06BNJDQblUhwleid17fFiHWleROORVEbNPgim1Y_E5DPic-N9JUqGCDPBFEwHpu9PaGtwMXRITLhfTWnwYuhPpVTiXqPI2f9CrKTp0O095EcflFWngZFWCMbT8bCBH8pmbmf3ctj',
                        isRead: true,
                      ),
                      ChatListItem(
                        name: 'Michael Johnson',
                        time: 'Oct 12',
                        messagePreview: 'I uploaded the final draft to the shared drive.',
                        initials: 'MJ',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
