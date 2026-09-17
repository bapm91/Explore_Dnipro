import 'package:explore_dnipro/features/explore/presentation/cubit/explore_state.dart';
import 'package:flutter/material.dart';

class ExploreMapOverlay extends StatelessWidget {
  const ExploreMapOverlay({
    required this.status,
    required this.hasPlaces,
    required this.hasPendingMapSearch,
    required this.onSearchArea,
    required this.onRetry,
    super.key,
  });

  final ExploreStatus status;
  final bool hasPlaces;
  final bool hasPendingMapSearch;
  final VoidCallback onSearchArea;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (status == ExploreStatus.loading) {
      return _LoadingOverlay(hasPlaces: hasPlaces);
    }

    if (hasPendingMapSearch) {
      return _SearchAreaButton(onPressed: onSearchArea);
    }

    return switch (status) {
      ExploreStatus.empty => const _EmptyOverlay(),
      ExploreStatus.failure => _ErrorOverlay(onRetry: onRetry),
      ExploreStatus.initial ||
      ExploreStatus.success ||
      ExploreStatus.loading => const SizedBox.shrink(),
    };
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({required this.hasPlaces});

  final bool hasPlaces;

  @override
  Widget build(BuildContext context) {
    if (hasPlaces) {
      return Positioned(
        top: MediaQuery.paddingOf(context).top + 16,
        left: 16,
        right: 16,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Завантаження...'),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Завантаження місць...'),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyOverlay extends StatelessWidget {
  const _EmptyOverlay();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Text(
            'У цій області нічого не знайдено',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _SearchAreaButton extends StatelessWidget {
  const _SearchAreaButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.paddingOf(context).bottom + 16,
      left: 16,
      right: 16,
      child: Center(
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.search),
          label: const Text('Шукати в цій області'),
        ),
      ),
    );
  }
}

class _ErrorOverlay extends StatelessWidget {
  const _ErrorOverlay({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 16,
      left: 16,
      right: 16,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.error_outline),
              const SizedBox(width: 12),
              const Expanded(child: Text('Не вдалося завантажити місця')),
              TextButton(
                onPressed: onRetry,
                child: const Text('Спробувати ще раз'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
