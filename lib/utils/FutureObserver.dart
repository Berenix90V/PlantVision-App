import 'package:flutter/material.dart';

/// [FutureBuilder] class that observes a [Future<T>] and executes [onSuccess]
/// when data has been received, [onError] when an error occurred or either [defaultOnWaiting]
/// or a given [onWaiting] function when then future is yet to be completed
class FutureObserver<T> extends StatelessWidget {
  /// The [Future] that will be observed
  final Future<T> future;

  /// A function returning a [Widget] when data has arrived
  final Widget Function(T) onSuccess;

  /// A function returning a [Widget] when there has been an error
  final Widget Function(Object?) onError;

  /// A function returning a [Widget] when there is neither data nor an error
  final Widget Function()? onWaiting;

  const FutureObserver(
      {Key? key,
      required this.future,
      required this.onSuccess,
      required this.onError,
      this.onWaiting})
      : super(key: key);

  /// A default [Widget] for when no [onWaiting] function has been defined
  Widget get defaultOnWaiting =>
      const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return onError(snapshot.error);
        }
        if (snapshot.hasData) {
          return onSuccess(snapshot.data!);
        }
        return onWaiting != null ? onWaiting!() : defaultOnWaiting;
      },
    );
  }
}
