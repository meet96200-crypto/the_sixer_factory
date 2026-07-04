import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/match_model.dart';
import '../../models/user_model.dart';
import '../../providers/home_provider.dart';
import '../../providers/search_provider.dart';
import '../match/match_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    final query = value.trim();

    setState(() => _query = query);
    _debounce?.cancel();

    if (query.isEmpty) {
      context.read<SearchProvider>().clearSearch();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _runSearch(query);
    });
  }

  Future<void> _runSearch(String query) async {
    final homeProvider = context.read<HomeProvider>();
    final allMatches = _combinedMatches(
      homeProvider.liveMatches,
      homeProvider.upcomingMatches,
    );

    await context.read<SearchProvider>().search(
      query: query,
      allMatches: allMatches,
    );
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() => _query = '');
    context.read<SearchProvider>().clearSearch();
    _searchFocusNode.requestFocus();
  }

  List<MatchModel> _combinedMatches(
      List<MatchModel> liveMatches,
      List<MatchModel> upcomingMatches,
      ) {
    final matchesById = <String, MatchModel>{};

    for (final match in [...liveMatches, ...upcomingMatches]) {
      final key = match.id.trim().isNotEmpty
          ? match.id
          : '${match.name}-${match.date}-${match.team1}-${match.team2}';
      matchesById[key] = match;
    }

    return matchesById.values.toList();
  }

  void _openMatch(MatchModel match) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MatchDetailsScreen(match: match),
      ),
    );
  }

  void _openUser(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _UserProfilePlaceholderScreen(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasQuery = _query.isNotEmpty;
    final hasResults =
        searchProvider.users.isNotEmpty || searchProvider.matches.isNotEmpty;
    final hasError = searchProvider.error.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _onQueryChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search users or matches',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: hasQuery
                ? IconButton(
              tooltip: 'Clear search',
              icon: const Icon(Icons.close),
              onPressed: _clearSearch,
            )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.72,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (searchProvider.isLoading) const LinearProgressIndicator(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: !hasQuery
                            ? const _SearchStateView(
                          key: ValueKey('idle'),
                          icon: Icons.manage_search,
                          title: 'Start searching',
                          message: 'Find cricket fans, teams, and matches.',
                        )
                            : hasError
                            ? _SearchStateView(
                          key: const ValueKey('error'),
                          icon: Icons.error_outline,
                          title: 'Search failed',
                          message: _cleanError(searchProvider.error),
                        )
                            : searchProvider.isLoading && !hasResults
                            ? const _SearchStateView(
                          key: ValueKey('loading'),
                          icon: Icons.search,
                          title: 'Searching',
                          message: 'Looking through users and matches.',
                        )
                            : !hasResults
                            ? _SearchStateView(
                          key: const ValueKey('empty'),
                          icon: Icons.search_off,
                          title: 'No results found',
                          message:
                          'Try a player, team, series, or user name.',
                        )
                            : _SearchResultsList(
                          key: const ValueKey('results'),
                          users: searchProvider.users,
                          matches: searchProvider.matches,
                          onUserTap: _openUser,
                          onMatchTap: _openMatch,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cleanError(String error) {
    return error.replaceFirst('Exception: ', '').trim();
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    super.key,
    required this.users,
    required this.matches,
    required this.onUserTap,
    required this.onMatchTap,
  });

  final List<UserModel> users;
  final List<MatchModel> matches;
  final ValueChanged<UserModel> onUserTap;
  final ValueChanged<MatchModel> onMatchTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        if (matches.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.sports_cricket,
            title: 'Matches',
            count: matches.length,
          ),
          const SizedBox(height: 10),
          ...matches.map(
                (match) => _MatchResultCard(
              match: match,
              onTap: () => onMatchTap(match),
            ),
          ),
          const SizedBox(height: 18),
        ],
        if (users.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.people_outline,
            title: 'Users',
            count: users.length,
          ),
          const SizedBox(height: 10),
          ...users.map(
                (user) => _UserResultCard(
              user: user,
              onTap: () => onUserTap(user),
            ),
          ),
        ],
      ],
    );
  }
}

class _MatchResultCard extends StatelessWidget {
  const _MatchResultCard({
    required this.match,
    required this.onTap,
  });

  final MatchModel match;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = match.matchStarted && !match.matchEnded
        ? Colors.greenAccent
        : colorScheme.primary;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TeamLogo(url: match.team1Logo, label: match.team1),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _teamsLabel(match),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match.matchType.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _TeamLogo(url: match.team2Logo, label: match.team2),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.circle, size: 9, color: statusColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      match.status.trim().isEmpty ? match.date : match.status,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              if (match.venue.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        match.venue,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _teamsLabel(MatchModel match) {
    final team1 = match.team1.trim().isEmpty ? 'Team 1' : match.team1.trim();
    final team2 = match.team2.trim().isEmpty ? 'Team 2' : match.team2.trim();
    return '$team1 vs $team2';
  }
}

class _UserResultCard extends StatelessWidget {
  const _UserResultCard({
    required this.user,
    required this.onTap,
  });

  final UserModel user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final name = user.name.trim().isEmpty ? 'Cricket Fan' : user.name.trim();
    final subtitle = user.favoriteTeam.trim().isNotEmpty
        ? 'Favorite team: ${user.favoriteTeam}'
        : user.email;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage: user.photoUrl.trim().isEmpty
              ? null
              : NetworkImage(user.photoUrl.trim()),
          child: user.photoUrl.trim().isEmpty
              ? Text(
            name[0].toUpperCase(),
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          )
              : null,
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle.trim().isEmpty ? 'No profile details yet' : subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _TeamLogo extends StatelessWidget {
  const _TeamLogo({
    required this.url,
    required this.label,
  });

  final String url;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: 24,
      backgroundColor: colorScheme.surfaceContainerHighest,
      backgroundImage: url.trim().isEmpty ? null : NetworkImage(url.trim()),
      child: url.trim().isEmpty
          ? Icon(
        Icons.sports_cricket,
        size: 22,
        color: colorScheme.onSurfaceVariant,
      )
          : null,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
  });

  final IconData icon;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Badge(
          label: Text('$count'),
          backgroundColor: colorScheme.primaryContainer,
          textColor: colorScheme.onPrimaryContainer,
        ),
      ],
    );
  }
}

class _SearchStateView extends StatelessWidget {
  const _SearchStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.16),
        Icon(icon, size: 64, color: colorScheme.primary),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _UserProfilePlaceholderScreen extends StatelessWidget {
  const _UserProfilePlaceholderScreen({
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final name = user.name.trim().isEmpty ? 'Cricket Fan' : user.name.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: user.photoUrl.trim().isEmpty
                            ? null
                            : NetworkImage(user.photoUrl.trim()),
                        child: user.photoUrl.trim().isEmpty
                            ? Text(
                          name[0].toUpperCase(),
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                            : null,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.email,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (user.bio.trim().isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          user.bio,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _ProfileInfoTile(
                icon: Icons.public,
                title: 'Country',
                value: user.country.trim().isEmpty
                    ? 'Not selected'
                    : user.country.trim(),
              ),
              _ProfileInfoTile(
                icon: Icons.favorite_outline,
                title: 'Favorite Team',
                value: user.favoriteTeam.trim().isEmpty
                    ? 'Not selected'
                    : user.favoriteTeam.trim(),
              ),
              _ProfileInfoTile(
                icon: Icons.star_outline,
                title: 'Favorite Player',
                value: user.favoritePlayer.trim().isEmpty
                    ? 'Not selected'
                    : user.favoritePlayer.trim(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}