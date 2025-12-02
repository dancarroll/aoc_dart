import 'day1.dart' as day1;

void main(List<String> arguments) async {
  print('');
  for (final day in [day1.main]) {
    await day(arguments);
    print('');
  }
}
