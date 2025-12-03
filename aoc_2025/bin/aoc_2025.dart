import 'day1.dart' as day1;
import 'day2.dart' as day2;

void main(List<String> arguments) async {
  print('');
  for (final day in [day1.main, day2.main]) {
    await day(arguments);
    print('');
  }
}
