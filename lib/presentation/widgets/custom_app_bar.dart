import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showAvatar;
  final bool? centerTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showAvatar = true,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: 0,
      leading: leading,
      centerTitle: centerTitle,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
          height: 1.0,
        ),
      ),
      title: titleWidget ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showAvatar)
                BlocBuilder<AppUserCubit, AppUserState>(
                  builder: (context, state) {
                    String? avatarUrl;
                    if (state is AppUserLoggedIn && state.user.avatarUrl.isNotEmpty) {
                      avatarUrl = state.user.avatarUrl;
                    }
                    
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        image: avatarUrl != null
                            ? DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: avatarUrl == null
                          ? Icon(Icons.person, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant)
                          : null,
                    );
                  },
                ),
              if (showAvatar) const SizedBox(width: 12),
              Text(
                title ?? 'Kovalen',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
      actions: actions ?? [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.primary),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
