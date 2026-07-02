import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../services/api_service.dart';

class HeroLiveCard extends StatelessWidget {
  const HeroLiveCard({
    super.key,
    this.match,
    this.apiService,
    this.onTap,
    this.timeout = const Duration(seconds: 15),
  });

  final MatchModel? match;
  final ApiService? apiService;
  final VoidCallback? onTap;
  final Duration timeout;

  @override
  Widget build(BuildContext context) {
    final selectedMatch = match;

    if (selectedMatch != null) {
      return _HeroLiveCardContent(match: selectedMatch, onTap: onTap);
    }

    final service = apiService;
    if (service == null) {
      return const _CardMessage(
        icon: Icons.sports_cricket_rounded,
        title: 'Live match unavailable',
        message: 'No match data was provided.',
      );
    }

    return FutureBuilder<List<MatchModel>>(
      future: service.getLiveMatches().timeout(timeout),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _CardShell(
            child: Center(
              child: SizedBox.square(
                dimension: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const _CardMessage(
            icon: Icons.cloud_off_rounded,
            title: 'Unable to load live match',
            message: 'Please try again shortly.',
          );
        }

        final matches = snapshot.data ?? const <MatchModel>[];
        if (matches.isEmpty) {
          return const _CardMessage(
            icon: Icons.event_busy_rounded,
            title: 'No live matches',
            message: 'Live scores will appear here when a match starts.',
          );
        }

        return _HeroLiveCardContent(match: matches.first, onTap: onTap);
      },
    );
  }
}

class _HeroLiveCardContent extends StatelessWidget {
  const _HeroLiveCardContent({required this.match, this.onTap});

  final MatchModel match;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final compact = MediaQuery.sizeOf(context).width < 380;
    final padding = compact ? 18.0 : 22.0;

    return _CardShell(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _LiveBadge(),
              const SizedBox(width: 10),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _InfoChip(
                    text: _safe(match.matchType, 'Match'),
                    icon: Icons.sports_cricket_rounded,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 16 : 20),
          Text(
            _safe(match.series, 'Series TBA'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _Teams(
            team1: _safe(match.team1, 'Team 1'),
            team2: _safe(match.team2, 'Team 2'),
            compact: compact,
          ),
          SizedBox(height: compact ? 18 : 22),
          Text(
            _safe(match.liveScore, 'Score unavailable'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontSize: compact ? 34 : 42,
              fontWeight: FontWeight.w900,
              height: 1.02,
            ),
          ),
          const SizedBox(height: 10),
          _InfoChip(
            text: 'Overs ${_safe(match.overs, 'unavailable')}',
            icon: Icons.av_timer_rounded,
            prominent: true,
          ),
          SizedBox(height: compact ? 18 : 22),
          Divider(color: Colors.white.withValues(alpha: 0.16), height: 1),
          const SizedBox(height: 16),
          _MetaRow(
            icon: Icons.stadium_rounded,
            text: _safe(match.venue, 'Venue TBA'),
          ),
          const SizedBox(height: 10),
          _MetaRow(
            icon: Icons.calendar_month_rounded,
            text: _date(context, match.date),
          ),
          SizedBox(height: compact ? 18 : 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('View Match'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F172A),
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.48),
                disabledForegroundColor:
                const Color(0xFF0F172A).withValues(alpha: 0.56),
                minimumSize: Size.fromHeight(compact ? 46 : 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _safe(Object? value, String fallback) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  static String _date(BuildContext context, Object? value) {
    if (value is DateTime) {
      return MaterialLocalizations.of(context).formatMediumDate(value);
    }
    return _safe(value, 'Date TBA');
  }
}

class _LiveBadge extends StatefulWidget {
  const _LiveBadge();

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.86, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.55, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF0),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFCBD2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: const Icon(
                  Icons.circle,
                  size: 9,
                  color: Color(0xFFE11D48),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'LIVE',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFFBE123C),
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Teams extends StatelessWidget {
  const _Teams({
    required this.team1,
    required this.team2,
    required this.compact,
  });

  final String team1;
  final String team2;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: Colors.white,
      fontSize: compact ? 22 : 26,
      fontWeight: FontWeight.w900,
      height: 1.12,
    );
    final vsStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Colors.white.withValues(alpha: 0.68),
      fontWeight: FontWeight.w900,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            team1,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('vs', style: vsStyle),
        ),
        Expanded(
          child: Text(
            team2,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.text,
    required this.icon,
    this.prominent = false,
  });

  final String text;
  final IconData icon;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: prominent ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: prominent ? 12 : 10,
          vertical: prominent ? 8 : 7,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.88)),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.82)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardMessage extends StatelessWidget {
  const _CardMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _CardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.74),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.24),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF1E3A8A),
              ],
            ),
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}