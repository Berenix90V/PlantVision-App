import 'package:flutter/material.dart';

class FutureObserver<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T) onSuccess;
  final Widget Function(Object?) onError;
  final Widget Function()? onWaiting;

  const FutureObserver(
      {Key? key,
      required this.future,
      required this.onSuccess,
      required this.onError,
      this.onWaiting})
      : super(key: key);

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
