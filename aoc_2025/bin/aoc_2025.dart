import 'day1.dart' as day1;
import 'day2.dart' as day2;
import 'day3.dart' as day3;

void main(List<String> arguments) async {
  print('');
  for (final day in [day1.main, day2.main, day3.main]) {
    await day(arguments);
    print('');
  }
}
